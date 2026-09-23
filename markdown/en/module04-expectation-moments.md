# Module 4 — Expectation and Moments

## Learning Objectives

After completing this module, students will be able to:

1. Compute expected values for discrete and continuous random variables
2. Calculate variance and standard deviation and interpret their engineering meaning
3. Apply properties of expectation and variance in engineering analysis
4. Compute and interpret higher-order moments
5. Use the moment generating function (MGF)
6. Relate statistical moments to physical engineering quantities

---

## 4.1 Introduction: Why Summary Statistics?

### The Engineering Need

A probability distribution contains ALL information about a random variable. But for engineering decisions, we often need concise summaries:

- **Signal processing:** What is the average power? → Mean of X²
- **Quality control:** How much do components vary? → Variance
- **Communication:** What is the noise power? → E[N²]
- **Reliability:** What is the average lifetime? → Mean

Moments (mean, variance, etc.) are the essential **engineering-relevant summaries** of a distribution.

---

## 4.2 Expected Value (Mean)

### Definition — Discrete RV

$$E[X] = \mu_X = \sum_{x} x \cdot p_X(x)$$

Sum of (each value × its probability).

### Definition — Continuous RV

$$E[X] = \mu_X = \int_{-\infty}^{\infty} x \cdot f_X(x) \, dx$$

### Engineering Interpretation

The expected value is the **long-run average**: if you repeat the experiment many times and average the results, you get approximately E[X].

| Engineering Quantity | Expected Value Meaning |
|---------------------|----------------------|
| Noise voltage E[N] | DC bias/offset in noise |
| Signal amplitude E[A] | Average signal level |
| Component lifetime E[T] | Mean time to failure (MTTF) |
| Packet delay E[D] | Average delay |
| Bit errors E[X] | Average error count |

### Example: Average Noise Power

For zero-mean Gaussian noise N ~ N(0, σ²):
- E[N] = 0 (no DC component)
- Average power = E[N²] = σ² (this is the variance!)

### Example: Expected Number of Retransmissions

ARQ protocol: each transmission succeeds with probability p = 0.8.
Number of attempts X ~ Geometric(0.8).
E[X] = 1/p = 1/0.8 = 1.25 attempts on average.

---

## 4.3 Expected Value of a Function: E[g(X)]

### The LOTUS Theorem (Law of the Unconscious Statistician)

To find E[g(X)], you do NOT need the distribution of Y = g(X):

**Discrete:**
$$E[g(X)] = \sum_{x} g(x) \cdot p_X(x)$$

**Continuous:**
$$E[g(X)] = \int_{-\infty}^{\infty} g(x) \cdot f_X(x) \, dx$$

### Engineering Applications

| Function g(X) | Engineering Meaning |
|--------------|---------------------|
| g(X) = X² | Mean square value (power) |
| g(X) = (X - μ)² | Variance (AC power) |
| g(X) = |X| | Mean absolute deviation |
| g(X) = e^(jωX) | Characteristic function |

### Example: Mean Power of a Signal

Signal X has PDF f_X(x). Power P = X².

E[P] = E[X²] = ∫ x² f_X(x) dx

For X ~ N(0, σ²): E[X²] = σ² (the noise power equals the variance).

For X ~ N(μ, σ²): E[X²] = μ² + σ² (total power = DC power + AC power).

---

## 4.4 Variance

### Definition

$$\text{Var}(X) = E[(X - \mu_X)^2] = E[X^2] - (E[X])^2$$

The second formula (computational formula) is often easier to use.

### Derivation of Computational Formula

Var(X) = E[(X - μ)²]
       = E[X² - 2μX + μ²]
       = E[X²] - 2μE[X] + μ²
       = E[X²] - 2μ² + μ²
       = E[X²] - μ²

### Engineering Interpretation

The variance measures **spread/dispersion/uncertainty**:

| Context | Variance Meaning |
|---------|-----------------|
| Noise signal | Noise power (for zero-mean noise) |
| Manufacturing | How much components deviate from nominal |
| Measurements | Measurement precision (smaller = more precise) |
| Signal | AC power component |
| Lifetime | How predictable is the lifetime? |

### Key Insight: Variance = Power in Engineering

For a zero-mean signal X:
- E[X²] = Var(X) = σ² = **total power**
- For X ~ N(0, σ²): noise power = σ² = Var(X)

For a signal with DC offset (μ ≠ 0):
- E[X²] = μ² + σ² = **total power = DC power + AC power**
- Var(X) = σ² = **AC power only**

