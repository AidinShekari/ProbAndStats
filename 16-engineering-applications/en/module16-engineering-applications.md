# Module 16 — Engineering Statistical Applications

## Learning Objectives

This capstone module integrates ALL previous modules into real Electrical Engineering applications. Students will be able to:
1. Apply probabilistic modeling to communication systems
2. Analyze signal processing problems statistically
3. Model electronic component variations
4. Assess power system reliability
5. Handle measurement uncertainty in control systems
6. Connect probability/statistics to machine learning foundations

---

## 16.1 Communications

### 16.1.1 BER Estimation and Confidence Intervals

**Problem:** Estimate the Bit Error Rate of a communication link.

**Model:** Each bit is a Bernoulli trial with error probability $p$ (the BER).
- $n$ bits transmitted, $k$ errors observed
- $\hat{p} = \frac{k}{n}$ (MLE of BER)
- 95% CI: $\hat{p} \pm 1.96\sqrt{\frac{\hat{p}(1-\hat{p})}{n}}$

### 16.1.2 AWGN Noise Modeling

Additive White Gaussian Noise is the fundamental noise model:
- **Distribution:** $N\left(0,\, \frac{N_{0}}{2}\right)$ per dimension
- **Why Gaussian?** CLT — thermal noise is sum of many electron contributions
- **Characterization:** Fully described by power spectral density $N_{0}$ or variance $\sigma^{2} = N_{0}B$ (B = bandwidth)

### 16.1.3 Rayleigh Fading Channel

**Model:** Channel coefficient $h = h_{I} + j \cdot h_{Q}$ where $h_{I},\, h_{Q} \sim N(0,\, \sigma^{2})$ independent.

- Envelope $\lvert h\rvert \sim \mathrm{Rayleigh}(\sigma)$
- Power $\lvert h\rvert^{2} \sim \mathrm{Exponential}\left(\frac{1}{2\sigma^{2}}\right)$
- **Outage probability:** $P(\lvert h\rvert^{2} < \gamma_{\mathrm{th}}) = 1 - \exp \left(-\frac{\gamma_{\mathrm{th}}}{2\sigma^{2}}\right)$

### 16.1.4 Rician Fading

When a line-of-sight (LOS) component exists:
- $h = h_{\mathrm{LOS}} + h_{\mathrm{scatter}}$
- $\lvert h\rvert \sim \mathrm{Rician}(\nu,\, \sigma)$ where $K = \frac{\nu^{2}}{2\sigma^{2}}$ is the K-factor

K-factor: $K = 0$ (Rayleigh) $\to K = \infty$ (no fading, AWGN)

### 16.1.5 SNR Statistics

**Instantaneous SNR:** $\gamma = \lvert h\rvert^{2} \times \frac{E_{s}}{N_{0}}$

For Rayleigh: $\gamma \sim \mathrm{Exponential}(\bar{\gamma})$ where $\bar{\gamma}$ = average SNR

**Average BER over fading:**
$$\bar{P}_e = \int_0^\infty P_e(\gamma) \cdot f_\gamma(\gamma) \, d\gamma$$

For BPSK over Rayleigh: $\bar{P}_{e} = \frac{1}{2}\left(1 - \sqrt{\frac{\bar{\gamma}}{1+\bar{\gamma}}}\right)$

---

## 16.2 Signal Processing

### 16.2.1 Measurement Noise Characterization

**Problem:** Characterize noise in measured signal $x(t) = s(t) + n(t)$.

**Approach:**
1. Collect noise-only samples (signal absent)
2. Estimate noise statistics: $\hat{\mu}_{n},\, \hat{\sigma}^{2}_{n}$
3. Test for Gaussianity (histogram, QQ-plot)
4. Compute SNR: $\mathrm{SNR} = \frac{P_{\mathrm{signal}}}{\hat{\sigma}^{2}_{n}}$

### 16.2.2 Correlation-Based Detection

**Problem:** Detect a known signal in noise.

**Method:** Correlate received signal with known template. Under $H_{0}$ (noise only), the correlator output has known distribution → set threshold.

---

## 16.3 Electronics

### 16.3.1 Component Tolerance Modeling

**Problem:** Resistors have nominal value $R_{0}$ with manufacturing tolerance.

**Model:** $R \sim N(R_{0},\, \sigma_{R}^{2})$ where $\sigma_{R}$ depends on tolerance class.

For $\pm 5\%$ tolerance (99.7% within bounds): $3\sigma = 0.05R_{0} \to \sigma = 0.0167R_{0}$

### 16.3.2 Monte Carlo Circuit Analysis

