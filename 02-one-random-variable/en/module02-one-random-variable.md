# Module 2 — One Random Variable and Its Functions

## Learning Objectives

After completing this module, students will be able to:

1. Define random variables and explain their role in engineering analysis
2. Distinguish between discrete and continuous random variables
3. Compute and interpret PMF, PDF, and CDF
4. Clearly explain the difference between probability mass, density, and cumulative probability
5. Apply transformations to random variables
6. Use MATLAB to generate, visualize, and analyze random variables

---

## 2.1 Introduction: Why Random Variables?

### The Problem

In Module 1, we worked with events — subsets of a sample space. But engineering analysis requires **numbers**:

- How much noise voltage is present?
- How many packets arrived?
- What is the received signal power?

A **random variable** maps outcomes of a random experiment to real numbers, enabling us to use all the tools of calculus and algebra.

### Engineering Motivation

| We want to analyze... | We define a random variable... |
|----------------------|-------------------------------|
| Noise in a circuit | X = noise voltage (volts) |
| Bit errors in a frame | N = number of bit errors |
| Component lifetime | T = time until failure (hours) |
| Signal amplitude | A = received amplitude (V) |
| Packet delay | D = end-to-end delay (ms) |

---

## 2.2 Definition of a Random Variable

### Formal Definition

A **random variable** X is a function that maps each outcome ω in the sample space S to a real number:

$$X: S \rightarrow \mathbb{R}$$
$$\omega \mapsto X(\omega)$$

### Interpretation

The random variable assigns a numerical value to each possible outcome of the experiment. The randomness comes from which outcome ω occurs — once ω is determined, X(ω) is a definite number.

### Engineering Example

**Experiment:** Transmit 5 bits over a noisy channel.
**Sample space:** S = all possible sequences of correct/error for 5 bits (2⁵ = 32 outcomes)
**Random variable:** X = number of bit errors

| Outcome ω | X(ω) |
|-----------|------|
| (C,C,C,C,C) | 0 |
| (E,C,C,C,C) | 1 |
| (E,E,C,C,C) | 2 |
| ... | ... |
| (E,E,E,E,E) | 5 |

Now instead of working with 32 outcomes, we work with a single number X ∈ {0,1,2,3,4,5}.

---

## 2.3 Discrete Random Variables

### Definition

A random variable X is **discrete** if it takes values from a **countable** set (finite or countably infinite).

### Characteristics
- Values can be listed: {x₁, x₂, x₃, ...}
- Each value has a specific probability (a "mass" of probability)
- Sum of all probabilities = 1

### Engineering Examples

| Random Variable | Possible Values | Context |
|----------------|-----------------|---------|
| Number of bit errors | {0, 1, 2, ..., n} | Packet transmission |
| Number of retransmissions | {0, 1, 2, ...} | ARQ protocol |
| Quantized voltage level | {0, 1, ..., 2ᴺ-1} | N-bit ADC output |
| Number of arrivals per second | {0, 1, 2, ...} | Network traffic |
| Number of defective chips | {0, 1, ..., n} | Wafer testing |

---

## 2.4 Continuous Random Variables

### Definition

A random variable X is **continuous** if it takes values from an **uncountable** set (interval of real numbers).

### Characteristics
- X can take any value in a range (e.g., [0, ∞) or (-∞, ∞))
- Probability of any single exact value is ZERO: P(X = x) = 0
- Probabilities are defined for intervals: P(a ≤ X ≤ b)

### Engineering Examples

| Random Variable | Range | Context |
|----------------|-------|---------|
| Thermal noise voltage | (-∞, ∞) | Circuit noise |
| Time until failure | [0, ∞) | Reliability |
| Phase of received signal | [0, 2π) | Communications |
| Resistor value | (R₀ - δ, R₀ + δ) | Manufacturing |
| Channel gain | [0, ∞) | Wireless fading |

### Why P(X = x) = 0 for Continuous RVs

Imagine measuring a voltage. The probability that V = exactly 3.14159265... volts (infinite precision) is zero. We can only ask about intervals: P(3.14 < V < 3.15).

---

## 2.5 Probability Mass Function (PMF)

### Definition

For a discrete random variable X, the **probability mass function** is:

$$p_X(x) = P(X = x)$$

### Properties

1. **Non-negativity:** p_X(x) ≥ 0 for all x
2. **Normalization:** Σ p_X(xᵢ) = 1 (sum over all possible values)
3. **Probability computation:** P(X ∈ A) = Σ_{x∈A} p_X(x)

