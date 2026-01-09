# Maturity Framework + Poker Signal Test — Working Summary (portable handoff doc)

**Purpose:** Preserve what we built in this chat in a *copy‑pastable, portable* form so you can start a new chat without losing momentum.

---

## 1) What we just proved in R (PokerTracker ingest → summary index)

### The bug you hit
- `readr::parse_number("-$27.08")` warned because the string begins with a minus **before** the `$`.
- In one attempt you also got: `unused argument (currency = "$")` because `locale(currency=...)` was called on the wrong `locale()` function (namespace mismatch). Easiest fix is: **don’t use locale here**—just clean the string first, then `as.numeric()`.

### The fix that worked
You cleaned the currency sign out of the string, preserved the negative sign, then converted to numeric:

```r
my_c_won_clean = stringr::str_replace(my_c_won, "\\$", ""),
c_won_numeric  = as.numeric(my_c_won_clean),
c_per_hand     = c_won_numeric / hands
```

### The proof it worked
Your output file `poker_summary_index.csv` shows:
- `my_c_won = -$27.08`
- `my_c_won_clean = -27.08`
- `c_won_numeric = -27.08`
- `c_per_hand ≈ -0.043961...` (=-27.08 / 616)

So yes: **the test ran cleanly and produced the expected derived metric.**

### What the “test” is, conceptually
We created a **numeric bridge** between:
- **Outcome signal** (money won/lost)  
and
- **unitized exposure** (hands played)

That yields a per‑unit “drift” metric:

\[
\text{drift per hand} = \frac{\Delta \$}{\Delta \text{hands}}
\]

This is the simplest possible “system health signal” you can compute from PokerTracker summaries.

---

## 2) How this plugs into the larger Maturity Framework

### The bigger model existed before poker
Yes. The original framework is about **system persistence under stress**, with concepts like:
- *carrying capacity* (what the system can sustain)
- *variance tolerance / risk-of-ruin*
- *maturity / nobility / integrity constraints*
- *intangible capacity* (trust, morale, legitimacy, meaning, etc.)

Poker became the **calibration harness** because poker gives you:
- repeated trials (hands)
- a measurable output (profit/loss)
- volatility and regime shifts
- known failure modes (tilt, over‑adjusting, abandoning baseline, etc.)

So poker is not “the whole model”; poker is a **validated measurement sandbox**.

### What we tested from the intuition side
Your hypothesis: systems collapse when **signal quality degrades** and we start “spending” integrity to maintain output.

Poker gives a measurable proxy:
- When the curve flips negative after some point (you mentioned ~130 hands), that’s a candidate **regime change** / **tipping point**.

In other domains, the analog is:
- the system still *looks functional*, but internal indicators (trust, coherence, restraint) are decaying.

---

## 3) The strategy you described (math tether ↔ intuitive mode)

You described a **two‑mode controller**:

1) **Baseline Mode (Math / EV close to GTO)**  
   - keeps you grounded  
   - reduces catastrophic error  
   - acts as the “constitution” / guardrails  

2) **Adaptive Mode (Intuition / unpredictability)**  
   - creates opponent confusion  
   - increases volatility (Bollinger‑band‑like patterns)  
   - hunts edge in human weakness / meta‑game

3) **Emergency Return Protocol**  
   - when the “signal feels wrong,” you return to math to prevent system failure  

That’s a clean, generalizable idea:
> *Exploration increases variance; tether prevents ruin.*

---

## 4) Answering your “is it unique?” question

What’s common:
- Everyone in poker talks about EV, variance, BRM, risk-of-ruin.

What’s less common / your twist:
- treating **intuition vs math balance** as a **stability‑constrained control system**
- treating “incompatibility imprint” and other intangible variables as *first‑class state*
- formalizing it as an index you can apply to **other systems** (organizations, governments, platforms, AI training loops)

So: the building blocks are known, but **the cross‑domain mapping + intangible carrying capacity + risk‑of‑ruin framing for systems** is the distinctive move.

---

## 5) Practical: RStudio workflow notes (so you don’t get stuck)

### “Source on Save” checkbox
In the script editor toolbar:
- **Source** runs the script now.
- **Source on Save** means: every time you press Ctrl+S, RStudio auto‑runs (“sources”) that script.

You usually keep it **OFF** unless:
- the script is small, safe, and fast  
- you want automatic re-runs while iterating

### Do you need to close/reopen RStudio?
Not required.
Better routine:
1) `Session > Restart R` (clears environment cleanly)
2) Run scripts in order:
   - `source("R/01_ingest_pokertracker.R")`
   - `source("R/02_index_summary.R")`

---

## 6) Handoff sentence for a new chat

Copy/paste this into a new chat:

> “We built a Maturity Framework where systems collapse when signal quality degrades and intangible carrying capacity is exceeded. We used PokerTracker summaries as a measurable harness: ingested a CSV with player, My C Won (like '-$27.08'), and hands (616), cleaned currency to numeric (-27.08), and computed drift per hand c_per_hand = c_won_numeric/hands ≈ -0.04396. Now I want a canonical equation page (LaTeX), R-ready functions, measurable vs proxy annotations, and a mapping to AI alignment benchmarks ...”

---

## 7) What to do next (when you’re back)

1) Expand beyond 1-row summary:
   - ingest multiple sessions or a full report export
2) Compute rolling signals:
   - rolling drift, rolling volatility, drawdown slope, regime-change detection
3) Define “signal collapse” formally:
   - threshold rules + probabilistic hazard model
4) Map the same structure to:
   - org health
   - societal legitimacy
   - AI training / alignment signals

---

**End of handoff doc.**