---

## 4.5 Standard Deviation

### Definition

$$\sigma_X = \sqrt{\text{Var}(X)}$$

### Engineering Significance

The standard deviation has the **same units** as X, making it directly interpretable:

| Random Variable | Standard Deviation Unit | Interpretation |
|----------------|------------------------|----------------|
| Voltage noise | Volts | RMS noise voltage |
| Timing jitter | Seconds | RMS jitter |
| Distance error | Meters | RMS position error |
| Temperature | °C | RMS temperature fluctuation |

The standard deviation is the **RMS (root-mean-square)** value for zero-mean signals.

---

## 4.6 Properties of Expectation

### Linearity (FUNDAMENTAL)

$$E[aX + b] = aE[X] + b$$

$$E[X + Y] = E[X] + E[Y] \quad \text{(ALWAYS, even if dependent!)}$$

$$E\left[\sum_{i=1}^n a_i X_i\right] = \sum_{i=1}^n a_i E[X_i]$$

### Monotonicity

If X ≥ 0 always, then E[X] ≥ 0.

If X ≥ Y always, then E[X] ≥ E[Y].

### For Independent RVs

If X and Y are independent:
$$E[XY] = E[X] \cdot E[Y]$$

> ⚠️ This does NOT hold for dependent variables!

### Engineering Example: Total Noise

A received signal: R = S + N₁ + N₂ (signal plus two noise sources)

E[R] = E[S] + E[N₁] + E[N₂] = E[S] + 0 + 0 = E[S]

