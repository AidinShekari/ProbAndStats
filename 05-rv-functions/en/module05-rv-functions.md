# Module 5 — Important Random-Variable Functions

## Learning Objectives

After completing this module, students will be able to:
1. Apply linear transformations to random variables
2. Derive PDFs of nonlinear transformations using the CDF and Jacobian methods
3. Apply transformations to engineering problems (power, SNR, envelope)
4. Verify analytical results with worked examples

---

## 5.1 Introduction: Why Transform Random Variables?

In engineering, we often know the statistics of one quantity but need the statistics of a **derived** quantity:

| Known | Needed | Transformation |
|-------|--------|---------------|
| Voltage $V$ | Power $P$ | $P = \frac{V^{2}}{R}$ |
| Linear SNR | SNR in dB | $Y = 10 \cdot \log_{10}(X)$ |
| Gaussian I, $Q$ | Envelope | $R = \sqrt{I^{2} + Q^{2}}$ |
| Current I | Power | $P = I^{2}R$ |
| Distance $d$ | Path loss | $L = d^{\alpha}$ |

---

## 5.2 Linear Transformations: $Y$ = aX $+ b$

### Result

If $X$ has PDF $f_{X}(x)$, then $Y$ = aX $+ b$ has:

$$f_Y(y) = \frac{1}{|a|} f_X\left(\frac{y-b}{a}\right)$$

### Mean and Variance

- $E[Y]$ = aE[X] $+ b$
- $\operatorname{Var}(Y) = a^{2}\operatorname{Var}(X)$

### Engineering Example: Amplifier

Input signal $X \sim N(0,\, \sigma^{2})$ passes through amplifier with gain $G = 10$ and DC offset $V_{0} = 1.5\,\mathrm{V}$.

Output: $Y = 10X + 1.5$

- $Y \sim N(10 \cdot 0 + 1.5,\, 10^{2} \cdot \sigma^{2}) = N(1.5,\, 100\sigma^{2})$
- Output noise power increased by $G^{2} = 100$

### Engineering Example: Temperature Sensor

Sensor output $V = 0.01 \cdot T + 0.5$ (V in volts, $T$ in °C)

If $T \sim N(25,\, 4)$: $V \sim N(0.01 \times 25 + 0.5,\, 0.01^{2} \times 4) = N(0.75,\, 0.0004)$

---

## 5.3 General Monotonic Transformations

### CDF Method (Most General)

For $Y = g(X)$, find $f_{Y}(y)$ by:

1. Write $F_{Y}(y) = P(Y \le y) = P(g(X) \le y)$
2. Solve the inequality for $X$
3. Express in terms of $F_{X}$
4. Differentiate to get $f_{Y}(y)$

### Formula for Monotonic $g$

If $g$ is strictly increasing with inverse $g^{-1}$:
$$f_Y(y) = f_X(g^{-1}(y)) \cdot \frac{d}{dy}[g^{-1}(y)]$$

If $g$ is strictly decreasing:
$$f_Y(y) = f_X(g^{-1}(y)) \cdot \left|\frac{d}{dy}[g^{-1}(y)]\right|$$

