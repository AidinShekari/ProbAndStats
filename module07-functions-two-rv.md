# Module 7 — Functions of Two Random Variables

## Learning Objectives

After completing this module, students will be able to:
1. Derive the distribution of Z = X + Y using convolution
2. Find distributions of differences, products, ratios, max, and min
3. Apply the bivariate Jacobian transformation method
4. Connect these results to engineering applications (signal+noise, reliability)

---

## 7.1 Introduction

Engineering systems combine random variables:
- **Received signal** = transmitted + noise: R = S + N
- **Total interference** = sum of multiple sources: I = I₁ + I₂ + ... + Iₙ
- **System lifetime** = minimum of component lifetimes: T = min(T₁, T₂)
- **SNR** = signal power / noise power: ratio of RVs

We need methods to find distributions of **functions of two (or more) RVs**.

---

## 7.2 Sum of Two Random Variables: Z = X + Y

### CDF Method

F_Z(z) = P(X + Y ≤ z) = ∫∫_{x+y≤z} f_{X,Y}(x,y) dx dy

### Convolution Formula (Independent Case)

If X and Y are **independent**:

$$f_Z(z) = \int_{-\infty}^{\infty} f_X(x) \cdot f_Y(z-x) \, dx = (f_X * f_Y)(z)$$

This is the **convolution** of f_X and f_Y.

### Derivation

F_Z(z) = P(X + Y ≤ z) = ∫_{-∞}^{∞} ∫_{-∞}^{z-x} f_X(x)f_Y(y) dy dx
       = ∫_{-∞}^{∞} f_X(x) F_Y(z-x) dx

Differentiating: f_Z(z) = ∫_{-∞}^{∞} f_X(x) f_Y(z-x) dx ✓

### Important Special Cases

**Sum of two Gaussians (independent):**
X ~ N(μ₁, σ₁²), Y ~ N(μ₂, σ₂²) → Z = X+Y ~ N(μ₁+μ₂, σ₁²+σ₂²)

**Sum of two exponentials (same rate):**
X, Y ~ Exp(λ) independent → Z ~ Gamma(2, 1/λ) = Erlang(2, λ)

**Sum of two Poissons:**
X ~ Poisson(λ₁), Y ~ Poisson(λ₂) independent → Z ~ Poisson(λ₁+λ₂)

**Sum of two uniforms:**
X, Y ~ Uniform(0,1) independent → Z has triangular distribution on [0,2]

### Engineering Example: Signal + Noise

Transmitted signal S ~ N(A, σ_s²), noise N ~ N(0, σ_n²), independent.
Received: R = S + N ~ N(A, σ_s² + σ_n²)

The received signal is still Gaussian — with increased variance (reduced SNR).

---

## 7.3 Difference: Z = X - Y

For independent X, Y:
$$f_Z(z) = \int_{-\infty}^{\infty} f_X(x) \cdot f_Y(x-z) \, dx$$

**Gaussian case:** X ~ N(μ₁, σ₁²), Y ~ N(μ₂, σ₂²) → Z = X-Y ~ N(μ₁-μ₂, σ₁²+σ₂²)

Note: variances still ADD (not subtract) because Var(-Y) = Var(Y).

### Engineering Example: Differential Measurement

Two sensors measure same quantity: X₁ = θ + N₁, X₂ = θ + N₂.
Difference: X₁ - X₂ = N₁ - N₂ ~ N(0, σ₁² + σ₂²)

The difference eliminates the common signal but doubles the noise variance.

---

## 7.4 Product: Z = XY

For independent X, Y:
$$f_Z(z) = \int_{-\infty}^{\infty} \frac{1}{|x|} f_X(x) \cdot f_Y(z/x) \, dx$$

### Engineering Example: Power

Voltage V and current I in a linear circuit: P = V·I.
If V and I have known joint distribution, we can find the power distribution.

---

## 7.5 Ratio: Z = X/Y

For independent X, Y:
$$f_Z(z) = \int_{-\infty}^{\infty} |y| \cdot f_X(zy) \cdot f_Y(y) \, dy$$

### Engineering Example: SNR

SNR = Signal Power / Noise Power = P_s / P_n

If both are chi-squared distributed (sum of squared Gaussians), the ratio follows an **F-distribution**.

---

## 7.6 Maximum: Z = max(X, Y)

### CDF Approach

F_Z(z) = P(max(X,Y) ≤ z) = P(X ≤ z AND Y ≤ z)

If independent: F_Z(z) = F_X(z) · F_Y(z)

PDF: f_Z(z) = f_X(z)F_Y(z) + F_X(z)f_Y(z)

### Engineering Example: Parallel Redundancy

System works if AT LEAST ONE component works. System fails only when ALL fail.
System lifetime = max(T₁, T₂) for parallel redundant components.

For T₁, T₂ ~ Exp(λ) independent:
F_Z(z) = (1 - e^(-λz))² for z ≥ 0

f_Z(z) = 2λe^(-λz)(1 - e^(-λz))

Mean lifetime: E[max] = 3/(2λ) > 1/λ = E[single component] (reliability improved!)

---

## 7.7 Minimum: Z = min(X, Y)

### Survival Function Approach

P(Z > z) = P(min(X,Y) > z) = P(X > z AND Y > z)

If independent: P(Z > z) = P(X > z) · P(Y > z) = [1-F_X(z)][1-F_Y(z)]

CDF: F_Z(z) = 1 - [1-F_X(z)][1-F_Y(z)]

### Engineering Example: Series System

System fails when FIRST component fails. System lifetime = min(T₁, T₂).