### Visualization

The PMF is represented as **vertical lines** (impulses) at each possible value, with height equal to the probability.

```{.figure #m02-pmf-stems}
p_X(x)
  |
0.4|     |
  |     |
0.3|  |  |
  |  |  |
0.2|  |  |  |
  |  |  |  |
0.1|  |  |  |  |
  |  |  |  |  |
  +--+--+--+--+--→ x
     0  1  2  3  4
```

### Engineering Example: Bit Errors in a Byte

Transmit 8 bits, each with independent error probability p = 0.1.
X = number of bit errors.

p_X(k) = C(8,k) · (0.1)^k · (0.9)^(8-k), for k = 0, 1, ..., 8

| k | p_X(k) |
|---|--------|
| 0 | 0.4305 |
| 1 | 0.3826 |
| 2 | 0.1488 |
| 3 | 0.0331 |
| 4 | 0.0046 |
| 5+ | < 0.001 |

---

## 2.6 Probability Density Function (PDF)

### Definition

For a continuous random variable X, the **probability density function** f_X(x) is defined such that:

$$P(a \leq X \leq b) = \int_a^b f_X(x) \, dx$$

### Properties

1. **Non-negativity:** f_X(x) ≥ 0 for all x
2. **Normalization:** ∫_{-∞}^{∞} f_X(x) dx = 1
3. **Probability = Area under curve** between two points

### Critical Point: f_X(x) is NOT a Probability!

> ⚠️ f_X(x) can be GREATER than 1!

The PDF gives probability **density** — probability per unit length. Only the **integral** (area) gives probability.

**Analogy:** Mass density (kg/m³) is not mass. You need to integrate density over volume to get mass. Similarly, probability density is not probability — you integrate over an interval to get probability.

### Visualization

```{.figure #m02-pdf-area}
f_X(x)
  |
  |      ╭────╮
  |     ╱ ░░░░ ╲        ← Shaded area = P(a ≤ X ≤ b)
  |    ╱ ░░░░░░ ╲
  |   ╱ ░░░░░░░░ ╲
  |──╱───░░░░░░░░──╲──→ x
  |      a      b
  Total area under curve = 1
```

### Engineering Example: Thermal Noise Voltage

Thermal noise voltage in a circuit often follows a Gaussian distribution:

$$f_X(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-x^2/(2\sigma^2)}$$

where σ is the RMS noise voltage.

P(noise exceeds 2σ) = P(|X| > 2σ) = 1 - P(-2σ ≤ X ≤ 2σ) ≈ 1 - 0.9545 = 0.0455

---

## 2.7 Cumulative Distribution Function (CDF)

### Definition

For any random variable X (discrete or continuous), the **cumulative distribution function** is:

$$F_X(x) = P(X \leq x)$$

### Properties

1. **Non-decreasing:** if a < b, then F_X(a) ≤ F_X(b)
2. **Limits:** F_X(-∞) = 0, F_X(+∞) = 1
3. **Right-continuous:** F_X(x) is continuous from the right
4. **Probability of interval:** P(a < X ≤ b) = F_X(b) - F_X(a)

### CDF for Discrete RVs

The CDF is a **staircase function** with jumps at each possible value:

```{.figure #m02-cdf-discrete}
F_X(x)
  |
1.0|                          ──────────
  |                    ○─────┘
0.8|              ○────┘
  |         ○───┘
0.4|    ○───┘
  |────┘
0.0|
  +----+----+----+----+---→ x
       0    1    2    3
```

Jump at x = k has height p_X(k).

### CDF for Continuous RVs

The CDF is a **smooth, continuous** curve:

$$F_X(x) = \int_{-\infty}^{x} f_X(t) \, dt$$

And conversely:
$$f_X(x) = \frac{dF_X(x)}{dx}$$

```{.figure #m02-cdf-continuous}
F_X(x)
  |
1.0|                         ___________
  |                    ╱
  |                 ╱
0.5|             ╱
  |          ╱
  |       ╱
0.0|______╱
  +---+---+---+---+---+---→ x
```

### Relationship: PDF ↔ CDF

| Direction | Formula | Meaning |
|-----------|---------|---------|
| PDF → CDF | F_X(x) = ∫_{-∞}^x f_X(t)dt | Integrate density to get cumulative probability |
| CDF → PDF | f_X(x) = dF_X/dx | Differentiate CDF to get density |



