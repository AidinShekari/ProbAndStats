# Module 13 — Parameter Estimation

## Learning Objectives

After completing this module, students will be able to:
1. Distinguish between estimator (rule) and estimate (number)
2. Evaluate estimator properties: bias, consistency, efficiency, MSE
3. Apply the Method of Moments
4. Apply Maximum Likelihood Estimation (MLE)
5. Compare estimators using MSE and bias-variance tradeoff

---

## 13.1 Introduction

We observe data X₁, ..., Xₙ from a distribution with unknown parameter θ. **Parameter estimation** gives us a method to infer θ from data.

Engineering examples:
- Estimate noise variance σ² from recorded samples
- Estimate failure rate λ from component lifetimes
- Estimate channel gain from received signal strength
- Estimate mean signal level from measurements

---

## 13.2 Estimator vs. Estimate

### Definitions

| Term | Type | Definition | Example |
|------|------|-----------|---------|
| **Estimator** θ̂ | Random variable (function of data) | The RULE applied to data | θ̂ = X̄ = (1/n)ΣXᵢ |
| **Estimate** | Number | The VALUE from a specific sample | θ̂ = 3.47 (from one dataset) |

### Key Insight

The **estimator** is a random variable — it has a sampling distribution.
The **estimate** is one realization of that random variable.

**Analogy:** "Take the average" is the estimator (rule). "The average was 3.47" is the estimate (result).

---

## 13.3 Properties of Estimators

### Bias

$$B(\hat{\theta}) = E[\hat{\theta}] - \theta$$

- **Unbiased:** B(θ̂) = 0, i.e., E[θ̂] = θ (on average, correct)
- **Biased:** E[θ̂] ≠ θ (systematic error)

Examples:
- X̄ is unbiased for μ: E[X̄] = μ ✓
- S² (with n-1) is unbiased for σ²: E[S²] = σ² ✓
- S (sample std dev) is biased for σ: E[S] ≠ σ (slight downward bias)

### Consistency

θ̂ₙ is **consistent** if θ̂ₙ → θ in probability as n → ∞.

Practical meaning: with enough data, the estimator gets arbitrarily close to the truth.

Sufficient condition: If bias → 0 and variance → 0 as n → ∞, then consistent.

### Efficiency

Among all unbiased estimators, the **efficient** one has the smallest variance.

The **Cramér-Rao Lower Bound** (CRLB) gives the minimum possible variance:
$$\text{Var}(\hat{\theta}) \geq \frac{1}{nI(\theta)}$$

where I(θ) = Fisher information = -E[∂²ln f(X;θ)/∂θ²].

An estimator achieving the CRLB is called **efficient** or **minimum variance unbiased (MVU)**.

### Mean Squared Error (MSE)

$$\text{MSE}(\hat{\theta}) = E[(\hat{\theta} - \theta)^2] = \text{Var}(\hat{\theta}) + [B(\hat{\theta})]^2$$

**MSE = Variance + Bias²**

This is the **bias-variance tradeoff**: sometimes a slightly biased estimator with much lower variance has smaller MSE than an unbiased one.

---

## 13.4 Method of Moments (MoM)

### Principle

Set population moments equal to sample moments, then solve for parameters.

- k-th population moment: μ'ₖ = E[Xᵏ]
- k-th sample moment: m'ₖ = (1/n)ΣXᵢᵏ

### Procedure

1. Express parameters in terms of population moments
2. Replace population moments with sample moments
3. Solve for parameter estimates

### Example: Exponential Distribution

Data from Exp(λ). Population moment: E[X] = 1/λ.
Set equal: (1/n)ΣXᵢ = 1/λ̂ → λ̂_MoM = 1/X̄

### Example: Gaussian Distribution

Data from N(μ, σ²):
- 1st moment: μ̂ = X̄
- 2nd central moment: σ̂² = (1/n)Σ(Xᵢ - X̄)² (note: biased, uses n not n-1)

### Advantages/Disadvantages

✅ Simple, always applicable, closed-form solutions often available
❌ Not always efficient, can produce biased estimates, may give invalid parameter values

---

## 13.5 Maximum Likelihood Estimation (MLE)

### Principle

Choose the parameter value that makes the observed data **most probable**.

### Likelihood Function

Given data x₁, ..., xₙ from f(x; θ):

$$L(\theta) = \prod_{i=1}^n f(x_i; \theta)$$

