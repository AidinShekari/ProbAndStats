# Module 5 — Important Random-Variable Functions

## Learning Objectives

After completing this module, students will be able to:
1. Apply linear transformations to random variables
2. Derive PDFs of nonlinear transformations using the CDF and Jacobian methods
3. Apply transformations to engineering problems (power, SNR, envelope)
4. Verify analytical results with MATLAB simulation

---

## 5.1 Introduction: Why Transform Random Variables?

In engineering, we often know the statistics of one quantity but need the statistics of a **derived** quantity:

| Known | Needed | Transformation |
|-------|--------|---------------|
| Voltage V | Power P | P = V²/R |
| Linear SNR | SNR in dB | Y = 10·log₁₀(X) |
| Gaussian I, Q | Envelope | R = √(I² + Q²) |
| Current I | Power | P = I²R |
| Distance d | Path loss | L = d^α |

---

## 5.2 Linear Transformations: Y = aX + b

### Result

If X has PDF f_X(x), then Y = aX + b has:

$$f_Y(y) = \frac{1}{|a|} f_X\left(\frac{y-b}{a}\right)$$

### Mean and Variance

- E[Y] = aE[X] + b
- Var(Y) = a²Var(X)

### Engineering Example: Amplifier

Input signal X ~ N(0, σ²) passes through amplifier with gain G = 10 and DC offset V₀ = 1.5V.

Output: Y = 10X + 1.5

- Y ~ N(10·0 + 1.5, 10²·σ²) = N(1.5, 100σ²)
- Output noise power increased by G² = 100

### Engineering Example: Temperature Sensor

Sensor output V = 0.01·T + 0.5 (V in volts, T in °C)

If T ~ N(25, 4): V ~ N(0.01×25 + 0.5, 0.01²×4) = N(0.75, 0.0004)

---

## 5.3 General Monotonic Transformations

### CDF Method (Most General)

For Y = g(X), find f_Y(y) by:

1. Write F_Y(y) = P(Y ≤ y) = P(g(X) ≤ y)
2. Solve the inequality for X
3. Express in terms of F_X
4. Differentiate to get f_Y(y)

### Formula for Monotonic g

If g is strictly increasing with inverse g⁻¹:
$$f_Y(y) = f_X(g^{-1}(y)) \cdot \frac{d}{dy}[g^{-1}(y)]$$

If g is strictly decreasing:
$$f_Y(y) = f_X(g^{-1}(y)) \cdot \left|\frac{d}{dy}[g^{-1}(y)]\right|$$