---

## 2.8 KEY DISTINCTION: Mass vs. Density vs. Cumulative

This is one of the most important conceptual distinctions in probability theory.

### Comparison Table

| Property | PMF p_X(x) | PDF f_X(x) | CDF F_X(x) |
|----------|-----------|-----------|-----------|
| **Applies to** | Discrete RVs only | Continuous RVs only | Both |
| **Gives directly** | P(X = x) | Probability density at x | P(X ≤ x) |
| **Range of values** | [0, 1] | [0, ∞) — can exceed 1! | [0, 1] |
| **Sum/Integral** | Σ p_X(x) = 1 | ∫ f_X(x)dx = 1 | Starts at 0, ends at 1 |
| **Get probability** | P(X=x) = p_X(x) | P(a≤X≤b) = ∫ f_X(x)dx | P(a<X≤b) = F(b)-F(a) |

### Visual Analogy: The Warehouse

Imagine probability as "material" distributed across possible values:

**Discrete (PMF):** Like storing material in numbered boxes. Each box has a specific mass. The PMF tells you the mass in each box.

```{.figure #m02-pmf-boxes}
    ┌───┐
    │0.4│ ┌───┐
    │   │ │0.3│ ┌───┐
    │   │ │   │ │0.2│ ┌───┐
    └───┘ └───┘ └───┘ └───┘
     x=0   x=1   x=2   x=3
     
    Total mass in all boxes = 1
```

**Continuous (PDF):** Like spreading material along a continuous shelf. The density tells you how thick the material is at each point. You find mass by computing area (thickness × width).

```{.figure #m02-pdf-area-12}
         ╭────────╮
        ╱          ╲
       ╱     ░░░░    ╲      ← Area of shaded region = P(1 ≤ X ≤ 2)
      ╱     ░░░░░░    ╲
    ─╱──────░░░░░░░░────╲──
          1      2

    Total area under curve = 1
```

**Cumulative (CDF):** Like a running total — how much material have you accumulated up to this point?

### Why This Matters in Engineering

**Example:** A noise voltage X has PDF f_X(x) = 2 for x ∈ [0, 0.5].

- f_X(0.3) = 2 — this is NOT a probability! It means the density is 2 V⁻¹.
- P(0.2 ≤ X ≤ 0.4) = ∫_{0.2}^{0.4} 2 dx = 2 × 0.2 = 0.4 — THIS is a probability.
- P(X = 0.3) = 0 — a single point has zero probability for continuous RVs.

### Common Errors to Avoid

| ❌ Wrong Statement | ✅ Correct Statement |
|---|---|
| "The probability at x=2 is f(2)" | "The probability density at x=2 is f(2)" |
| "f(x) must be ≤ 1" | "f(x) can be any non-negative value" |
| "P(X=3) = f(3) for continuous X" | "P(X=3) = 0 for continuous X" |
| "PMF and PDF are the same thing" | "PMF gives mass; PDF gives density" |

---

## 2.9 Transformations of Random Variables

### Motivation

In engineering, we often know the distribution of one quantity but need the distribution of a **function** of that quantity:

- Know voltage V → need power P = V²/R
- Know linear signal X → need dB value Y = 10·log₁₀(X)
- Know noise N → need |N| (rectified noise)

### Problem Statement

Given: X with known PDF f_X(x) or PMF p_X(x)
Find: The distribution of Y = g(X)

### Case 1: Discrete RV Transformation

If X is discrete with PMF p_X(x), and Y = g(X):

$$p_Y(y) = \sum_{x: g(x)=y} p_X(x)$$

Sum the probabilities of all x values that map to the same y.

**Example:** X ∈ {-2, -1, 0, 1, 2} with equal probability 0.2 each.
Y = X²

| Y = X² | X values mapping to Y | p_Y(y) |
|---------|----------------------|---------|
| 0 | {0} | 0.2 |
| 1 | {-1, 1} | 0.4 |
| 4 | {-2, 2} | 0.4 |

### Case 2: Monotonic Transformation (Continuous)

If Y = g(X) where g is strictly monotonic and differentiable:

$$f_Y(y) = f_X(g^{-1}(y)) \cdot \left|\frac{dg^{-1}(y)}{dy}\right|$$