### Log-Likelihood (usually easier)

$$\ell(\theta) = \ln L(\theta) = \sum_{i=1}^n \ln f(x_i; \theta)$$

### MLE Procedure

1. Write the log-likelihood ℓ(θ)
2. Differentiate: dℓ/dθ = 0
3. Solve for θ̂_MLE
4. Verify it's a maximum (d²ℓ/dθ² < 0)

### Properties of MLE

1. **Consistent** (converges to true value)
2. **Asymptotically unbiased** (bias → 0 as n → ∞)
3. **Asymptotically efficient** (achieves CRLB for large n)
4. **Invariant:** If θ̂ is MLE of θ, then g(θ̂) is MLE of g(θ)

### Example: MLE for Gaussian Mean

Data X₁, ..., Xₙ ~ N(μ, σ²) with σ² known.

ℓ(μ) = -(n/2)ln(2πσ²) - (1/(2σ²))Σ(xᵢ - μ)²

dℓ/dμ = (1/σ²)Σ(xᵢ - μ) = 0 → μ̂_MLE = X̄

### Example: MLE for Exponential Rate

Data X₁, ..., Xₙ ~ Exp(λ).

ℓ(λ) = n·ln(λ) - λ·Σxᵢ

dℓ/dλ = n/λ - Σxᵢ = 0 → λ̂_MLE = n/Σxᵢ = 1/X̄

### Example: MLE for Gaussian Variance

Data X₁, ..., Xₙ ~ N(μ, σ²), μ known.

ℓ(σ²) = -(n/2)ln(2πσ²) - (1/(2σ²))Σ(xᵢ - μ)²

dℓ/d(σ²) = -n/(2σ²) + (1/(2σ⁴))Σ(xᵢ - μ)² = 0

σ̂²_MLE = (1/n)Σ(xᵢ - μ)²

Note: With μ unknown, σ̂²_MLE = (1/n)Σ(xᵢ - x̄)² — biased! (Uses n, not n-1)

---

## 13.6 Engineering Examples

### Estimating Noise Variance

**Problem:** Measure n samples of noise. Estimate noise power σ².

**Data:** x₁, ..., xₙ (noise voltage samples, assumed zero-mean)

**MLE:** σ̂² = (1/n)Σxᵢ² (biased by factor (n-1)/n)
**Unbiased:** S² = (1/(n-1))Σ(xᵢ - x̄)² or if μ=0 known: (1/n)Σxᵢ² is actually unbiased for E[X²]=σ²

### Estimating Failure Rate

**Problem:** 20 components tested until failure. Lifetimes: t₁, ..., t₂₀.

**Model:** T ~ Exp(λ), parameter λ (failure rate).

**MLE:** λ̂ = 20/Σtᵢ = 1/T̄

If T̄ = 500 hours: λ̂ = 1/500 = 0.002 failures/hour.

### Estimating Channel Parameter

**Problem:** Rayleigh fading channel. Observed power samples: p₁, ..., pₙ.

**Model:** Power P ~ Exp(1/Ω), where Ω = E[P] = average power.

**MLE:** Ω̂ = P̄ = (1/n)Σpᵢ

---

## 13.7 Comparing Estimators

### Bias-Variance Tradeoff

Two estimators for σ²:
- θ̂₁ = S² (unbiased, variance = 2σ⁴/(n-1))
- θ̂₂ = (1/n)Σ(Xᵢ-X̄)² (biased by -σ²/n, variance = 2σ⁴(n-1)/n²)

MSE(θ̂₁) = 2σ⁴/(n-1)
MSE(θ̂₂) = 2σ⁴(n-1)/n² + σ⁴/n² = σ⁴(2n-1)/n²

For any n ≥ 2: MSE(θ̂₂) < MSE(θ̂₁)! The biased MLE actually has smaller total error.

---

## 13.8 MATLAB Examples

### Example 1: MLE for Exponential Distribution

