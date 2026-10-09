# Module 11 — Central Limit Theorem

## Learning Objectives

After completing this module, students will be able to:
1. State and explain the Law of Large Numbers
2. State and apply the Central Limit Theorem
3. Explain why Gaussian distributions appear so frequently in engineering
4. Use CLT for approximations
5. Explain the CLT through sampling distributions

---

## 11.1 Introduction: Why Is the Gaussian Everywhere?

The Gaussian distribution appears in:
- Thermal noise, measurement errors, manufacturing tolerances, aggregate interference, stock fluctuations

**The reason:** All these quantities are sums (or averages) of many small, independent random effects. The CLT guarantees convergence to Gaussian regardless of the underlying distribution.

---

## 11.2 Law of Large Numbers (LLN)

### Weak Law of Large Numbers

For $X_{1},\, X_{2},\, \ldots,\, X_{n}$ i.i.d. with mean $\mu$ and finite variance $\sigma^{2}$:

$$\bar{X}_n = \frac{1}{n}\sum_{i=1}^n X_i \xrightarrow{P} \mu \quad \text{as } n \to \infty$$

("Convergence in probability": $P(\lvert \bar{X}_{n} - \mu\rvert > \varepsilon) \to 0$ for any $\varepsilon > 0$)

### Strong Law of Large Numbers

$$\bar{X}_n \xrightarrow{a.s.} \mu \quad \text{as } n \to \infty$$

("Almost sure convergence": $P(\bar{X}_{n} \to \mu) = 1$)

### Engineering Significance

- **Sample average converges to true mean** as sample size grows
- Justifies estimating means from data
- Foundation of Monte Carlo simulation (simulate many times → average converges)
- Justifies: "If I measure enough times, my average will be close to the truth"

### How Fast?

By Chebyshev: $P(\lvert \bar{X}_{n} - \mu\rvert > \varepsilon) \le \frac{\sigma^{2}}{n\varepsilon^{2}}$

For 95% confidence that error $< \varepsilon$: need $n \ge \frac{\sigma^{2}}{0.05 \cdot \varepsilon^{2}}$

---

## 11.3 Central Limit Theorem (CLT)

### Formal Statement

For $X_{1},\, X_{2},\, \ldots,\, X_{n}$ i.i.d. with mean $\mu$ and finite variance $\sigma^{2}$:

$$Z_n = \frac{\bar{X}_n - \mu}{\sigma/\sqrt{n}} = \frac{\sum_{i=1}^n X_i - n\mu}{\sigma\sqrt{n}} \xrightarrow{d} N(0,1)$$

### Practical Form

For large $n$:
$$\bar{X}_n \approx N\left(\mu, \frac{\sigma^2}{n}\right)$$

$$S_n = \sum_{i=1}^n X_i \approx N(n\mu, n\sigma^2)$$

### Conditions
1. $X_{1},\, \ldots,\, X_{n}$ are independent
2. Identically distributed (can be relaxed with Lyapunov/Lindeberg CLT)
3. Finite mean $\mu$ and finite variance $\sigma^{2}$
4. $n$ is "large enough" (rule of thumb: $n \ge 30$, but depends on distribution shape)

### What CLT Does NOT Require
- Does NOT require $X_{i}$ to be Gaussian
- Does NOT require $X_{i}$ to be continuous
- Does NOT require any specific distribution

---

## 11.4 Rate of Convergence

How fast does the CLT "kick in"?

| Original Distribution | $n$ needed for good approximation |
|----------------------|--------------------------------|
| Symmetric (uniform) | $n \approx 5-10$ |
| Mildly skewed | $n \approx 20-30$ |
| Highly skewed (exponential) | $n \approx 30-50$ |
| Extremely skewed | $n \approx 50-100+$ |

**Rule:** More symmetric distributions → faster convergence.

---

## 11.5 Visual Demonstration

### Sum of Uniform RVs → Gaussian

- $n = 1$: Uniform (flat)
- $n = 2$: Triangular
- $n = 3$: Starts looking bell-shaped
- $n = 5$: Nearly Gaussian
- $n = 12$: Practically indistinguishable from Gaussian

### Sum of Exponential RVs → Gaussian

