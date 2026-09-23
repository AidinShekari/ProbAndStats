# Module 6 — Two Random Variables

## Learning Objectives

After completing this module, students will be able to:
1. Define and compute joint PMF, PDF, and CDF
2. Derive marginal distributions from joint distributions
3. Compute conditional distributions
4. Test independence of two random variables
5. Compute conditional expectations
6. Visualize joint distributions in MATLAB

---

## 6.1 Introduction: Why Study Joint Distributions?

Real engineering systems involve **multiple interacting uncertain quantities**:
- Voltage AND current in a noisy circuit
- Signal AND noise at a receiver
- Temperature AND resistance of a sensor
- I-channel AND Q-channel of a communication signal

Understanding the **joint behavior** tells us things marginals cannot — like correlation, dependence, and conditional behavior.

---

## 6.2 Joint PMF (Discrete Case)

### Definition

For discrete RVs X, Y:
$$p_{X,Y}(x,y) = P(X = x, Y = y)$$

### Properties
1. p_{X,Y}(x,y) ≥ 0
2. Σ_x Σ_y p_{X,Y}(x,y) = 1

### Visualization: Probability Table

**Example:** X = number of retransmissions (0,1,2), Y = acknowledgment delay category (1=fast, 2=slow)

| | Y=1 | Y=2 | p_X(x) |
|---|---|---|---|
| X=0 | 0.30 | 0.10 | 0.40 |
| X=1 | 0.15 | 0.20 | 0.35 |
| X=2 | 0.05 | 0.20 | 0.25 |
| p_Y(y) | 0.50 | 0.50 | 1.00 |

---

## 6.3 Joint PDF (Continuous Case)

### Definition

For continuous RVs X, Y, the joint PDF f_{X,Y}(x,y) satisfies:
$$P((X,Y) \in A) = \iint_A f_{X,Y}(x,y) \, dx \, dy$$

### Properties
1. f_{X,Y}(x,y) ≥ 0
2. ∫∫ f_{X,Y}(x,y) dx dy = 1

### Visualization

The joint PDF is a **surface** over the (x,y) plane. Probability = volume under surface over a region.

### Engineering Example: Bivariate Gaussian

Two correlated noise voltages (X, Y) with correlation ρ:

$$f_{X,Y}(x,y) = \frac{1}{2\pi\sigma_X\sigma_Y\sqrt{1-\rho^2}} \exp\left(-\frac{1}{2(1-\rho^2)}\left[\frac{x^2}{\sigma_X^2} - \frac{2\rho xy}{\sigma_X\sigma_Y} + \frac{y^2}{\sigma_Y^2}\right]\right)$$

---

## 6.4 Joint CDF

### Definition

$$F_{X,Y}(x,y) = P(X \leq x, Y \leq y)$$

### Properties
1. F_{X,Y}(-∞, y) = 0, F_{X,Y}(x, -∞) = 0
2. F_{X,Y}(∞, ∞) = 1
3. Non-decreasing in both arguments
4. f_{X,Y}(x,y) = ∂²F_{X,Y}/(∂x ∂y)

---

## 6.5 Marginal Distributions

### Obtaining Marginals from Joint

**Discrete:**
$$p_X(x) = \sum_y p_{X,Y}(x,y), \quad p_Y(y) = \sum_x p_{X,Y}(x,y)$$

**Continuous:**
$$f_X(x) = \int_{-\infty}^{\infty} f_{X,Y}(x,y) \, dy, \quad f_Y(y) = \int_{-\infty}^{\infty} f_{X,Y}(x,y) \, dx$$

### Visual Interpretation

The marginal PDF f_X(x) is the **projection** (integral) of the joint surface onto the x-axis. Similarly f_Y(y) projects onto the y-axis.

### Engineering Example

Joint PDF: f_{X,Y}(x,y) = 2e^(-x)e^(-2y), x ≥ 0, y ≥ 0

Marginals:
- f_X(x) = ∫₀^∞ 2e^(-x)e^(-2y) dy = 2e^(-x) · [1/2] = e^(-x) → X ~ Exp(1)
- f_Y(y) = ∫₀^∞ 2e^(-x)e^(-2y) dx = 2e^(-2y) · [1] = 2e^(-2y) → Y ~ Exp(2)

---