```matlab
%% MLE for Exponential: Estimate failure rate
lambda_true = 0.005;  % True failure rate
n = 30;

% Simulate data
data = exprnd(1/lambda_true, 1, n);

% MLE
lambda_hat = 1 / mean(data);
fprintf('True λ = %.4f, MLE λ̂ = %.4f\n', lambda_true, lambda_hat);

% Repeated experiments to see variability
N_exp = 10000;
lambda_estimates = zeros(1, N_exp);
for i = 1:N_exp
    d = exprnd(1/lambda_true, 1, n);
    lambda_estimates(i) = 1/mean(d);
end

fprintf('E[λ̂] = %.5f (biased: true is %.5f)\n', mean(lambda_estimates), lambda_true);
fprintf('Std(λ̂) = %.5f\n', std(lambda_estimates));

figure;
histogram(lambda_estimates, 80, 'Normalization', 'pdf');
xlabel('λ̂'); ylabel('PDF'); title('Sampling Distribution of MLE λ̂');
```

### Example 2: MLE vs Method of Moments

```matlab
%% Compare MLE and MoM for Uniform(0, θ)
% MLE: θ̂ = max(X₁,...,Xₙ)
% MoM: θ̂ = 2*X̄
theta_true = 10;  n = 20;
N_exp = 50000;

MLE_est = zeros(1, N_exp);
MoM_est = zeros(1, N_exp);

for i = 1:N_exp
    data = theta_true * rand(1, n);
    MLE_est(i) = max(data);
    MoM_est(i) = 2 * mean(data);
end

fprintf('Method      | E[θ̂]  | Bias   | Var    | MSE\n');
fprintf('MLE (max)   | %.3f | %.3f | %.3f | %.3f\n', ...
    mean(MLE_est), mean(MLE_est)-theta_true, var(MLE_est), ...
    var(MLE_est)+(mean(MLE_est)-theta_true)^2);
fprintf('MoM (2*mean)| %.3f | %.3f | %.3f | %.3f\n', ...
    mean(MoM_est), mean(MoM_est)-theta_true, var(MoM_est), ...
    var(MoM_est)+(mean(MoM_est)-theta_true)^2);
```

### Example 3: MLE for Gaussian Parameters

```matlab
%% MLE for Gaussian: Estimate both μ and σ²
mu_true = 5;  sigma2_true = 4;  n = 50;
N_exp = 10000;

mu_hat = zeros(1, N_exp);
sigma2_MLE = zeros(1, N_exp);
sigma2_unbiased = zeros(1, N_exp);

for i = 1:N_exp
    data = mu_true + sqrt(sigma2_true)*randn(1, n);
    mu_hat(i) = mean(data);
    sigma2_MLE(i) = mean((data - mean(data)).^2);       % MLE: divides by n
    sigma2_unbiased(i) = var(data);                      % Unbiased: divides by n-1
end

fprintf('μ̂: E=%.3f (true=%.1f), Var=%.4f\n', mean(mu_hat), mu_true, var(mu_hat));
fprintf('σ²_MLE: E=%.3f (true=%.1f, biased!)\n', mean(sigma2_MLE), sigma2_true);
fprintf('σ²_unbiased: E=%.3f (true=%.1f)\n', mean(sigma2_unbiased), sigma2_true);
```

---

## 13.9 Practice Problems

### Problem 1
Data from N(μ, 9): x̄ = 4.2, n = 25.
(a) Give the MLE of μ. (b) What is Var(μ̂)? (c) Is X̄ efficient for μ?

**Solution:**
(a) μ̂_MLE = X̄ = 4.2
(b) Var(X̄) = σ²/n = 9/25 = 0.36
(c) CRLB for N(μ,σ²): 1/(n·I(μ)) = σ²/n = 0.36. X̄ achieves CRLB → yes, efficient.

### Problem 2
Component lifetimes (hours): 120, 350, 200, 480, 90, 560, 310, 175, 420, 280.
(a) Estimate λ (failure rate) by MLE assuming Exp(λ). (b) Estimate MTTF.

**Solution:**
(a) X̄ = (120+350+200+480+90+560+310+175+420+280)/10 = 298.5.
λ̂ = 1/298.5 = 0.00335 failures/hour.
(b) MTTF = 1/λ̂ = X̄ = 298.5 hours.

### Problem 3
For Poisson(λ) data: x₁,...,xₙ. Derive the MLE of λ.

**Solution:** ℓ(λ) = Σ[xᵢ ln(λ) - λ - ln(xᵢ!)] = (Σxᵢ)ln(λ) - nλ - Σln(xᵢ!)
dℓ/dλ = (Σxᵢ)/λ - n = 0 → λ̂_MLE = (1/n)Σxᵢ = X̄.
The MLE for Poisson rate is the sample mean.

---

*Next Module: [Module 14 — Confidence Intervals](module14-confidence-intervals.md)*
