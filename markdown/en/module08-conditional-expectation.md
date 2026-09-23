# Module 8 — Conditional Expectation and Variance

## Learning Objectives

After completing this module, students will be able to:
1. Compute conditional expectations and variances
2. Apply the Law of Total Expectation
3. Apply the Law of Total Variance
4. Use these tools for engineering analysis across multiple operating conditions

---

## 8.1 Introduction

Many engineering systems operate under **different conditions** (channel states, modes, environments). We often need the **overall average performance** computed from conditional performance in each state.

- What is the average BER when the channel randomly switches between good and bad?
- What is the overall measurement variance when the sensor operates in different environments?

---

## 8.2 Conditional Expectation E[X|Y=y]

### Definition

**Continuous:**
$$E[X|Y=y] = \int_{-\infty}^{\infty} x \cdot f_{X|Y}(x|y) \, dx$$

**Discrete:**
$$E[X|Y=y] = \sum_x x \cdot p_{X|Y}(x|y)$$

### Interpretation

E[X|Y=y] is the **average value of X** when we know Y = y. It is a function of y.

### E[X|Y] as a Random Variable

When Y is itself random, E[X|Y] is a **random variable** — it takes the value E[X|Y=y] when Y = y.

### Engineering Example

Average received power given channel state:
- Good channel (Y=1): E[P|Y=1] = 10 mW
- Poor channel (Y=0): E[P|Y=0] = 1 mW
- P(Y=1) = 0.7, P(Y=0) = 0.3

---

## 8.3 Conditional Variance Var(X|Y=y)

### Definition

$$\text{Var}(X|Y=y) = E[(X - E[X|Y=y])^2 | Y=y] = E[X^2|Y=y] - (E[X|Y=y])^2$$

### Interpretation

The conditional variance measures the **remaining uncertainty in X** after Y is known.

### Engineering Example

Measurement precision depends on temperature:
- At T=20°C: Var(X|T=20) = 0.01 (high precision)
- At T=80°C: Var(X|T=80) = 0.09 (low precision due to thermal effects)

---

## 8.4 Law of Total Expectation (Tower Property)

### Statement

$$E[X] = E[E[X|Y]]$$

**Discrete version:**
$$E[X] = \sum_y E[X|Y=y] \cdot P(Y=y)$$

**Continuous version:**
$$E[X] = \int_{-\infty}^{\infty} E[X|Y=y] \cdot f_Y(y) \, dy$$

### Proof (Discrete)

E[E[X|Y]] = Σ_y E[X|Y=y] · P(Y=y)
           = Σ_y [Σ_x x · P(X=x|Y=y)] · P(Y=y)
           = Σ_x Σ_y x · P(X=x, Y=y)
           = Σ_x x · P(X=x) = E[X] ✓

### Interpretation

The **overall average** equals the **weighted average of conditional averages**, weighted by the probability of each condition.

### Engineering Example: Average BER Across Channel States

A wireless system switches between three modes:
- Mode 1 (60% of time): BER = 10⁻⁶
- Mode 2 (30% of time): BER = 10⁻⁴
- Mode 3 (10% of time): BER = 10⁻²

Overall BER = E[BER] = 0.6(10⁻⁶) + 0.3(10⁻⁴) + 0.1(10⁻²)
            = 0.6×10⁻⁶ + 30×10⁻⁶ + 10000×10⁻⁶ ≈ 1.003 × 10⁻³

**Engineering insight:** The overall BER is dominated by the worst mode, even though it occurs only 10% of the time.

### Engineering Example: Average Lifetime with Defect Types

Components are defect-free (90%) or have a hidden defect (10%):
- Defect-free: E[T|good] = 10000 hours
- With defect: E[T|defect] = 500 hours

E[T] = 0.9(10000) + 0.1(500) = 9050 hours

---

## 8.5 Law of Total Variance

### Statement

$$\text{Var}(X) = E[\text{Var}(X|Y)] + \text{Var}(E[X|Y])$$

| Term | Name | Interpretation |
|------|------|---------------|
| Var(X) | Total variance | Overall uncertainty in X |
| E[Var(X\|Y)] | Expected conditional variance | Average "within-group" variability |
| Var(E[X\|Y]) | Variance of conditional means | "Between-group" variability |

### Proof

Var(X) = E[X²] - (E[X])²

E[X²] = E[E[X²|Y]] (tower property)
       = E[Var(X|Y) + (E[X|Y])²]
       = E[Var(X|Y)] + E[(E[X|Y])²]

(E[X])² = (E[E[X|Y]])²

Var(X) = E[Var(X|Y)] + E[(E[X|Y])²] - (E[E[X|Y]])²
       = E[Var(X|Y)] + Var(E[X|Y]) ✓

### Interpretation: Decomposition of Uncertainty

Total uncertainty = Average uncertainty within each condition + Variability of the mean across conditions

### Engineering Example: Sensor in Two Environments

A sensor operates indoors (Y=1, prob 0.6) and outdoors (Y=2, prob 0.4):
- Indoor: E[X|Y=1] = 25°C, Var(X|Y=1) = 1
- Outdoor: E[X|Y=2] = 15°C, Var(X|Y=2) = 16

**E[Var(X|Y)]** = 0.6(1) + 0.4(16) = 7.0 (average within-condition variance)