## 6.6 Conditional Distributions

### Discrete

$$p_{X|Y}(x|y) = \frac{p_{X,Y}(x,y)}{p_Y(y)}$$

### Continuous

$$f_{X|Y}(x|y) = \frac{f_{X,Y}(x,y)}{f_Y(y)}$$

### Interpretation

The conditional distribution describes X when we **know** Y = y. It's a "slice" of the joint distribution at a fixed y value, renormalized to integrate to 1.

### Engineering Example: Signal Given Channel State

Received power Y given channel state X:
- If channel is good (X=1): Y ~ N(10, 1)
- If channel is poor (X=0): Y ~ N(2, 4)
- P(X=1) = 0.7, P(X=0) = 0.3

Conditional PDFs describe receiver behavior in each state.

---

## 6.7 Independence of Two Random Variables

### Definition

X and Y are independent if and only if:

$$f_{X,Y}(x,y) = f_X(x) \cdot f_Y(y) \quad \text{for all } x, y$$

(Or equivalently for PMFs: p_{X,Y}(x,y) = p_X(x)·p_Y(y))

### Consequences of Independence
- f_{X|Y}(x|y) = f_X(x) (knowing Y doesn't change X)
- E[XY] = E[X]E[Y]
- Var(X + Y) = Var(X) + Var(Y)

### Testing Independence
Check: Does the joint factor into a product of a function of x alone and y alone?
- f_{X,Y}(x,y) = 2e^(-x)·e^(-2y) = [e^(-x)]·[2e^(-2y)] ✓ Independent!
- f_{X,Y}(x,y) = x + y for 0≤x,y≤1 → cannot factor → NOT independent

### Engineering Example: Signal and Independent Noise

Transmitted signal S and channel noise N are independent by physical assumption:
f_{S,N}(s,n) = f_S(s)·f_N(n)

This independence assumption is fundamental to communication system design.

---

## 6.8 Conditional Expectation

### Definition

$$E[X|Y=y] = \begin{cases} \sum_x x \cdot p_{X|Y}(x|y) & \text{discrete} \\ \int_{-\infty}^{\infty} x \cdot f_{X|Y}(x|y) \, dx & \text{continuous} \end{cases}$$

### Interpretation

E[X|Y=y] is the **best prediction** of X given that we observed Y = y (in the mean-square sense).

### Engineering Example: Temperature-Dependent Resistance

A resistor's value R depends on temperature T. If R|T ~ N(1000 + 0.5T, 4):

E[R|T=50°C] = 1000 + 0.5(50) = 1025Ω

Given temperature, we can predict resistance.

---

## 6.9 MATLAB Examples

### Example 1: Joint PMF Visualization

```matlab
%% Joint PMF: Retransmissions vs Delay Category
pXY = [0.30 0.10; 0.15 0.20; 0.05 0.20];
x = 0:2; y = 1:2;

figure;
bar3(pXY);
xlabel('Delay Category Y'); ylabel('Retransmissions X');
zlabel('P(X=x, Y=y)');
title('Joint PMF');

% Marginals
pX = sum(pXY, 2)';   % Sum over Y
pY = sum(pXY, 1);    % Sum over X
fprintf('Marginal of X: [%.2f %.2f %.2f]\n', pX);
fprintf('Marginal of Y: [%.2f %.2f]\n', pY);
```

### Example 2: Bivariate Gaussian Visualization

```matlab
%% Joint Gaussian PDF with Correlation
mu = [0 0]; sigma_x = 1; sigma_y = 1.5; rho = 0.7;
Sigma = [sigma_x^2, rho*sigma_x*sigma_y; rho*sigma_x*sigma_y, sigma_y^2];

[X, Y] = meshgrid(linspace(-4, 4, 100), linspace(-5, 5, 100));
XY = [X(:) Y(:)];
Z = mvnpdf(XY, mu, Sigma);
Z = reshape(Z, size(X));

figure;
subplot(1,2,1);
surf(X, Y, Z, 'EdgeColor', 'none'); view(30, 40);
xlabel('X'); ylabel('Y'); zlabel('f_{X,Y}(x,y)');
title(sprintf('Joint Gaussian (ρ = %.1f)', rho));

subplot(1,2,2);
contour(X, Y, Z, 20);
xlabel('X'); ylabel('Y');
title('Contour Plot');
axis equal;
```

### Example 3: Testing Independence

```matlab
%% Independence Check via Simulation
N = 100000;

% Case 1: Independent (signal and noise)
S = randn(1, N);               % Signal
Noise = 0.5*randn(1, N);       % Independent noise
R = S + Noise;                  % Received

% Case 2: Dependent (voltage and current through same resistor)
V = randn(1, N);               % Voltage
I = V / 50 + 0.01*randn(1,N); % Current (dependent on V!)

fprintf('Independent (S, Noise): corr = %.4f\n', corr(S', Noise'));
fprintf('Dependent (V, I): corr = %.4f\n', corr(V', I'));
```

### Example 4: Conditional Distribution

```matlab
%% Conditional PDF: Slice of Bivariate Gaussian
rho = 0.8; N = 100000;
X = randn(1, N);
Y = rho*X + sqrt(1-rho^2)*randn(1, N);  % Y|X ~ N(rho*x, 1-rho^2)

% Conditional: Y given X ≈ 1 (take samples where 0.9 < X < 1.1)
mask = (X > 0.9) & (X < 1.1);
Y_cond = Y(mask);

figure;
histogram(Y_cond, 50, 'Normalization', 'pdf');
hold on;
y = linspace(-3, 4, 200);
plot(y, normpdf(y, rho*1, sqrt(1-rho^2)), 'r', 'LineWidth', 2);
xlabel('Y'); ylabel('PDF');
title('f_{Y|X}(y|X≈1) for Bivariate Gaussian');
legend('Empirical', sprintf('N(%.1f, %.2f)', rho, 1-rho^2));
```

---

## 6.10 Practice Problems

### Problem 1
Joint PDF: f_{X,Y}(x,y) = 6(1-y) for 0 ≤ x ≤ y ≤ 1, zero elsewhere.
(a) Verify normalization. (b) Find marginals. (c) Are X,Y independent? (d) Find P(X < 0.5, Y < 0.5).

**Solution:**
(a) ∫₀¹ ∫₀ʸ 6(1-y) dx dy = ∫₀¹ 6y(1-y) dy = 6[y²/2 - y³/3]₀¹ = 6(1/2 - 1/3) = 1 ✓
(b) f_X(x) = ∫ₓ¹ 6(1-y) dy = 6[(1-y²/2) - (y)]ₓ¹ = 3(1-x)²; f_Y(y) = 6y(1-y)
(c) f_{X,Y} ≠ f_X · f_Y → NOT independent (also, the support is triangular, not rectangular)
(d) P(X<0.5, Y<0.5) = ∫₀^0.5 ∫₀^y 6(1-y) dx dy = ∫₀^0.5 6y(1-y) dy = 6[y²/2 - y³/3]₀^0.5 = 0.500

### Problem 2
Two sensors measure the same signal with independent noise. X = S + N₁, Y = S + N₂ where S=5V, N₁~N(0,1), N₂~N(0,4). Are X and Y independent? Find E[X], E[Y], and explain why Cov(X,Y) ≠ 0.

**Solution:** X and Y are NOT independent because they share S (though noise is independent). E[X] = E[Y] = 5. Cov(X,Y) = Cov(S+N₁, S+N₂) = Var(S) + Cov(S,N₁) + Cov(N₂,S) + Cov(N₁,N₂). Since S is constant, Var(S)=0, so if S were random they'd be correlated. With S fixed, X and Y are actually independent in this case. If S is random with Var(S) = σ_S², then Cov(X,Y) = σ_S².

### Problem 3
Given joint PMF in the table of Section 6.2, find (a) P(X≤1, Y=2), (b) f_{X|Y}(x|Y=1), (c) E[X|Y=1].

**Solution:**
(a) P(X≤1, Y=2) = p(0,2) + p(1,2) = 0.10 + 0.20 = 0.30
(b) p_{X|Y}(x|1) = p(x,1)/p_Y(1): p(0|1)=0.30/0.50=0.60, p(1|1)=0.15/0.50=0.30, p(2|1)=0.05/0.50=0.10
(c) E[X|Y=1] = 0(0.60) + 1(0.30) + 2(0.10) = 0.50

---

*Next Module: [Module 7 — Functions of Two Random Variables](module07-functions-two-rv.md)*
