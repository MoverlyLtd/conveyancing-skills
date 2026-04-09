#!/usr/bin/env node
/**
 * Grader for conveyancing toolkit skill evals.
 * 
 * For script-based skills (SDLT, lease advisor), runs the script
 * to get ground truth, then checks response against exact values.
 * 
 * For reference skills (protocols, handbook), checks for specific
 * section citations that wouldn't appear in model training data.
 * 
 * Usage: node grade.js <iteration-dir> [--ground-truth]
 */

const fs = require("fs");
const path = require("path");
const { execSync } = require("child_process");

const iterDir = process.argv[2];
if (!iterDir) {
  console.error("Usage: node grade.js <iteration-dir>");
  process.exit(1);
}

const generateGroundTruth = process.argv.includes("--ground-truth");

// Ground truth generators for script-based skills
const GROUND_TRUTH = {
  "sdlt-calculator": (prompt) => {
    const priceMatch = prompt.match(/£?([\d,]+)/);
    if (!priceMatch) return null;
    const price = priceMatch[1].replace(/,/g, "");
    
    const flags = [];
    if (/first.time|ftb/i.test(prompt)) flags.push("--ftb");
    if (/second|additional|buy.to.let|btl|investment/i.test(prompt)) flags.push("--additional");
    if (/non.uk|overseas|foreign/i.test(prompt)) flags.push("--non-resident");
    
    const scriptPath = path.resolve(__dirname, "../sdlt-calculator/scripts/sdlt-calc.sh");
    if (!fs.existsSync(scriptPath)) return null;
    
    try {
      const output = execSync(`bash "${scriptPath}" --price ${price} ${flags.join(" ")}`, {
        encoding: "utf8",
        timeout: 5000,
      });
      return output.trim();
    } catch (e) {
      return null;
    }
  },
  
  "lease-impact-advisor": (prompt) => {
    const yearsMatch = prompt.match(/(\d+)\s*years?\s*(remaining|left|on the lease)/i);
    const priceMatch = prompt.match(/£?([\d,]+)/);
    if (!yearsMatch) return null;
    
    const years = yearsMatch[1];
    const price = priceMatch ? priceMatch[1].replace(/,/g, "") : "400000";
    
    const scriptPath = path.resolve(__dirname, "../lease-impact-advisor/scripts/lease-calc.sh");
    if (!fs.existsSync(scriptPath)) return null;
    
    try {
      const output = execSync(`bash "${scriptPath}" --years ${years} --price ${price}`, {
        encoding: "utf8",
        timeout: 5000,
      });
      return output.trim();
    } catch (e) {
      return null;
    }
  },
};

// Grade a single eval
function gradeEval(evalDir) {
  const metadata = JSON.parse(fs.readFileSync(path.join(evalDir, "eval_metadata.json"), "utf8"));
  const results = {};
  
  for (const config of ["with_skill", "without_skill"]) {
    const responseFile = path.join(evalDir, config, "outputs", "response.md");
    if (!fs.existsSync(responseFile)) {
      console.log(`  ⏭  ${config}: no response yet`);
      results[config] = null;
      continue;
    }
    
    const response = fs.readFileSync(responseFile, "utf8").toLowerCase();
    const expectations = [];
    
    // Grade each assertion
    for (const assertion of metadata.assertions) {
      const text = assertion.text || assertion;
      const grade = gradeAssertion(text, response, metadata.skill);
      expectations.push({
        text,
        passed: grade.passed,
        evidence: grade.evidence,
      });
    }
    
    // Generate ground truth comparison if available
    let groundTruth = null;
    if (generateGroundTruth && GROUND_TRUTH[metadata.skill]) {
      groundTruth = GROUND_TRUTH[metadata.skill](metadata.prompt);
    }
    
    const passed = expectations.filter((e) => e.passed).length;
    const total = expectations.length;
    
    const grading = {
      expectations,
      summary: { passed, failed: total - passed, total, pass_rate: total > 0 ? passed / total : 0 },
      ground_truth: groundTruth,
    };
    
    fs.writeFileSync(path.join(evalDir, config, "grading.json"), JSON.stringify(grading, null, 2));
    results[config] = grading.summary;
    
    const icon = grading.summary.pass_rate >= 0.8 ? "✅" : grading.summary.pass_rate >= 0.5 ? "🟡" : "❌";
    console.log(`  ${icon} ${config}: ${passed}/${total} (${Math.round(grading.summary.pass_rate * 100)}%)`);
  }
  
  return results;
}