Combined (works for both):
$$f_Y(y) = \frac{f_X(x)}{|g'(x)|}\bigg|_{x=g^{-1}(y)}$$

### Engineering Example: SNR in dB

Linear SNR: $X \sim \mathrm{Exponential}(1)$ (normalized Rayleigh fading power).
dB SNR: $Y = 10 \cdot \log_{10}(X)$

- $g(x) = 10 \cdot \log_{10}(x),\, g'(x) = \frac{10}{x \cdot \ln 10}$
- $g^{-1}(y) = 10^{y/10}$

$$f_Y(y) = \frac{f_X(10^{y/10})}{10/(10^{y/10} \cdot \ln 10)} = \frac{\ln 10}{10} \cdot 10^{y/10} \cdot e^{-10^{y/10}}$$

This is NOT Gaussian — it has a longer left tail (deep fades).

---

## 5.4 Nonlinear Transformations: Non-Monotonic Case

### When $Y = g(X)$ is Not One-to-One

If multiple x-values map to the same $y$, sum over all solutions:

$$f_Y(y) = \sum_{i} \frac{f_X(x_i)}{|g'(x_i)|}$$

where $x_{1},\, x_{2}$, ... are all roots of $g(x) = y$.

### Engineering Example: Power from Voltage $(Y = X^{2})$

Voltage $X \sim N(0,\, \sigma^{2})$. Power: $Y = X^{2}$.

For $y > 0$, solutions are $x = +\sqrt{y}$ and $x = -\sqrt{y}$. $g'(x) = 2x$.

$$f_Y(y) = \frac{f_X(\sqrt{y})}{2\sqrt{y}} + \frac{f_X(-\sqrt{y})}{2\sqrt{y}} = \frac{1}{\sqrt{2\pi}\sigma} \cdot \frac{e^{-y/(2\sigma^2)}}{\sqrt{y}}$$

This is a **Chi-squared distribution with 1 degree of freedom** (scaled by $\sigma^{2}$).

### Engineering Example: Full-Wave Rectifier $(Y = \lvert X\rvert)$

Input $X \sim N(0,\, \sigma^{2})$. Output $Y = \lvert X\rvert$.

For $y > 0$: $x = +y$ and $x = -y$ are solutions. $\lvert g'(x)\rvert = 1$.

$$f_Y(y) = f_X(y) + f_X(-y) = \frac{2}{\sigma\sqrt{2\pi}} e^{-y^2/(2\sigma^2)}, \quad y \geq 0$$

This is the **folded normal** (half-normal) distribution.

---

## 5.5 The Jacobian Method

### Procedure for $Y = g(X)$

1. Identify the transformation $y = g(x)$
2. Find the inverse: $x = g^{-1}(y)$
3. Compute the Jacobian: $J = \lvert \frac{dx}{dy}\rvert = \lvert \frac{d[g^{-1}(y)]}{dy}\rvert$
4. Apply: $f_{Y}(y) = f_{X}(g^{-1}(y)) \cdot \lvert J\rvert$

### Step-by-Step Example: Exponential of Gaussian

$X \sim N(\mu,\, \sigma^{2})$. $Y = e^{x}$ (log-normal transformation).

1. $g(x) = e^{x}$ (monotonically increasing)
2. $x = \ln (y)$, valid for $y > 0$
3. $J = \lvert \frac{dx}{dy}\rvert = \frac{1}{y}$
4. $f_{Y}(y) = f_{X}(\ln y) \cdot \frac{1}{y} = \frac{1}{y\sigma \sqrt{2\pi}} \cdot \exp \left(-\frac{(\ln y - \mu)^{2}}{2\sigma^{2}}\right)$

This is the **log-normal distribution** — models many engineering quantities (shadowing in wireless, stock prices, component lifetimes with wear).

---

## 5.6 Engineering Application: Rayleigh from Gaussian

### Derivation of Rayleigh Distribution

In communications, the received signal has in-phase $(I)$ and quadrature $(Q)$ components:
- $I \sim N(0,\, \sigma^{2}),\, Q \sim N(0,\, \sigma^{2})$, independent

Envelope: $R = \sqrt{I^{2} + Q^{2}}$

Using the transformation from $(I,\, Q) \to (R,\, \theta)$ with polar coordinates:
- $I = R \cdot \cos (\theta),\, Q = R \cdot \sin (\theta)$
- Jacobian: $\lvert \frac{\partial (I,\,Q)}{\partial (R,\,\theta)}\rvert = R$

Joint PDF of $(R,\, \theta)$:
$f_{R,\Theta}(r,\,\theta) = f_{I,Q}(r \cdot \cos \theta,\, r \cdot \sin \theta) \cdot r = \frac{r}{2\pi \sigma^{2}} \cdot e^{-r^{2}/(2\sigma^{2})}$

Marginalizing over $\theta \in [0,\, 2\pi)$:

$$f_R(r) = \frac{r}{\sigma^2} e^{-r^2/(2\sigma^2)}, \quad r \geq 0$$

This is the **Rayleigh distribution** — fundamental to wireless fading channel modeling.

---

## 5.7 Practice Problems

### Problem 1
Signal $X \sim \mathrm{Uniform}[0,\, 1]$. Output $Y = -2 \cdot \ln (X)$. Find the PDF of $Y$ and identify the distribution.

**Solution:** CDF method: $F_{Y}(y) = P(-2\ln (X) \le y) = P(X \ge e^{-y/2}) = 1 - e^{-y/2}$ for $y \ge 0$.
$f_{Y}(y) = \frac{1}{2}e^{-y/2} \to Y \sim \mathrm{Exponential}(\beta = 2)$. (This is the inverse CDF method for generating exponentials!)

### Problem 2
Noise voltage $X \sim N(0,\, \sigma^{2})$ with $\sigma = 2\,\mathrm{V}$. Power dissipated in $R = 50\,\Omega$: $P = \frac{X^{2}}{R}$.
(a) Find $E[P]$. (b) Find the PDF of $P$. (c) Find $P(P > 0.2\,\mathrm{W})$.

**Solution:**
(a) $E[P] = \frac{E[X^{2}]}{R} = \frac{\sigma^{2}}{R} = \frac{4}{50} = 0.08\,\mathrm{W}$
(b) $P = \frac{X^{2}}{50}$. Let $W = X^{2} \sim \sigma^{2} \cdot \chi^{2}(1)$. Then $P = \frac{W}{50}$. $f_{P}(p) = 50 \cdot f_{W}(50p) = \frac{50}{2\sigma^{2}} \cdot \frac{50p}{\sigma^{2}}^{-1/2} \cdot e^{-50p/(2\sigma^{2})}$ for $p > 0$.
(c) $P(P > 0.2) = P(\chi^2_1 > 2.5) = 1 - F_{\chi^2_1}(2.5) \approx 0.114$

### Problem 3
$X \sim \mathrm{Exponential}(\lambda = 1)$. $Y = \sqrt{X}$. Find $f_{Y}(y)$.

**Solution:** $g(x) = \sqrt{x} \to x = y^{2},\, \frac{dx}{dy} = 2y$.
$f_{Y}(y) = f_{X}(y^{2}) \cdot \lvert 2y\rvert = e^{-y^{2}} \cdot 2y$ for $y \ge 0$. This is a Rayleigh distribution with $\sigma^{2} = \frac{1}{2}$.

### Problem 4
Distance $D \sim \mathrm{Uniform}[1,\, 10]$ km. Path loss: $L = 20 \cdot \log_{10}(D)$ dB. Find $E[L]$ and the PDF of $L$.

**Solution:** $E[L] = E[20 \cdot \log_{10}(D)] = \int_{1}^{10} 20 \cdot \log_{10}(d) \cdot \frac{1}{9}\,dd = \frac{20}{9} \cdot \int_{1}^{10} \log_{10}(d)\,dd$
$= \frac{20}{9} \cdot \left[d \cdot \log_{10}(d) - \frac{d}{\ln (10)}\right]_{1}^{10} = \frac{20}{9} \cdot \left[10 - \frac{10}{\ln 10} + \frac{1}{\ln 10}\right] = \frac{20}{9} \cdot \left(10 - \frac{9}{\ln 10}\right) \approx 13.55$ dB

PDF: $L$ ranges from 0 to 20 dB. $g^{-1}(l) = 10^{l/20},\, \lvert \frac{dg^{-1}}{dl}\rvert = \frac{\ln 10}{20} \cdot 10^{l/20}$.
$f_{L}(l) = \frac{1}{9} \cdot \frac{\ln 10}{20} \cdot 10^{l/20}$ for $0 \le l \le 20$.

---

*Next Module: [Module 6 — Two Random Variables](module06-two-random-variables.md)*