- $n = 1$: Exponential (heavily right-skewed)
- $n = 3$: Still skewed but less so $(\mathrm{Gamma}(3))$
- $n = 10$: Nearly symmetric, bell-shaped
- $n = 30$: Essentially Gaussian

### Binomial → Normal Approximation

$\mathrm{Binomial}(n,\, p) \approx N(np,\, np(1-p))$ for large $n$

This is CLT applied to sum of Bernoulli trials!
- Continuity correction: $P(X \le k) \approx \Phi \left(\frac{k + 0.5 - np}{\sqrt{np(1-p)}}\right)$

---

## 11.6 Engineering Significance

### Why Thermal Noise is Gaussian

Thermal noise = aggregate effect of billions of electrons moving randomly. Each electron's contribution is tiny and independent → CLT applies → noise is Gaussian.

### Why Aggregate Interference is Gaussian

In a cellular network, total interference = sum of signals from many independent users. $\mathrm{CLT}$ → interference ≈ Gaussian (for many users).

### Why Measurement Errors are Gaussian

Total error = sum of many independent small error sources (calibration, quantization, thermal, vibration, etc.) $\to \mathrm{CLT}$ → error ≈ Gaussian.

### Why Manufacturing Variations are Gaussian

Resistor value = nominal + sum of many small process variations (doping, etching, temperature, etc.) $\to \mathrm{CLT}$ → value ≈ Gaussian around nominal.

---

## 11.7 Approximations Using CLT

### General Procedure

To approximate $P(S_{n} \le x)$ where $S_{n} = X_{1} + \ldots + X_{n}$:
1. Compute $\mu = E[X_{i}],\, \sigma^{2} = \operatorname{Var}(X_{i})$
2. $S_{n} \approx N(n\mu,\, n\sigma^{2})$
3. $P(S_{n} \le x) \approx \Phi \left(\frac{x - n\mu}{\sigma \sqrt{n}}\right)$

### Continuity Correction (for Discrete RVs)

When approximating a discrete sum by Gaussian:
- $P(X \le k) \approx \Phi \left(\frac{k + 0.5 - n\mu}{\sigma \sqrt{n}}\right)$
- $P(X = k) \approx \Phi \left(\frac{k + 0.5 - n\mu}{\sigma \sqrt{n}}\right) - \Phi \left(\frac{k - 0.5 - n\mu}{\sigma \sqrt{n}}\right)$

### Example: Packet Errors

1000 packets, each error probability 0.02. $X$ = total errors.
Exact: $X \sim \mathrm{Binomial}(1000,\, 0.02)$
CLT approx: $X \approx N(20,\, 19.6)$

$P(X > 30) \approx 1 - \Phi \left(\frac{30.5 - 20}{\sqrt{19.6}}\right) = 1 - \Phi (2.37) = 0.0089$

---

## 11.8 Practice Problems

### Problem 1
A factory produces bolts. Length $X$ ~ distribution with $\mu = 10\,\mathrm{cm},\, \sigma = 0.2\,\mathrm{cm}$. A batch of 100 bolts is measured.
(a) What is the approximate distribution of $\bar{X}$? (b) $P(\bar{X} > 10.05)$? (c) $P(9.96 < \bar{X} < 10.04)$?

**Solution:**
(a) $\bar{X} \sim N\left(10,\, \frac{0.04}{100}\right) = N(10,\, 0.0004),\, \sigma_{\bar{X}} = 0.02$
(b) $P(\bar{X} > 10.05) = P(Z > 2.5) = 0.0062$
(c) $P(9.96 < \bar{X} < 10.04) = \Phi (2) - \Phi (-2) = 0.9545$

### Problem 2
A communication link has 10000 bits with $\mathrm{BER} = 0.001$. Approximate $P(\text{more than 15 errors})$ using CLT.

**Solution:** $X \sim \mathrm{Binomial}(10000,\, 0.001)$. $\mu = 10,\, \sigma^{2} = 9.99$.
$P(X > 15) \approx 1 - \Phi \left(\frac{15.5-10}{\sqrt{9.99}}\right) = 1 - \Phi (1.74) = 0.0409$

---

*Next Module: [Module 12 — Introduction to Statistics](module12-intro-statistics.md)*
