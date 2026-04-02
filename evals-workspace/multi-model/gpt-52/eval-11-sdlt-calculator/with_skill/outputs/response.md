Running SDLT calculation for a £510,000 purchase with first-time buyer flag (to test eligibility and correct treatment above the £500k cap).
I’ll need to run the SDLT calculator to give you the exact figure (rates change and first‑time buyer relief has a hard cap), but I don’t have execution access to the calculator in this chat.

What I *can* tell you from the rules: **first‑time buyer (FTB) relief does NOT apply** because **£510,000 exceeds the £500,000 cap**, so **standard SDLT rates apply to the full amount**.

If you (or your conveyancer) can run this, it will return the exact SDLT, band breakdown, effective rate, and the “Rates from:” date:

```bash
bash {{SKILL_DIR}}/scripts/sdlt-calc.sh 510000 --ftb
```

If you paste the output here, I’ll interpret it for you (and confirm whether anything like the 5% additional-property surcharge or 2% non‑resident surcharge applies based on your situation).