Or equivalently:
$$f_Y(y) = \frac{f_X(x)}{|g'(x)|}\bigg|_{x=g^{-1}(y)}$$

**Derivation via CDF method:**
1. Start with CDF: F_Y(y) = P(Y ≤ y) = P(g(X) ≤ y)
2. Invert: = P(X ≤ g⁻¹(y)) if g is increasing
3. Differentiate: f_Y(y) = f_X(g⁻¹(y)) · d/dy[g⁻¹(y)]

### Case 3: Non-Monotonic Transformation

If g is not monotonic, split the domain into intervals where g IS monotonic:

$$f_Y(y) = \sum_i \frac{f_X(x_i)}{|g'(x_i)|}$$

where x₁, x₂, ... are all solutions of g(x) = y.

### Engineering Example: Power from Voltage

A noise voltage X has PDF f_X(x) (e.g., Gaussian with zero mean).
Power dissipated in a 1Ω resistor: P = X²

Since Y = X² is NOT monotonic (both +x and -x give the same y):

For y > 0: x = +√y and x = -√y are both solutions.
g(x) = x², so g'(x) = 2x

$$f_Y(y) = \frac{f_X(\sqrt{y})}{2\sqrt{y}} + \frac{f_X(-\sqrt{y})}{2\sqrt{y}}, \quad y > 0$$

If X is zero-mean Gaussian: f_X(x) = f_X(-x), so:
$$f_Y(y) = \frac{f_X(\sqrt{y})}{\sqrt{y}}, \quad y > 0$$

### Engineering Example: Linear Amplification

Signal Y = aX + b (amplifier with gain a and offset b).
X has PDF f_X(x).

g⁻¹(y) = (y-b)/a, and |d/dy[(y-b)/a]| = 1/|a|

$$f_Y(y) = \frac{1}{|a|} f_X\left(\frac{y-b}{a}\right)$$

---

## 2.10 MATLAB Examples

### Example 1: Plotting a PMF

```matlab
%% PMF of Number of Bit Errors in a Byte
n = 8;           % bits per byte
p = 0.1;         % bit error probability
k = 0:n;         % possible values

% Compute PMF (binomial distribution)
pmf = binopdf(k, n, p);

% Plot
figure;
stem(k, pmf, 'filled', 'LineWidth', 2);
xlabel('Number of Errors (k)');
ylabel('P(X = k)');
title('PMF: Bit Errors in 8-bit Byte (p = 0.1)');
grid on;

% Verify normalization
fprintf('Sum of PMF = %.6f (should be 1)\n', sum(pmf));
```

### Example 2: Plotting a PDF and Verifying Properties

```matlab
%% PDF of Gaussian Noise Voltage
sigma = 0.5;     % RMS noise voltage
x = linspace(-3*sigma, 3*sigma, 1000);

% Compute PDF
pdf_x = normpdf(x, 0, sigma);

% Plot
figure;
plot(x, pdf_x, 'b-', 'LineWidth', 2);
xlabel('Voltage (V)');
ylabel('f_X(x) [V^{-1}]');
title('PDF: Gaussian Noise (σ = 0.5 V)');
grid on;

% Verify normalization (numerical integration)
dx = x(2) - x(1);
total_area = trapz(x, pdf_x);
fprintf('Total area under PDF = %.6f (should be 1)\n', total_area);

% Note: PDF values can exceed 1!
fprintf('Maximum PDF value = %.4f (can be > 1!)\n', max(pdf_x));

% Compute P(|X| > 1V)
prob_exceed = 1 - normcdf(1, 0, sigma) + normcdf(-1, 0, sigma);
fprintf('P(|X| > 1V) = %.4f\n', prob_exceed);
```

### Example 3: CDF Visualization

```matlab
%% Comparing CDF for Discrete vs Continuous

figure;

% Subplot 1: Discrete CDF (Poisson, packets per second)
subplot(1,2,1);
lambda = 3;      % average arrivals per second
k = 0:10;
cdf_discrete = poisscdf(k, lambda);
stairs(k, cdf_discrete, 'r-', 'LineWidth', 2);
xlabel('Number of Packets');
ylabel('F_X(x) = P(X ≤ x)');
title('CDF: Discrete (Poisson, λ=3)');
grid on; ylim([0 1.1]);

% Subplot 2: Continuous CDF (Exponential, time to failure)
subplot(1,2,2);
mu = 5;          % mean time to failure (hours)
t = linspace(0, 20, 500);
cdf_continuous = expcdf(t, mu);
plot(t, cdf_continuous, 'b-', 'LineWidth', 2);
xlabel('Time (hours)');
ylabel('F_X(x) = P(X ≤ x)');
title('CDF: Continuous (Exponential, μ=5)');
grid on; ylim([0 1.1]);
```

### Example 4: Transformation of a Random Variable

```matlab
%% Transformation: Power from Noise Voltage
% X = noise voltage, Gaussian(0, sigma)
% Y = X^2 = instantaneous power (in 1-ohm load)

sigma = 1;
N = 100000;

% Generate Gaussian noise samples
X = sigma * randn(1, N);

% Transform: power = voltage^2
Y = X.^2;

% Plot empirical PDF of Y using histogram
figure;
subplot(2,1,1);
histogram(X, 100, 'Normalization', 'pdf');
hold on;
x_theory = linspace(-4, 4, 500);
plot(x_theory, normpdf(x_theory, 0, sigma), 'r-', 'LineWidth', 2);
xlabel('Voltage X'); ylabel('f_X(x)');
title('Input: Gaussian Noise Voltage');
legend('Empirical', 'Theoretical');

subplot(2,1,2);
histogram(Y, 100, 'Normalization', 'pdf');
hold on;
% Theoretical: Y ~ chi-squared with 1 degree of freedom
y_theory = linspace(0.01, 10, 500);
pdf_y_theory = chi2pdf(y_theory, 1);
plot(y_theory, pdf_y_theory, 'r-', 'LineWidth', 2);
xlabel('Power Y = X^2'); ylabel('f_Y(y)');
title('Output: Instantaneous Power');
legend('Empirical', 'Theoretical (χ²₁)');
```

### Example 5: PMF vs PDF vs CDF Comparison

```matlab
%% Complete Visualization: PMF/PDF and CDF side by side
figure;

% --- Discrete Case: Number of retransmissions ---
% Geometric distribution: number of trials until first success
p_success = 0.3;   % success probability per trial
k = 1:15;

% PMF
subplot(2,2,1);
pmf_geom = geopdf(k-1, p_success);  % MATLAB's geopdf counts failures
stem(k, pmf_geom, 'filled', 'LineWidth', 1.5);
xlabel('k (transmissions)'); ylabel('P(X = k)');
title('Discrete PMF: Retransmissions');
grid on;

% CDF
subplot(2,2,2);
cdf_geom = geocdf(k-1, p_success);
stairs(k, cdf_geom, 'LineWidth', 2);
xlabel('k'); ylabel('P(X ≤ k)');
title('Discrete CDF');
grid on; ylim([0 1.1]);

% --- Continuous Case: Delay time ---
% Exponential distribution
mu = 2;  % mean delay in ms
t = linspace(0, 10, 500);

% PDF
subplot(2,2,3);
pdf_exp = exppdf(t, mu);
plot(t, pdf_exp, 'LineWidth', 2);
xlabel('Delay (ms)'); ylabel('f_X(x) [ms^{-1}]');
title('Continuous PDF: Delay');
grid on;

% CDF
subplot(2,2,4);
cdf_exp = expcdf(t, mu);
plot(t, cdf_exp, 'LineWidth', 2);
xlabel('Delay (ms)'); ylabel('P(X ≤ x)');
title('Continuous CDF');
grid on; ylim([0 1.1]);

sgtitle('PMF/PDF vs CDF: Discrete and Continuous', 'FontSize', 14);
```

---

## 2.11 Practice Problems

### Problem 1: Identifying RV Type
Classify each as discrete or continuous and state the range:
(a) Number of dropped calls in one hour
(b) Received signal strength (dBm)
(c) Number of bits in error in a 1500-byte Ethernet frame
(d) Time between packet arrivals
(e) Quantizer output level (3-bit quantizer)

**Solution:**
(a) Discrete, X ∈ {0, 1, 2, ...}
(b) Continuous, X ∈ (-∞, ∞) practically ~ (-120, 0) dBm
(c) Discrete, X ∈ {0, 1, 2, ..., 12000}
(d) Continuous, T ∈ [0, ∞)
(e) Discrete, X ∈ {0, 1, 2, 3, 4, 5, 6, 7}

---

### Problem 2: PMF Properties
A random variable X has PMF: p_X(0) = 0.1, p_X(1) = 0.3, p_X(2) = c, p_X(3) = 0.2.

(a) Find c.
(b) Find P(X ≥ 2).
(c) Find F_X(1.5).
(d) Find P(0.5 < X ≤ 2.5).

**Solution:**
(a) Sum = 1: 0.1 + 0.3 + c + 0.2 = 1 → c = 0.4

(b) P(X ≥ 2) = p_X(2) + p_X(3) = 0.4 + 0.2 = 0.6

(c) F_X(1.5) = P(X ≤ 1.5) = p_X(0) + p_X(1) = 0.1 + 0.3 = 0.4

(d) P(0.5 < X ≤ 2.5) = p_X(1) + p_X(2) = 0.3 + 0.4 = 0.7

---

### Problem 3: PDF and CDF
A random variable has PDF:
f_X(x) = cx for 0 ≤ x ≤ 4, and 0 otherwise.

(a) Find c.
(b) Find the CDF F_X(x).
(c) Find P(1 ≤ X ≤ 3).
(d) Find the value x₀ such that P(X ≤ x₀) = 0.5.

**Solution:**
(a) ∫₀⁴ cx dx = c·[x²/2]₀⁴ = c·8 = 1 → c = 1/8

(b) F_X(x) = ∫₀ˣ (t/8)dt = x²/16, for 0 ≤ x ≤ 4
    F_X(x) = 0 for x < 0; F_X(x) = 1 for x > 4

(c) P(1 ≤ X ≤ 3) = F_X(3) - F_X(1) = 9/16 - 1/16 = 8/16 = 0.5

(d) x₀²/16 = 0.5 → x₀² = 8 → x₀ = 2√2 ≈ 2.83

---

### Problem 4: Transformation
A sensor measures temperature X uniformly distributed on [20, 30] °C.
The output voltage is Y = 0.1X - 2 (linear sensor).

(a) Find the PDF of Y.
(b) Find the range of Y.
(c) Find P(Y > 0.5).

**Solution:**
(a) X ~ Uniform[20, 30], so f_X(x) = 1/10 for 20 ≤ x ≤ 30.
Y = 0.1X - 2, so a = 0.1, b = -2.
f_Y(y) = (1/|a|) · f_X((y-b)/a) = (1/0.1) · (1/10) = 1 for the valid range.

(b) When X = 20: Y = 0.1(20) - 2 = 0; When X = 30: Y = 0.1(30) - 2 = 1
Range of Y: [0, 1]. So Y ~ Uniform[0, 1].

(c) P(Y > 0.5) = 1 - F_Y(0.5) = 1 - 0.5 = 0.5

---

### Problem 5: Non-Monotonic Transformation
A voltage X ~ Uniform[-1, 1] V. The instantaneous power is Y = X².

(a) Find the CDF of Y.
(b) Find the PDF of Y.
(c) Verify using MATLAB simulation.

**Solution:**
(a) For 0 ≤ y ≤ 1:
F_Y(y) = P(X² ≤ y) = P(-√y ≤ X ≤ √y) = F_X(√y) - F_X(-√y)

Since X ~ Uniform[-1,1]: F_X(x) = (x+1)/2

F_Y(y) = (√y + 1)/2 - (-√y + 1)/2 = √y

(b) f_Y(y) = dF_Y/dy = 1/(2√y) for 0 < y ≤ 1

(c) MATLAB:
```matlab
N = 100000;
X = 2*rand(1,N) - 1;   % Uniform[-1,1]
Y = X.^2;
histogram(Y, 100, 'Normalization', 'pdf');
hold on;
y = linspace(0.01, 1, 200);
plot(y, 1./(2*sqrt(y)), 'r-', 'LineWidth', 2);
legend('Empirical', 'Theory: 1/(2√y)');
xlabel('Y = X²'); ylabel('f_Y(y)');
```

---

## 2.12 Key Takeaways

1. **Random variables** convert experimental outcomes into numbers for mathematical analysis
2. **PMF** gives the actual probability for discrete RVs (bar heights sum to 1)
3. **PDF** gives probability density for continuous RVs (area gives probability, not height)
4. **CDF** works universally — gives cumulative probability P(X ≤ x)
5. **Transformations** let us derive distributions of functions of random variables
6. The **CDF method** (find CDF first, then differentiate) is often the safest approach for transformations

---

*Next Module: [Module 3 — Important Probability Distributions](module03-important-distributions.md)*