**Var(E[X|Y])** = E[(E[X|Y])²] - (E[E[X|Y]])²
= 0.6(25²) + 0.4(15²) - [0.6(25) + 0.4(15)]² = 375 + 90 - (21)² = 465 - 441 = 24

**Var(X)** = 7.0 + 24.0 = 31.0

Most variance comes from the **between-condition** difference (24 out of 31).

---

## 8.6 MATLAB Examples

### Example 1: Law of Total Expectation

```matlab
%% Average BER across channel states
% State probabilities and conditional BERs
p_state = [0.6, 0.3, 0.1];
BER_cond = [1e-6, 1e-4, 1e-2];

% Total expectation
BER_overall = sum(p_state .* BER_cond);
fprintf('Overall BER = %.4e\n', BER_overall);

% Simulation verification
N = 1000000;
states = randsample(1:3, N, true, p_state);
errors = rand(1,N) < BER_cond(states);
BER_sim = mean(errors);
fprintf('Simulated BER = %.4e\n', BER_sim);
```

### Example 2: Law of Total Variance

```matlab
%% Total Variance Decomposition: Sensor Example
N = 100000;
p_indoor = 0.6;

% Generate environment (1=indoor, 2=outdoor)
env = (rand(1,N) > p_indoor) + 1;

% Generate measurements conditional on environment
X = zeros(1, N);
X(env==1) = 25 + 1*randn(1, sum(env==1));    % Indoor: N(25, 1)
X(env==2) = 15 + 4*randn(1, sum(env==2));    % Outdoor: N(15, 16)

% Total variance
total_var = var(X);

% E[Var(X|Y)]
within_var = p_indoor*var(X(env==1)) + (1-p_indoor)*var(X(env==2));

% Var(E[X|Y])
cond_means = [mean(X(env==1)), mean(X(env==2))];
between_var = p_indoor*cond_means(1)^2 + (1-p_indoor)*cond_means(2)^2 ...
              - (p_indoor*cond_means(1) + (1-p_indoor)*cond_means(2))^2;

fprintf('Total Var(X) = %.2f (theory: 31.0)\n', total_var);
fprintf('E[Var(X|Y)]  = %.2f (theory: 7.0)\n', within_var);
fprintf('Var(E[X|Y])  = %.2f (theory: 24.0)\n', between_var);
fprintf('Sum           = %.2f\n', within_var + between_var);
```

### Example 3: Conditional Expectation as Best Predictor

```matlab
%% E[X|Y] as a function of Y
% Joint: X = Y + N, Y ~ Uniform(0,10), N ~ N(0, 1)
N_samp = 50000;
Y = 10*rand(1, N_samp);
X = Y + randn(1, N_samp);

% Estimate E[X|Y=y] for various y
y_bins = 0:0.5:10;
E_X_given_Y = zeros(size(y_bins)-[0 1]);
for i = 1:length(y_bins)-1
    mask = Y >= y_bins(i) & Y < y_bins(i+1);
    E_X_given_Y(i) = mean(X(mask));
end
y_centers = (y_bins(1:end-1) + y_bins(2:end))/2;

figure;
scatter(Y(1:5000), X(1:5000), 1, 'b', '.');
hold on;
plot(y_centers, E_X_given_Y, 'r-', 'LineWidth', 3);
plot(y_centers, y_centers, 'g--', 'LineWidth', 2);
xlabel('Y'); ylabel('X');
legend('Data (X,Y)', 'E[X|Y] (estimated)', 'E[X|Y] = Y (theory)');
title('Conditional Expectation');
```

---

## 8.7 Practice Problems

### Problem 1
A digital link operates over two channel types:
- Type A (prob 0.7): E[delay|A] = 5ms, Var(delay|A) = 2
- Type B (prob 0.3): E[delay|B] = 20ms, Var(delay|B) = 25

Find (a) E[delay], (b) Var(delay).

**Solution:**
(a) E[D] = 0.7(5) + 0.3(20) = 3.5 + 6 = 9.5 ms
(b) E[Var(D|type)] = 0.7(2) + 0.3(25) = 1.4 + 7.5 = 8.9
    Var(E[D|type]) = 0.7(5²) + 0.3(20²) - 9.5² = 17.5 + 120 - 90.25 = 47.25
    Var(D) = 8.9 + 47.25 = 56.15

### Problem 2
A random number N of components are tested. N ~ Poisson(10). Each has independent failure probability p=0.05. Let X = number of failures. Find E[X] and Var(X).

**Solution:**
X|N ~ Binomial(N, 0.05). E[X|N] = 0.05N. Var(X|N) = N(0.05)(0.95) = 0.0475N.
E[X] = E[E[X|N]] = E[0.05N] = 0.05(10) = 0.5
Var(X) = E[Var(X|N)] + Var(E[X|N]) = E[0.0475N] + Var(0.05N) = 0.0475(10) + 0.05²(10) = 0.475 + 0.025 = 0.5

### Problem 3
Write MATLAB code to verify Problem 2 by simulation.

**Solution:**
```matlab
N_trials = 100000; p = 0.05; lambda = 10;
N = poissrnd(lambda, 1, N_trials);
X = binornd(N, p);
fprintf('E[X]: theory=0.5, sim=%.3f\n', mean(X));
fprintf('Var(X): theory=0.5, sim=%.3f\n', var(X));
```

---

*Next Module: [Module 9 — Covariance and Correlation](module09-covariance-correlation.md)*