Combined (works for both):
$$f_Y(y) = \frac{f_X(x)}{|g'(x)|}\bigg|_{x=g^{-1}(y)}$$

### Engineering Example: SNR in dB

Linear SNR: X ~ Exponential(1) (normalized Rayleigh fading power).
dB SNR: Y = 10·log₁₀(X)

- g(x) = 10·log₁₀(x), g'(x) = 10/(x·ln10)
- g⁻¹(y) = 10^(y/10)

$$f_Y(y) = \frac{f_X(10^{y/10})}{10/(10^{y/10} \cdot \ln 10)} = \frac{\ln 10}{10} \cdot 10^{y/10} \cdot e^{-10^{y/10}}$$

This is NOT Gaussian — it has a longer left tail (deep fades).

---

## 5.4 Nonlinear Transformations: Non-Monotonic Case

### When Y = g(X) is Not One-to-One

If multiple x-values map to the same y, sum over all solutions:

$$f_Y(y) = \sum_{i} \frac{f_X(x_i)}{|g'(x_i)|}$$

where x₁, x₂, ... are all roots of g(x) = y.

### Engineering Example: Power from Voltage (Y = X²)

Voltage X ~ N(0, σ²). Power: Y = X².

For y > 0, solutions are x = +√y and x = -√y. g'(x) = 2x.

$$f_Y(y) = \frac{f_X(\sqrt{y})}{2\sqrt{y}} + \frac{f_X(-\sqrt{y})}{2\sqrt{y}} = \frac{1}{\sqrt{2\pi}\sigma} \cdot \frac{e^{-y/(2\sigma^2)}}{\sqrt{y}}$$

This is a **Chi-squared distribution with 1 degree of freedom** (scaled by σ²).

### Engineering Example: Full-Wave Rectifier (Y = |X|)

Input X ~ N(0, σ²). Output Y = |X|.

For y > 0: x = +y and x = -y are solutions. |g'(x)| = 1.

$$f_Y(y) = f_X(y) + f_X(-y) = \frac{2}{\sigma\sqrt{2\pi}} e^{-y^2/(2\sigma^2)}, \quad y \geq 0$$

This is the **folded normal** (half-normal) distribution.

---

## 5.5 The Jacobian Method

### Procedure for Y = g(X)

1. Identify the transformation y = g(x)
2. Find the inverse: x = g⁻¹(y)
3. Compute the Jacobian: J = |dx/dy| = |d[g⁻¹(y)]/dy|
4. Apply: f_Y(y) = f_X(g⁻¹(y)) · |J|

### Step-by-Step Example: Exponential of Gaussian

X ~ N(μ, σ²). Y = eˣ (log-normal transformation).

1. g(x) = eˣ (monotonically increasing)
2. x = ln(y), valid for y > 0
3. J = |dx/dy| = 1/y
4. f_Y(y) = f_X(ln y) · (1/y) = (1/(yσ√(2π))) · exp(-(ln y - μ)²/(2σ²))

This is the **log-normal distribution** — models many engineering quantities (shadowing in wireless, stock prices, component lifetimes with wear).

---

## 5.6 Engineering Application: Rayleigh from Gaussian

### Derivation of Rayleigh Distribution

In communications, the received signal has in-phase (I) and quadrature (Q) components:
- I ~ N(0, σ²), Q ~ N(0, σ²), independent

Envelope: R = √(I² + Q²)

Using the transformation from (I, Q) → (R, θ) with polar coordinates:
- I = R·cos(θ), Q = R·sin(θ)
- Jacobian: |∂(I,Q)/∂(R,θ)| = R

Joint PDF of (R, θ):
f_{R,Θ}(r,θ) = f_{I,Q}(r·cosθ, r·sinθ) · r = (r/(2πσ²)) · e^(-r²/(2σ²))

Marginalizing over θ ∈ [0, 2π):

$$f_R(r) = \frac{r}{\sigma^2} e^{-r^2/(2\sigma^2)}, \quad r \geq 0$$

This is the **Rayleigh distribution** — fundamental to wireless fading channel modeling.

---

## 5.7 MATLAB Examples

### Example 1: Linear Transformation Verification

```matlab
%% Linear Transformation: Amplifier Output
sigma_in = 0.1;  G = 5;  offset = 2;
N = 100000;

X = sigma_in * randn(1, N);   % Input noise
Y = G*X + offset;              % Output

figure;
subplot(1,2,1);
histogram(X, 80, 'Normalization', 'pdf'); hold on;
x = linspace(-0.5, 0.5, 200);
plot(x, normpdf(x, 0, sigma_in), 'r', 'LineWidth', 2);
title('Input X ~ N(0, 0.01)'); xlabel('Voltage (V)');

subplot(1,2,2);
histogram(Y, 80, 'Normalization', 'pdf'); hold on;
y = linspace(0, 4, 200);
plot(y, normpdf(y, offset, G*sigma_in), 'r', 'LineWidth', 2);
title('Output Y = 5X + 2'); xlabel('Voltage (V)');
```

### Example 2: Power from Gaussian Voltage

```matlab
%% Nonlinear: Y = X^2 (instantaneous power)
sigma = 1; N = 200000;
X = sigma * randn(1, N);
Y = X.^2;

figure;
histogram(Y, 150, 'Normalization', 'pdf', 'BinLimits', [0, 8]);
hold on;
y = linspace(0.01, 8, 300);
f_theory = chi2pdf(y/sigma^2, 1) / sigma^2;
plot(y, f_theory, 'r', 'LineWidth', 2);
xlabel('Power (V²)'); ylabel('PDF');
title('Distribution of Power Y = X²');
legend('Simulation', 'Theory (scaled χ²₁)');
```

### Example 3: SNR in dB from Linear SNR

```matlab
%% SNR transformation: Y = 10*log10(X)
% X ~ Exponential(1) (Rayleigh fading power, normalized)
N = 200000;
X = exprnd(1, 1, N);
Y = 10*log10(X);   % SNR in dB

figure;
histogram(Y, 150, 'Normalization', 'pdf');
hold on;
y = linspace(-30, 15, 300);
% Theoretical PDF of Y = 10*log10(X) where X ~ Exp(1)
f_Y = (log(10)/10) .* 10.^(y/10) .* exp(-10.^(y/10));
plot(y, f_Y, 'r', 'LineWidth', 2);
xlabel('SNR (dB)'); ylabel('PDF');
title('Distribution of SNR in dB (Rayleigh Fading)');
legend('Simulation', 'Theory');
```

### Example 4: Rayleigh Envelope from Gaussian Components

```matlab
%% Envelope of Complex Gaussian
sigma = 1; N = 100000;
I = sigma * randn(1, N);
Q = sigma * randn(1, N);
R = sqrt(I.^2 + Q.^2);

figure;
histogram(R, 100, 'Normalization', 'pdf');
hold on;
r = linspace(0, 5, 200);
plot(r, raylpdf(r, sigma), 'r', 'LineWidth', 2);
xlabel('Envelope |h|'); ylabel('PDF');
title('Rayleigh Distribution from I/Q Components');
legend('Simulation', 'Theory');
fprintf('Mean: Sim=%.3f, Theory=%.3f\n', mean(R), sigma*sqrt(pi/2));
```

### Example 5: Log-Normal from Gaussian

```matlab
%% Log-Normal: Y = exp(X) where X ~ N(mu, sigma^2)
mu = 0; sigma_x = 0.5; N = 100000;
X = mu + sigma_x*randn(1, N);
Y = exp(X);

figure;
histogram(Y, 150, 'Normalization', 'pdf', 'BinLimits', [0, 5]);
hold on;
y = linspace(0.01, 5, 300);
f_lognorm = lognpdf(y, mu, sigma_x);
plot(y, f_lognorm, 'r', 'LineWidth', 2);
xlabel('Y = e^X'); ylabel('PDF');
title('Log-Normal Distribution');
legend('Simulation', 'Theory');
```

---

## 5.8 Practice Problems

### Problem 1
Signal X ~ Uniform[0, 1]. Output Y = -2·ln(X). Find the PDF of Y and identify the distribution.

**Solution:** CDF method: F_Y(y) = P(-2ln(X) ≤ y) = P(X ≥ e^(-y/2)) = 1 - e^(-y/2) for y ≥ 0.
f_Y(y) = (1/2)e^(-y/2) → Y ~ Exponential(β = 2). (This is the inverse CDF method for generating exponentials!)

### Problem 2
Noise voltage X ~ N(0, σ²) with σ = 2V. Power dissipated in R = 50Ω: P = X²/R.
(a) Find E[P]. (b) Find the PDF of P. (c) Find P(P > 0.2W).

**Solution:**
(a) E[P] = E[X²]/R = σ²/R = 4/50 = 0.08W
(b) P = X²/50. Let W = X² ~ σ²·χ²(1). Then P = W/50. f_P(p) = 50·f_W(50p) = (50/(2σ²))·(50p/σ²)^(-1/2)·e^(-50p/(2σ²)) for p > 0.
(c) Use MATLAB: `1 - chi2cdf(0.2*50/4, 1)` = 1 - chi2cdf(2.5, 1) ≈ 0.114

### Problem 3
X ~ Exponential(λ = 1). Y = √X. Find f_Y(y).

**Solution:** g(x) = √x → x = y², dx/dy = 2y.
f_Y(y) = f_X(y²)·|2y| = e^(-y²)·2y for y ≥ 0. This is a Rayleigh distribution with σ² = 1/2.

### Problem 4
Distance D ~ Uniform[1, 10] km. Path loss: L = 20·log₁₀(D) dB. Find E[L] and the PDF of L.

**Solution:** E[L] = E[20·log₁₀(D)] = ∫₁¹⁰ 20·log₁₀(d)·(1/9) dd = (20/9)·∫₁¹⁰ log₁₀(d) dd
= (20/9)·[d·log₁₀(d) - d/ln(10)]₁¹⁰ = (20/9)·[10 - 10/ln10 + 1/ln10] = (20/9)·(10 - 9/ln10) ≈ 13.55 dB

PDF: L ranges from 0 to 20 dB. g⁻¹(l) = 10^(l/20), |dg⁻¹/dl| = (ln10/20)·10^(l/20).
f_L(l) = (1/9)·(ln10/20)·10^(l/20) for 0 ≤ l ≤ 20.

### Problem 5
Write MATLAB code to verify Problem 2 by simulation.

**Solution:**
```matlab
sigma = 2; R = 50; N = 500000;
X = sigma*randn(1,N);
P = X.^2 / R;
fprintf('E[P]: Theory=%.4f W, Sim=%.4f W\n', sigma^2/R, mean(P));
fprintf('P(P>0.2): Theory=%.4f, Sim=%.4f\n', 1-chi2cdf(0.2*R/sigma^2,1), mean(P>0.2));
```

---

*Next Module: [Module 6 — Two Random Variables](module06-two-random-variables.md)*
