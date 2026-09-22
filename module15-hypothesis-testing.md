# Module 15 — Hypothesis Testing

## Learning Objectives

After completing this module, students will be able to:
1. Formulate null and alternative hypotheses for engineering problems
2. Identify Type I and Type II errors and their engineering consequences
3. Compute test statistics and p-values
4. Perform Z-tests and t-tests for means
5. Correctly interpret p-values (and avoid common misconceptions)
6. Choose between one-sided and two-sided tests

---

## 15.1 Introduction: Making Decisions from Data

**Engineering question:** "Is this sensor biased?" "Did the process change?" "Does the new algorithm perform better?"

We need a **systematic framework** to answer such questions from data, while controlling the probability of making errors.

---

## 15.2 Framework

### Null Hypothesis H₀

The **default assumption** — typically "nothing changed" or "no effect":
- H₀: μ = μ₀ (sensor is not biased)
- H₀: μ₁ = μ₂ (two methods perform equally)
- H₀: σ² = σ₀² (variance hasn't changed)

### Alternative Hypothesis H₁

What we want to **detect** or prove:
- H₁: μ ≠ μ₀ (sensor IS biased — two-sided)
- H₁: μ > μ₀ (performance improved — one-sided)
- H₁: σ² > σ₀² (variance increased)

### Decision

Based on data, either:
- **Reject H₀** → evidence supports H₁
- **Fail to reject H₀** → insufficient evidence against H₀

> ⚠️ "Fail to reject H₀" ≠ "H₀ is true". Absence of evidence ≠ evidence of absence.

---

## 15.3 Types of Errors

| | H₀ True (reality) | H₁ True (reality) |
|---|---|---|
| **Reject H₀** (decision) | Type I Error (α) | Correct! (Power = 1-β) |
| **Fail to reject H₀** (decision) | Correct! | Type II Error (β) |

### Type I Error (False Alarm) — probability α

Rejecting H₀ when it's actually true. "Crying wolf."

Engineering analogy: Declaring a process has changed when it hasn't → unnecessary recalibration.

### Type II Error (Missed Detection) — probability β

Failing to reject H₀ when H₁ is actually true. "Missing the signal."

Engineering analogy: Failing to detect a sensor bias → biased measurements continue.

### Engineering Analogy: Radar Detection

| Statistical Term | Radar Equivalent |
|-----------------|------------------|
| H₀: no target | No aircraft present |
| H₁: target present | Aircraft present |
| Type I error (α) | False alarm |
| Type II error (β) | Missed detection |
| Power (1-β) | Probability of detection |

### The Tradeoff

Reducing α (fewer false alarms) → increases β (more missed detections), and vice versa.

Fix α (significance level), then maximize power = 1 - β.

---

## 15.4 Significance Level α

The **maximum acceptable Type I error rate**, chosen BEFORE looking at data.

Common choices: α = 0.05, 0.01, 0.10

**Choosing α:** Consider the cost of a false alarm:
- α = 0.01: Very conservative (e.g., medical device safety)
- α = 0.05: Standard in most engineering/science
- α = 0.10: More tolerant (exploratory analysis)

---

## 15.5 Power of a Test

$$\text{Power} = 1 - \beta = P(\text{reject } H_0 | H_1 \text{ is true})$$

Power depends on:
1. **Effect size:** Larger true difference → easier to detect → more power
2. **Sample size n:** More data → more power
3. **Significance level α:** Larger α → more power (but more false alarms)
4. **Variability σ:** Less noise → more power

---

## 15.6 The p-value

### Definition

The **p-value** is the probability of obtaining a test statistic **as extreme or more extreme** than the observed value, **assuming H₀ is true**.

$$p\text{-value} = P(\text{data this extreme or more} | H_0 \text{ true})$$

### Decision Rule

- If p-value < α → Reject H₀
- If p-value ≥ α → Fail to reject H₀

### ✅ CORRECT Interpretation

> "The p-value is the probability of seeing data this extreme (or more) if H₀ were true. A small p-value means the data is unlikely under H₀."

### ❌ WRONG Interpretation

> ~~"The p-value is the probability that H₀ is true."~~

**Why wrong:** H₀ is either true or false (fixed). The p-value says nothing about P(H₀ true). It measures how surprising the data is under H₀.

### Calibration

| p-value | Evidence against H₀ |
|---------|---------------------|
| > 0.10 | Weak or none |
| 0.05 – 0.10 | Marginal |
| 0.01 – 0.05 | Moderate |
| 0.001 – 0.01 | Strong |
| < 0.001 | Very strong |

---

## 15.7 One-Sided vs. Two-Sided Tests

### Two-Sided (H₁: μ ≠ μ₀)

Used when deviation in **either** direction is important.
- Reject if |T| > t_{α/2, n-1}
- p-value = 2·P(T > |t_obs|)

### One-Sided (H₁: μ > μ₀ or H₁: μ < μ₀)

Used when only one direction of deviation matters.
- H₁: μ > μ₀: Reject if T > t_{α, n-1}
- H₁: μ < μ₀: Reject if T < -t_{α, n-1}

### When to Use Which

| Scenario | Test Type |
|----------|-----------|
| Is the sensor biased (either direction)? | Two-sided |
| Does the new algorithm IMPROVE BER? | One-sided (H₁: BER < BER_old) |
| Has noise power INCREASED? | One-sided (H₁: σ² > σ₀²) |
| Did the process mean CHANGE? | Two-sided |

---

## 15.8 Tests for Means

### One-Sample Z-Test (σ known)

Test: H₀: μ = μ₀

Test statistic: Z = (X̄ - μ₀)/(σ/√n)

Under H₀: Z ~ N(0,1)

### One-Sample t-Test (σ unknown)

Test: H₀: μ = μ₀

Test statistic: T = (X̄ - μ₀)/(S/√n)

Under H₀: T ~ t(n-1)

### Two-Sample t-Test (comparing two means)

Test: H₀: μ₁ = μ₂

Test statistic: T = (X̄₁ - X̄₂) / √(S₁²/n₁ + S₂²/n₂)

Approximate df by Welch-Satterthwaite formula.

---

## 15.9 Test for Variance (Chi-Square Test)

### One-Sample Test

H₀: σ² = σ₀²

Test statistic: χ² = (n-1)S²/σ₀²

Under H₀: χ² ~ χ²(n-1)

### Decision

- H₁: σ² > σ₀²: Reject if χ² > χ²_{α, n-1}
- H₁: σ² ≠ σ₀²: Reject if χ² < χ²_{1-α/2, n-1} or χ² > χ²_{α/2, n-1}

---

## 15.10 Step-by-Step Hypothesis Testing Procedure

1. **State hypotheses:** H₀ and H₁
2. **Choose significance level:** α (e.g., 0.05)
3. **Select test statistic:** Z, t, or χ² depending on scenario
4. **Determine critical value(s)** or compute p-value
5. **Compute test statistic** from data
6. **Make decision:** Reject H₀ if test statistic in critical region (or p < α)
7. **State conclusion** in engineering terms

---

## 15.11 Engineering Examples

### Example 1: Is a Sensor Biased?

A sensor should read 0V with no input. 20 measurements give X̄ = 0.012V, S = 0.03V.

H₀: μ = 0 (no bias), H₁: μ ≠ 0 (biased), α = 0.05

T = (0.012 - 0)/(0.03/√20) = 0.012/0.00671 = 1.789

t_{0.025, 19} = 2.093. Since |T| = 1.789 < 2.093 → **Fail to reject H₀.**

p-value = 2·P(t(19) > 1.789) ≈ 0.090. Not significant at 5% level.

Conclusion: Insufficient evidence to conclude the sensor is biased.

### Example 2: Did Manufacturing Process Change?

Before: μ₀ = 100Ω (established). After modification: n = 30, X̄ = 101.2Ω, S = 3.5Ω.

H₀: μ = 100, H₁: μ ≠ 100, α = 0.05

T = (101.2 - 100)/(3.5/√30) = 1.2/0.639 = 1.878

t_{0.025, 29} = 2.045. |T| = 1.878 < 2.045 → **Fail to reject H₀.**

### Example 3: Does New Algorithm Improve BER?

Old algorithm: BER₀ = 10⁻³. New algorithm tested: n = 50000 bits, 38 errors.

BER_new = 38/50000 = 7.6×10⁻⁴

H₀: p = 0.001, H₁: p < 0.001 (improvement), α = 0.05

Z = (p̂ - p₀)/√(p₀(1-p₀)/n) = (0.00076 - 0.001)/√(0.001×0.999/50000) = -0.00024/0.000141 = -1.70

p-value = P(Z < -1.70) = 0.0446 < 0.05 → **Reject H₀.**

Conclusion: Evidence supports that the new algorithm has lower BER.

### Example 4: Has Noise Power Increased?

Historical: σ₀² = 0.04 V². New measurements: n = 25, S² = 0.058 V².

H₀: σ² = 0.04, H₁: σ² > 0.04, α = 0.05

χ² = (24)(0.058)/0.04 = 34.8

χ²_{0.05, 24} = 36.415. Since 34.8 < 36.415 → **Fail to reject H₀.**

---

## 15.12 MATLAB Examples

### Example 1: One-Sample t-test

```matlab
%% Is the sensor biased? One-sample t-test
data = [0.012, -0.005, 0.031, 0.008, -0.012, 0.022, 0.015, ...
        0.003, 0.028, -0.001, 0.018, 0.009, 0.025, -0.008, ...
        0.014, 0.007, 0.020, 0.011, -0.003, 0.019];

mu_0 = 0;  % Hypothesized mean (no bias)
[h, p_value, ci, stats] = ttest(data, mu_0);

fprintf('Test result: H = %d (1=reject H₀)\n', h);
fprintf('p-value = %.4f\n', p_value);
fprintf('t-statistic = %.3f, df = %d\n', stats.tstat, stats.df);
fprintf('95%% CI for μ: [%.4f, %.4f]\n', ci);
```

### Example 2: Two-Sample t-test

```matlab
%% Compare two algorithms: is there a significant difference?
BER_algo1 = [0.0012, 0.0008, 0.0015, 0.0010, 0.0013, ...
             0.0011, 0.0009, 0.0014, 0.0012, 0.0010];
BER_algo2 = [0.0007, 0.0009, 0.0006, 0.0008, 0.0005, ...
             0.0008, 0.0007, 0.0006, 0.0009, 0.0007];

[h, p_value, ci, stats] = ttest2(BER_algo1, BER_algo2);
fprintf('Two-sample t-test:\n');
fprintf('  H = %d (1=reject H₀: means are equal)\n', h);
fprintf('  p-value = %.4e\n', p_value);
fprintf('  t-stat = %.3f, df = %.1f\n', stats.tstat, stats.df);
fprintf('  Mean diff: %.4f\n', mean(BER_algo1) - mean(BER_algo2));
```

### Example 3: Power Analysis

```matlab
%% Power: How likely are we to detect a true difference?
mu_0 = 0;          % Null hypothesis mean
mu_true = 0.015;   % True mean (sensor has bias of 15mV)
sigma = 0.03;      % Known std dev
alpha = 0.05;

n_values = 5:5:100;
power = zeros(size(n_values));

for i = 1:length(n_values)
    n = n_values(i);
    % Critical value for two-sided test
    z_crit = norminv(1-alpha/2);
    % Power = P(reject | mu_true)
    % Reject when |Z| > z_crit, where Z ~ N((mu_true-mu_0)/(sigma/sqrt(n)), 1)
    ncp = (mu_true - mu_0) / (sigma/sqrt(n));  % Non-centrality parameter
    power(i) = 1 - normcdf(z_crit - ncp) + normcdf(-z_crit - ncp);
end

figure;
plot(n_values, power, 'b-o', 'LineWidth', 2);
xlabel('Sample Size n'); ylabel('Power (1 - β)');
title(sprintf('Power vs Sample Size (true bias = %.0f mV)', mu_true*1000));
grid on;
yline(0.8, 'r--', 'Desired Power = 0.8');
fprintf('Need n ≈ %d for 80%% power\n', n_values(find(power >= 0.8, 1)));
```

---

## 15.13 Practice Problems

### Problem 1
A manufacturing spec requires mean resistance = 100Ω. A sample of 16 resistors gives X̄ = 101.5Ω, S = 3Ω. At α = 0.05, is there evidence the process has drifted?

**Solution:** H₀: μ=100, H₁: μ≠100. T = (101.5-100)/(3/4) = 2.0. t_{0.025,15} = 2.131. |T|=2.0 < 2.131 → Fail to reject. p-value ≈ 0.064 > 0.05.

### Problem 2
Average packet delay was 5ms. After network upgrade, 40 measurements give X̄ = 4.6ms, S = 1.2ms. Test if delay decreased at α = 0.01.

**Solution:** H₀: μ=5, H₁: μ<5. T = (4.6-5)/(1.2/√40) = -0.4/0.190 = -2.11. t_{0.01,39} ≈ -2.426. T = -2.11 > -2.426 → Fail to reject at 1% level. (Would reject at 5% since t_{0.05,39}≈-1.685.)

### Problem 3
Explain why "p = 0.04 means there is only a 4% chance H₀ is true" is WRONG.

**Solution:** The p-value is P(data this extreme | H₀ true), NOT P(H₀ true | data). It conditions on H₀ being true and asks about data extremity. To get P(H₀ true | data) would require Bayesian analysis with a prior. The p-value is a property of the data-generating process under H₀, not a posterior probability about H₀.

---

*Next Module: [Module 16 — Engineering Statistical Applications](module16-engineering-applications.md)*