For T₁ ~ Exp(λ₁), T₂ ~ Exp(λ₂) independent:
P(Z > z) = e^(-λ₁z) · e^(-λ₂z) = e^(-(λ₁+λ₂)z)

Therefore: min(T₁, T₂) ~ Exp(λ₁ + λ₂)

**Key result:** Failure rates ADD in series systems. Mean lifetime = 1/(λ₁+λ₂) < min(1/λ₁, 1/λ₂).

---

## 7.8 General Bivariate Transformation (Jacobian Method)

### Setup

Given (X, Y) with known joint PDF, find the joint PDF of (U, V) where:
- U = g₁(X, Y)
- V = g₂(X, Y)

### Procedure

1. Solve for the inverse: X = h₁(U, V), Y = h₂(U, V)
2. Compute the Jacobian determinant:

$$J = \begin{vmatrix} \frac{\partial x}{\partial u} & \frac{\partial x}{\partial v} \\ \frac{\partial y}{\partial u} & \frac{\partial y}{\partial v} \end{vmatrix}$$

3. Apply:
$$f_{U,V}(u,v) = f_{X,Y}(h_1(u,v), h_2(u,v)) \cdot |J|$$

4. If only U is needed, marginalize out V.

### Example: Sum and Difference

U = X + Y, V = X - Y → X = (U+V)/2, Y = (U-V)/2

J = |∂x/∂u · ∂y/∂v - ∂x/∂v · ∂y/∂u| = |(1/2)(-1/2) - (1/2)(1/2)| = 1/2

f_{U,V}(u,v) = (1/2) · f_{X,Y}((u+v)/2, (u-v)/2)

---

## 7.9 MATLAB Examples

### Example 1: Convolution — Sum of Two Uniforms

```matlab
%% Z = X + Y, both Uniform(0,1)
N = 200000;
X = rand(1, N); Y = rand(1, N);
Z = X + Y;

figure;
histogram(Z, 100, 'Normalization', 'pdf');
hold on;
z = linspace(0, 2, 200);
f_theory = max(0, 1 - abs(z - 1));  % Triangular PDF
plot(z, f_theory, 'r', 'LineWidth', 2);
xlabel('Z = X + Y'); ylabel('PDF');
title('Sum of Two Uniforms → Triangular');
legend('Simulation', 'Theory');
```

### Example 2: Sum of Gaussians (Signal + Noise)

```matlab
%% Received = Signal + Noise
mu_s = 3; sigma_s = 0.5;  % Signal
sigma_n = 1;               % Noise (zero-mean)
N = 100000;

S = mu_s + sigma_s*randn(1,N);
Noise = sigma_n*randn(1,N);
R = S + Noise;

fprintf('E[R]: Theory=%.2f, Sim=%.2f\n', mu_s, mean(R));
fprintf('Var(R): Theory=%.2f, Sim=%.2f\n', sigma_s^2+sigma_n^2, var(R));
fprintf('SNR = %.2f dB\n', 10*log10(mu_s^2/(sigma_s^2+sigma_n^2)));
```

### Example 3: Series System Reliability (Minimum)

```matlab
%% Series System: T_sys = min(T1, T2)
lambda1 = 0.001; lambda2 = 0.002;  % Failure rates per hour
N = 100000;

T1 = exprnd(1/lambda1, 1, N);
T2 = exprnd(1/lambda2, 1, N);
T_sys = min(T1, T2);

fprintf('MTTF component 1: %.0f hours\n', 1/lambda1);
fprintf('MTTF component 2: %.0f hours\n', 1/lambda2);
fprintf('MTTF system (theory): %.0f hours\n', 1/(lambda1+lambda2));
fprintf('MTTF system (sim): %.0f hours\n', mean(T_sys));
```

### Example 4: Parallel System (Maximum)

```matlab
%% Parallel System: T_sys = max(T1, T2)
lambda = 0.01; N = 100000;
T1 = exprnd(1/lambda, 1, N);
T2 = exprnd(1/lambda, 1, N);
T_parallel = max(T1, T2);

fprintf('MTTF single: %.0f hours\n', 1/lambda);
fprintf('MTTF parallel (theory): %.0f hours\n', 3/(2*lambda));
fprintf('MTTF parallel (sim): %.0f hours\n', mean(T_parallel));
```

---

## 7.10 Practice Problems

### Problem 1
X ~ Exp(1), Y ~ Exp(1), independent. Find the PDF of Z = X + Y.

**Solution:** Convolution: f_Z(z) = ∫₀ᶻ e^(-x)·e^(-(z-x)) dx = ∫₀ᶻ e^(-z) dx = ze^(-z), z≥0.
This is Gamma(2,1) = Erlang(2,1). E[Z] = 2, Var(Z) = 2.

### Problem 2
Three components in series with failure rates λ₁=0.001, λ₂=0.002, λ₃=0.003 per hour.
(a) Find system MTTF. (b) Find P(system survives 100 hours).

**Solution:**
(a) MTTF = 1/(0.001+0.002+0.003) = 1/0.006 = 166.7 hours
(b) P(T_sys > 100) = e^(-0.006×100) = e^(-0.6) = 0.549

### Problem 3
X ~ N(5, 4), Y ~ N(3, 9), independent. Find distribution and P(X + Y > 12).

**Solution:** Z = X+Y ~ N(8, 13). P(Z>12) = P(Z' > (12-8)/√13) = Q(1.109) = 0.1337.

---

*Next Module: [Module 8 — Conditional Expectation and Variance](module08-conditional-expectation.md)*