**Problem:** A voltage divider uses $R_{1}$ and $R_{2}$. What is the distribution of output voltage?

$V_{\mathrm{out}} = V_{\mathrm{in}} \times \frac{R_{2}}{R_{1} + R_{2}}$

With $R_{1},\, R_{2}$ random: $V_{\mathrm{out}}$ is a random variable!

### 16.3.3 Measurement Uncertainty Propagation

If $Z = f(X,\, Y)$ and $X,\, Y$ have small uncertainties:

$$\sigma_Z^2 \approx \left(\frac{\partial f}{\partial X}\right)^2 \sigma_X^2 + \left(\frac{\partial f}{\partial Y}\right)^2 \sigma_Y^2$$

**Example:** Power $P = \frac{V^{2}}{R}$. $\sigma_{P}^{2} \approx \frac{2\,\mathrm{V}}{R}^{2}\sigma_{V}^{2} + \frac{V^{2}}{R^{2}}^{2}\sigma_{R}^{2}$

---

## 16.4 Power Systems

### 16.4.1 Load Uncertainty

**Problem:** Peak load is uncertain. Model: $L \sim N(\mu_{L},\, \sigma_{L}^{2})$

Design question: What capacity $C$ ensures $P(\text{load} > \text{capacity}) < 0.01$?

$C = \mu_{L} + 2.326\sigma_{L}$ (for 1% exceedance probability)

### 16.4.2 System Reliability

**Series system:** All components must work.

$R_{\mathrm{sys}} = R_{1} \times R_{2} \times \ldots \times R_{n}$ (for independent components)

**Parallel system:** At least one must work.

$R_{\mathrm{sys}} = 1 - (1-R_{1})(1-R_{2})\ldots (1-R_{n})$

---

## 16.5 Control Systems

### 16.5.1 Sensor Noise Effects

**Problem:** A control system uses noisy sensor readings.

Measurement: $y(k) = x(k) + n(k)$ where $n \sim N(0,\, \sigma^{2}_{n})$

Controller acts on $y(k)$ → tracking error includes noise contribution.

**Solution approaches:**
- Averaging (low-pass filter): reduces noise by $\sqrt{n}$
- Kalman filter: optimal fusion of model prediction and measurement

### 16.5.2 Parameter Uncertainty

System model: $G(s) = \frac{K}{\tau s + 1}$ where $K$ and $\tau$ are uncertain.

Monte Carlo approach: sample $K$ and $\tau$ from their distributions, simulate system response many times, compute statistics of output.

---

## 16.6 Machine Learning / AI Connections

### 16.6.1 Sampling and Data Collection

- Training data = sample from population
- Test data = independent sample for validation
- i.i.d. assumption underlies most ML theory

### 16.6.2 Estimation as Foundation of ML

- Linear regression = MLE under Gaussian noise assumption
- Neural network training = MLE (or MAP) for model parameters
- Loss function minimization = maximum likelihood principle

### 16.6.3 Probability Distributions in ML

- Generative models: learn $P(X)$ directly
- Gaussian Mixture Models: weighted sum of Gaussians
- Variational Autoencoders: latent variables with Gaussian priors

### 16.6.4 Bias-Variance Tradeoff

$$\text{Test Error} = \text{Bias}^2 + \text{Variance} + \text{Irreducible Noise}$$

This is exactly the MSE decomposition from estimation theory (Module 13)!

- High bias: underfitting (too simple model)
- High variance: overfitting (too complex model)
- Optimal: balance between the two

### 16.6.5 Confidence and Uncertainty in Predictions

- Confidence intervals for model predictions
- Bayesian neural networks: posterior over weights → prediction uncertainty
- Calibration: predicted probabilities should match observed frequencies

---

## 16.7 Key Integration Points

| Module | Application in EE |
|--------|------------------|
| 1. Probability | Event probabilities, fault diagnosis |
| 2. Random Variables | Modeling uncertain quantities |
| 3. Distributions | Choosing noise/fading/failure models |
| 4. Moments | Signal power, noise power, SNR |
| 5. Transformations | dB conversion, power from voltage |
| $6-7$. Joint/Functions | Signal+noise, system combinations |
| 8. Conditional | Performance under different states |
| 9. Correlation | MIMO channels, sensor arrays |
| 10. Multiple RVs | Vector processing, beamforming |
| 11. CLT | Why noise is Gaussian, averaging |
| 12. Statistics | Estimating system parameters |
| 13. Estimation | MLE for channel/noise parameters |
| 14. Confidence | Quantifying measurement uncertainty |
| 15. Hypothesis | Quality control, performance comparison |

---

*End of course modules. The modules conclude with engineering applications and a summary of key concepts.*