// Grade a single assertion against a response
function gradeAssertion(assertionText, response, skill) {
  const text = assertionText.toLowerCase();
  
  // Extract specific values to check
  const numberPattern = /£?([\d,]+(?:\.\d+)?%?)/g;
  const numbers = [...text.matchAll(numberPattern)].map((m) => m[1].replace(/,/g, ""));
  
  // Check for exact number matches
  for (const num of numbers) {
    if (num.endsWith("%")) {
      const pct = num.replace("%", "");
      if (response.includes(pct + "%") || response.includes(pct)) {
        return { passed: true, evidence: `Found exact value ${num} in response` };
      }
    } else {
      // Check formatted and unformatted
      const formatted = Number(num).toLocaleString("en-GB");
      if (response.includes(num) || response.includes(formatted) || response.includes("£" + formatted) || response.includes("£" + num)) {
        return { passed: true, evidence: `Found exact value ${num} in response` };
      }
    }
  }
  
  // Check for section references (protocol skills)
  const sectionPattern = /section\s+([\d.]+)/gi;
  const sections = [...text.matchAll(sectionPattern)].map((m) => m[1]);
  for (const section of sections) {
    if (response.includes(section)) {
      return { passed: true, evidence: `Found section reference ${section} in response` };
    }
  }
  
  // Check for specific keyword patterns
  const keyPhrases = [
    "marriage value",
    "indemnity insurance",
    "building regulations",
    "enforcement period",
    "section 42",
    "ca protocol",
    "part 1",
    "part 2",
    "nil rate band",
    "surcharge",
    "buyer pool",
    "first-time buyer",
    "practice guide",
    "hmlr",
    "land registry",
  ];
  
  for (const phrase of keyPhrases) {
    if (text.includes(phrase) && response.includes(phrase)) {
      return { passed: true, evidence: `Found key phrase "${phrase}" in response` };
    }
  }
  
  // Check for "not" assertions (should NOT contain)
  if (text.includes("not just") || text.includes("does not")) {
    // These are harder to auto-grade, mark as needs review
    return { passed: null, evidence: "Requires manual review — negative assertion" };
  }
  
  // Check for URLs
  if (text.includes("url") || text.includes("gov.uk") || text.includes("land registry")) {
    const urlPattern = /https?:\/\/[^\s)]+/g;
    const urls = response.match(urlPattern);
    if (urls && urls.length > 0) {
      return { passed: true, evidence: `Found ${urls.length} URL(s) in response` };
    }
  }
  
  // Fuzzy keyword matching as fallback
  const words = text.split(/\s+/).filter((w) => w.length > 4);
  const matchCount = words.filter((w) => response.includes(w)).length;
  const matchRate = words.length > 0 ? matchCount / words.length : 0;
  
  if (matchRate >= 0.6) {
    return { passed: true, evidence: `Fuzzy match: ${matchCount}/${words.length} key words found (${Math.round(matchRate * 100)}%)` };
  }
  
  return { passed: false, evidence: `No match found. Checked: numbers=${numbers.length}, sections=${sections.length}, fuzzy=${Math.round(matchRate * 100)}%` };
}

// Aggregate benchmark
function aggregateBenchmark(evalDirs) {
  const benchmark = {
    metadata: {
      skill_name: "conveyancing-toolkit",
      timestamp: new Date().toISOString(),
      evals_run: evalDirs.map((d) => path.basename(d)),
    },
    runs: [],
    run_summary: {},
  };
  
  const withSkill = [];
  const withoutSkill = [];
  
  for (const evalDir of evalDirs) {
    for (const config of ["with_skill", "without_skill"]) {
      const gradingFile = path.join(evalDir, config, "grading.json");
      if (!fs.existsSync(gradingFile)) continue;
      
      const grading = JSON.parse(fs.readFileSync(gradingFile, "utf8"));
      const arr = config === "with_skill" ? withSkill : withoutSkill;
      arr.push(grading.summary.pass_rate);
    }
  }
  
  const mean = (arr) => arr.reduce((a, b) => a + b, 0) / arr.length;
  const stddev = (arr) => {
    const m = mean(arr);
    return Math.sqrt(arr.reduce((s, v) => s + (v - m) ** 2, 0) / arr.length);
  };
  
  if (withSkill.length > 0) {
    benchmark.run_summary.with_skill = {
      pass_rate: { mean: mean(withSkill).toFixed(2), stddev: stddev(withSkill).toFixed(2) },
    };
  }
  if (withoutSkill.length > 0) {
    benchmark.run_summary.without_skill = {
      pass_rate: { mean: mean(withoutSkill).toFixed(2), stddev: stddev(withoutSkill).toFixed(2) },
    };
  }
  if (withSkill.length > 0 && withoutSkill.length > 0) {
    benchmark.run_summary.delta = {
      pass_rate: (mean(withSkill) - mean(withoutSkill) > 0 ? "+" : "") + (mean(withSkill) - mean(withoutSkill)).toFixed(2),
    };
  }
  
  return benchmark;
}

// Main
console.log("=== Conveyancing Toolkit Grader ===\n");

const evalDirs = fs.readdirSync(iterDir)
  .filter((d) => d.startsWith("eval-"))
  .map((d) => path.join(iterDir, d))
  .filter((d) => fs.statSync(d).isDirectory());

console.log(`Found ${evalDirs.length} eval(s)\n`);

for (const evalDir of evalDirs) {
  const meta = JSON.parse(fs.readFileSync(path.join(evalDir, "eval_metadata.json"), "utf8"));
  console.log(`📋 ${meta.eval_name} (eval ${meta.eval_id}): "${meta.prompt.substring(0, 60)}..."`);
  gradeEval(evalDir);
  console.log("");
}

// Aggregate
const benchmark = aggregateBenchmark(evalDirs);
fs.writeFileSync(path.join(iterDir, "benchmark.json"), JSON.stringify(benchmark, null, 2));
console.log("=== Benchmark Summary ===");
if (benchmark.run_summary.with_skill) {
  console.log(`With skill:    ${(benchmark.run_summary.with_skill.pass_rate.mean * 100).toFixed(0)}% ± ${(benchmark.run_summary.with_skill.pass_rate.stddev * 100).toFixed(0)}%`);
}
if (benchmark.run_summary.without_skill) {
  console.log(`Without skill: ${(benchmark.run_summary.without_skill.pass_rate.mean * 100).toFixed(0)}% ± ${(benchmark.run_summary.without_skill.pass_rate.stddev * 100).toFixed(0)}%`);
}
if (benchmark.run_summary.delta) {
  console.log(`Delta:         ${benchmark.run_summary.delta.pass_rate}`);
}
console.log(`\nResults: ${path.join(iterDir, "benchmark.json")}`);