(Zero-mean noise doesn't bias the expected received signal.)

---

## 4.7 Properties of Variance

### Scaling and Shift

$$\text{Var}(aX + b) = a^2 \text{Var}(X)$$

- Adding a constant b does NOT change variance (shifting doesn't change spread)
- Scaling by a multiplies variance by a²

### Sum of Independent RVs

If X₁, X₂, ..., Xₙ are **independent**:

$$\text{Var}(X_1 + X_2 + \cdots + X_n) = \text{Var}(X_1) + \text{Var}(X_2) + \cdots + \text{Var}(X_n)$$

> ⚠️ Variances add for INDEPENDENT variables only!

### Engineering Example: Noise Power Addition

Two independent noise sources (σ₁² = 0.01 V², σ₂² = 0.04 V²):

Total noise power = σ₁² + σ₂² = 0.05 V²
Total RMS noise = √0.05 = 0.224 V

Note: RMS values do NOT add directly! (0.1 + 0.2 ≠ 0.224)

### Variance of Sample Mean

For n i.i.d. observations X₁, ..., Xₙ with variance σ²:

$$\text{Var}(\bar{X}) = \text{Var}\left(\frac{1}{n}\sum X_i\right) = \frac{\sigma^2}{n}$$

More measurements → lower uncertainty in the average.



---

## 4.8 Higher-Order Moments

### n-th Moment

$$\mu_n' = E[X^n] = \int_{-\infty}^{\infty} x^n f_X(x) \, dx$$

### n-th Central Moment

$$\mu_n = E[(X - \mu)^n]$$

- μ₁ = 0 (always)
- μ₂ = Var(X)
- μ₃ relates to **skewness**
- μ₄ relates to **kurtosis**

### Skewness (3rd Central Moment, Normalized)

$$\gamma_1 = \frac{E[(X-\mu)^3]}{\sigma^3}$$

| Skewness | Shape | Example |
|----------|-------|---------|
| γ₁ = 0 | Symmetric | Gaussian |
| γ₁ > 0 | Right-skewed (long right tail) | Exponential |
| γ₁ < 0 | Left-skewed (long left tail) | Negated exponential |

**Engineering significance:** Skewness tells us if extreme values are more likely in one direction. Important for reliability (failure time distributions are right-skewed).

### Kurtosis (4th Central Moment, Normalized)

$$\gamma_2 = \frac{E[(X-\mu)^4]}{\sigma^4} - 3$$

(Subtracting 3 makes Gaussian have kurtosis 0: "excess kurtosis.")

| Kurtosis | Interpretation | Meaning |
|----------|---------------|---------|
| γ₂ = 0 | Mesokurtic | Gaussian-like tails |
| γ₂ > 0 | Leptokurtic | Heavier tails than Gaussian |
| γ₂ < 0 | Platykurtic | Lighter tails than Gaussian |

**Engineering significance:** High kurtosis means more outliers — important for impulsive noise modeling.

---

## 4.9 Moment Generating Function (MGF)

### Definition

$$M_X(t) = E[e^{tX}]$$

**Discrete:** M_X(t) = Σ e^(tx) p_X(x)

**Continuous:** M_X(t) = ∫ e^(tx) f_X(x) dx

### Why "Moment Generating"?

The n-th moment is obtained by differentiating n times at t = 0:

$$E[X^n] = \frac{d^n M_X(t)}{dt^n}\bigg|_{t=0}$$

- M_X'(0) = E[X]
- M_X''(0) = E[X²]
- Var(X) = M_X''(0) - [M_X'(0)]²

### Properties

1. **Uniqueness:** If M_X(t) = M_Y(t) for all t in a neighborhood of 0, then X and Y have the same distribution.

2. **Sum of Independent RVs:** If X and Y are independent:
   M_{X+Y}(t) = M_X(t) · M_Y(t)

3. **Linear transformation:** M_{aX+b}(t) = e^(bt) · M_X(at)

### MGFs of Common Distributions

| Distribution | MGF M_X(t) |
|-------------|------------|
| Bernoulli(p) | 1 - p + pe^t |
| Binomial(n,p) | (1 - p + pe^t)^n |
| Poisson(λ) | exp(λ(e^t - 1)) |
| Exponential(λ) | λ/(λ - t), t < λ |
| Gaussian(μ,σ²) | exp(μt + σ²t²/2) |

### Engineering Application: Sum of Independent Signals

If signal components X₁ ~ N(μ₁, σ₁²) and X₂ ~ N(μ₂, σ₂²) are independent:

M_{X₁+X₂}(t) = M_{X₁}(t) · M_{X₂}(t)
              = exp(μ₁t + σ₁²t²/2) · exp(μ₂t + σ₂²t²/2)
              = exp((μ₁+μ₂)t + (σ₁²+σ₂²)t²/2)

This is the MGF of N(μ₁+μ₂, σ₁²+σ₂²). Therefore X₁+X₂ ~ N(μ₁+μ₂, σ₁²+σ₂²).

---

## 4.10 Engineering Applications of Moments

### Application 1: Noise Power Characterization

A noise signal N(t) is sampled. The samples have mean μ_N and variance σ_N².

- **DC component (bias):** μ_N — should be zero for ideal noise
- **AC noise power:** σ_N² — determines SNR
- **Total power:** E[N²] = μ_N² + σ_N²

**SNR (Signal-to-Noise Ratio):**
$$\text{SNR} = \frac{E[S^2]}{\sigma_N^2} = \frac{\text{Signal Power}}{\text{Noise Power}}$$

### Application 2: Measurement Error

A sensor measures true value θ with error E:
- Measurement: X = θ + E
- E[X] = θ + E[E] — bias in measurement
- Var(X) = Var(E) — measurement precision

**Accuracy:** |E[E]| (how close the average is to truth)
**Precision:** σ_E (how repeatable measurements are)

### Application 3: Component Lifetime Statistics

Components have lifetime T ~ Exponential(λ):
- Mean Time To Failure: MTTF = E[T] = 1/λ
- Standard Deviation: σ_T = 1/λ = MTTF
- For exponential: coefficient of variation CV = σ/μ = 1 (always!)

### Application 4: Communication Signal Amplitude

Received signal R = A + N where A = signal amplitude, N ~ N(0, σ²):
- E[R] = A (signal amplitude preserved on average)
- Var(R) = σ² (noise power determines variance)
- SNR = A²/σ²

---

## 4.11 MATLAB Examples

### Example 1: Computing Moments from a Distribution

```matlab
%% Moments of Common Distributions

% Exponential: failure time, lambda = 0.01 (per hour)
lambda = 0.01;
beta = 1/lambda;  % mean = 100 hours

fprintf('=== Exponential Distribution (λ = %.3f) ===\n', lambda);
fprintf('Mean (MTTF) = %.1f hours\n', beta);
fprintf('Variance = %.1f hours²\n', beta^2);
fprintf('Std Dev = %.1f hours\n', beta);
fprintf('Coefficient of Variation = %.2f\n', beta/beta);

% Gaussian: noise voltage, sigma = 0.1V
mu = 0; sigma = 0.1;
fprintf('\n=== Gaussian Distribution (μ=%.1f, σ=%.2f V) ===\n', mu, sigma);
fprintf('Mean = %.2f V\n', mu);
fprintf('Variance (noise power) = %.4f V²\n', sigma^2);
fprintf('RMS noise = %.3f V\n', sigma);
fprintf('E[X²] (total power) = %.4f V²\n', mu^2 + sigma^2);
```

### Example 2: Verifying Variance Properties

```matlab
%% Variance of Sum of Independent RVs
N = 100000;

% Two independent noise sources
sigma1 = 0.1;   % RMS of noise 1
sigma2 = 0.2;   % RMS of noise 2

X1 = sigma1 * randn(1, N);
X2 = sigma2 * randn(1, N);
Y = X1 + X2;   % Combined noise

fprintf('Var(X1) = %.4f (theory: %.4f)\n', var(X1), sigma1^2);
fprintf('Var(X2) = %.4f (theory: %.4f)\n', var(X2), sigma2^2);
fprintf('Var(X1+X2) = %.4f (theory: %.4f)\n', var(Y), sigma1^2 + sigma2^2);
fprintf('Std(X1+X2) = %.4f (theory: %.4f)\n', std(Y), sqrt(sigma1^2+sigma2^2));
fprintf('\nNote: std devs do NOT add: %.3f + %.3f = %.3f ≠ %.3f\n', ...
    sigma1, sigma2, sigma1+sigma2, sqrt(sigma1^2+sigma2^2));
```

### Example 3: Mean and Variance of Transformed RV

```matlab
%% E[g(X)] using LOTUS: Power from Voltage
% X = voltage ~ N(0, 0.5V)
% P = X^2 / R, with R = 50 ohms

sigma = 0.5;    % noise voltage RMS
R = 50;         % resistance
N = 100000;

X = sigma * randn(1, N);
P = X.^2 / R;   % instantaneous power

% Using LOTUS: E[X^2/R] = E[X^2]/R = sigma^2/R
E_P_theory = sigma^2 / R;
E_P_sim = mean(P);

fprintf('Mean power: Theory = %.6f W, Sim = %.6f W\n', E_P_theory, E_P_sim);
fprintf('Mean power = %.3f mW\n', E_P_theory * 1000);
```

### Example 4: Higher Moments and Skewness

```matlab
%% Skewness and Kurtosis Comparison
N = 100000;

% Gaussian (symmetric)
X_gauss = randn(1, N);

% Exponential (right-skewed)
X_exp = exprnd(1, 1, N);

% Uniform (symmetric, light tails)
X_unif = rand(1, N);

fprintf('Distribution    | Skewness | Kurtosis\n');
fprintf('----------------+----------+---------\n');
fprintf('Gaussian        | %+.3f   | %+.3f\n', skewness(X_gauss), kurtosis(X_gauss)-3);
fprintf('Exponential     | %+.3f   | %+.3f\n', skewness(X_exp), kurtosis(X_exp)-3);
fprintf('Uniform         | %+.3f   | %+.3f\n', skewness(X_unif), kurtosis(X_unif)-3);
fprintf('\nTheoretical:\n');
fprintf('Gaussian:    skew=0, kurt=0\n');
fprintf('Exponential: skew=2, kurt=6\n');
fprintf('Uniform:     skew=0, kurt=-1.2\n');
```

### Example 5: MGF Verification

```matlab
%% Verify MGF: Compute moments by differentiation (numerical)
% For X ~ Exponential(lambda)
lambda_rate = 2;
beta_scale = 1/lambda_rate;

% MGF: M(t) = lambda/(lambda - t)
% M'(0) = E[X], M''(0) = E[X^2]

t = 0;
dt = 1e-6;

% Numerical derivatives
M = @(t) lambda_rate ./ (lambda_rate - t);
M_prime = (M(t+dt) - M(t-dt)) / (2*dt);
M_double_prime = (M(t+dt) - 2*M(t) + M(t-dt)) / dt^2;

fprintf('From MGF derivatives:\n');
fprintf('  E[X] = M''(0) = %.4f (theory: %.4f)\n', M_prime, 1/lambda_rate);
fprintf('  E[X²] = M''''(0) = %.4f (theory: %.4f)\n', M_double_prime, 2/lambda_rate^2);
fprintf('  Var(X) = E[X²] - (E[X])² = %.4f (theory: %.4f)\n', ...
    M_double_prime - M_prime^2, 1/lambda_rate^2);
```

---

## 4.12 Practice Problems

### Problem 1: Basic Computation
A discrete RV X has PMF: P(X=-1) = 0.2, P(X=0) = 0.5, P(X=1) = 0.2, P(X=2) = 0.1.

(a) Find E[X].
(b) Find E[X²].
(c) Find Var(X).
(d) Find E[3X + 2].
(e) Find Var(3X + 2).

**Solution:**
(a) E[X] = (-1)(0.2) + (0)(0.5) + (1)(0.2) + (2)(0.1) = -0.2 + 0 + 0.2 + 0.2 = 0.2

(b) E[X²] = (1)(0.2) + (0)(0.5) + (1)(0.2) + (4)(0.1) = 0.2 + 0 + 0.2 + 0.4 = 0.8

(c) Var(X) = E[X²] - (E[X])² = 0.8 - 0.04 = 0.76

(d) E[3X + 2] = 3E[X] + 2 = 3(0.2) + 2 = 2.6

(e) Var(3X + 2) = 9·Var(X) = 9(0.76) = 6.84

---

### Problem 2: Signal and Noise
A received signal R = 2.5 + N, where N ~ N(0, 0.04).

(a) Find E[R] and Var(R).
(b) Find the SNR in dB.
(c) Find P(R < 0) — probability the signal goes negative.

**Solution:**
(a) E[R] = 2.5, Var(R) = Var(N) = 0.04, σ_R = 0.2

(b) Signal power = 2.5² = 6.25, Noise power = 0.04
    SNR = 6.25/0.04 = 156.25 → SNR_dB = 10·log₁₀(156.25) = 21.94 dB

(c) P(R < 0) = P(N < -2.5) = Φ(-2.5/0.2) = Φ(-12.5) ≈ 0 (extremely unlikely)

---

### Problem 3: Averaging Measurements
A sensor makes n independent measurements of a constant voltage V = 3.3V.
Each measurement: Xᵢ = 3.3 + Nᵢ where Nᵢ ~ N(0, 0.01).

(a) What is E[X̄] and Var(X̄) for n = 1?
(b) How many measurements n needed so that σ_X̄ < 0.01V?
(c) With n = 100, what is P(|X̄ - 3.3| > 0.02)?

**Solution:**
(a) E[X̄] = 3.3, Var(X̄) = 0.01/1 = 0.01, σ = 0.1V

(b) σ_X̄ = σ/√n < 0.01 → √n > 10 → n > 100 → need n ≥ 101

(c) σ_X̄ = 0.1/√100 = 0.01V
    P(|X̄ - 3.3| > 0.02) = P(|Z| > 2) = 2(1-Φ(2)) = 0.0455

---

### Problem 4: Component Lifetime
Components have lifetime T ~ Exp(λ = 0.002 per hour).

(a) Find MTTF, σ_T, and coefficient of variation.
(b) Find P(T > 1000 hours).
(c) Find E[T²] and interpret.

**Solution:**
(a) MTTF = 1/λ = 500 hours, σ_T = 500 hours, CV = σ/μ = 1

(b) P(T > 1000) = e^(-0.002×1000) = e^(-2) = 0.1353

(c) E[T²] = Var(T) + (E[T])² = 500² + 500² = 500000 hours²
    √E[T²] = 707 hours (RMS lifetime)

---

### Problem 5: MGF Application
X has MGF M_X(t) = (1/3)e^t + (2/3)e^(2t).

(a) What type of RV is X? Find its PMF.
(b) Find E[X] using the MGF.
(c) Find Var(X) using the MGF.

**Solution:**
(a) X is discrete. Comparing with Σ p_X(x)e^(tx):
    P(X=1) = 1/3, P(X=2) = 2/3

(b) M'(t) = (1/3)e^t + (4/3)e^(2t)
    E[X] = M'(0) = 1/3 + 4/3 = 5/3

(c) M''(t) = (1/3)e^t + (8/3)e^(2t)
    E[X²] = M''(0) = 1/3 + 8/3 = 3
    Var(X) = 3 - (5/3)² = 3 - 25/9 = 2/9

---

## 4.13 Key Takeaways

1. **E[X] = long-run average** — the center of the distribution, DC component
2. **Var(X) = spread/power** — for zero-mean signals, variance IS power
3. **σ has same units as X** — directly interpretable as RMS value
4. **Linearity of expectation** always holds; variance addition requires independence
5. **MGF uniquely identifies** a distribution and generates all moments
6. **In engineering:** mean → signal level, variance → noise power, std dev → RMS noise

---

*Next Module: [Module 5 — Important Random-Variable Functions](module05-rv-functions.md)*
