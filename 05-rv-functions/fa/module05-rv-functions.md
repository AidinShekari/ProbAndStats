<!-- TRANSLATION START -->
# ماژول 5 — توابع مهم متغیر تصادفی

## اهداف یادگیری

پس از تکمیل این ماژول، دانشجویان قادر خواهند بود:
1. تبدیل‌های خطی را روی متغیرهای تصادفی اعمال کنند
2. PDF تبدیل‌های غیرخطی را با روش‌های CDF و ژاکوبی استخراج کنند
3. تبدیل‌ها را در مسائل مهندسی (توان، SNR، پوش) به کار ببرند
4. نتایج تحلیلی را با شبیه‌سازی MATLAB بررسی کنند

---

## 5.1 مقدمه: چرا متغیرهای تصادفی را تبدیل کنیم؟

در مهندسی، اغلب آماره‌های یک کمیت را می‌دانیم اما به آماره‌های یک کمیت **مشتق‌شده** نیاز داریم:

| معلوم | موردنیاز | تبدیل |
|-------|--------|---------------|
| ولتاژ V | توان P | P = V²/R |
| SNR خطی | SNR بر حسب dB | Y = 10·log₁₀(X) |
| گاوسی I، Q | پوش | R = √(I² + Q²) |
| جریان I | توان | P = I²R |
| فاصله d | تلفات مسیر | L = d^α |

---

## 5.2 تبدیل‌های خطی: Y = aX + b

### نتیجه

اگر X دارای PDF f_X(x) باشد، آنگاه Y = aX + b دارای:

$$f_Y(y) = \frac{1}{|a|} f_X\left(\frac{y-b}{a}\right)$$

### میانگین و واریانس

- E[Y] = aE[X] + b
- Var(Y) = a²Var(X)

### مثال مهندسی: تقویت‌کننده

سیگنال ورودی X ~ N(0, σ²) از تقویت‌کننده‌ای با بهره G = 10 و آفست DC یعنی V₀ = 1.5V می‌گذرد.

خروجی: Y = 10X + 1.5

- Y ~ N(10·0 + 1.5, 10²·σ²) = N(1.5, 100σ²)
- توان نویز خروجی به اندازه G² = 100 افزایش یافته است

### مثال مهندسی: حسگر دما

خروجی حسگر V = 0.01·T + 0.5 (V بر حسب ولت، T بر حسب °C)

اگر T ~ N(25, 4): V ~ N(0.01×25 + 0.5, 0.01²×4) = N(0.75, 0.0004)

---

## 5.3 تبدیل‌های یکنوای عمومی

### روش CDF (کلی‌ترین روش)

برای Y = g(X)، f_Y(y) را به این ترتیب بیابید:

1. بنویسید F_Y(y) = P(Y ≤ y) = P(g(X) ≤ y)
2. نامساوی را برای X حل کنید
3. بر حسب F_X بیان کنید
4. مشتق بگیرید تا f_Y(y) به دست آید

### فرمول برای g یکنوا

اگر g اکیداً صعودی با وارون g⁻¹ باشد:
$$f_Y(y) = f_X(g^{-1}(y)) \cdot \frac{d}{dy}[g^{-1}(y)]$$

اگر g اکیداً نزولی باشد:
$$f_Y(y) = f_X(g^{-1}(y)) \cdot \left|\frac{d}{dy}[g^{-1}(y)]\right|$$

ترکیبی (برای هر دو کار می‌کند):
$$f_Y(y) = \frac{f_X(x)}{|g'(x)|}\bigg|_{x=g^{-1}(y)}$$

### مثال مهندسی: SNR بر حسب dB

SNR خطی: X ~ Exponential(1) (توان محوشدگی رایلی نرمال‌شده).
SNR بر حسب dB: Y = 10·log₁₀(X)

- g(x) = 10·log₁₀(x)، g'(x) = 10/(x·ln10)
- g⁻¹(y) = 10^(y/10)

$$f_Y(y) = \frac{f_X(10^{y/10})}{10/(10^{y/10} \cdot \ln 10)} = \frac{\ln 10}{10} \cdot 10^{y/10} \cdot e^{-10^{y/10}}$$

این توزیع گاوسی نیست — دنباله چپ بلندتری دارد (فروافت‌های عمیق).

---

## 5.4 تبدیل‌های غیرخطی: حالت غیریکنوا

### هنگامی که Y = g(X) یک‌به‌یک نیست

اگر چند مقدار x به همان y نگاشت شوند، روی تمام جواب‌ها جمع کنید:

$$f_Y(y) = \sum_{i} \frac{f_X(x_i)}{|g'(x_i)|}$$

که در آن x₁, x₂, ... تمام ریشه‌های g(x) = y هستند.

### مثال مهندسی: توان از ولتاژ (Y = X²)

ولتاژ X ~ N(0, σ²). توان: Y = X².

برای y > 0، جواب‌ها x = +√y و x = -√y هستند. g'(x) = 2x.

$$f_Y(y) = \frac{f_X(\sqrt{y})}{2\sqrt{y}} + \frac{f_X(-\sqrt{y})}{2\sqrt{y}} = \frac{1}{\sqrt{2\pi}\sigma} \cdot \frac{e^{-y/(2\sigma^2)}}{\sqrt{y}}$$

این یک **توزیع کای‌دو با 1 درجه آزادی** است (مقیاس‌شده با σ²).

### مثال مهندسی: یکسوساز تمام‌موج (Y = |X|)

ورودی X ~ N(0, σ²). خروجی Y = |X|.

برای y > 0: x = +y و x = -y جواب هستند. |g'(x)| = 1.

$$f_Y(y) = f_X(y) + f_X(-y) = \frac{2}{\sigma\sqrt{2\pi}} e^{-y^2/(2\sigma^2)}, \quad y \geq 0$$

این توزیع **نرمال تاشده** (نیم‌نرمال) است.

---

## 5.5 روش ژاکوبی

### رویه برای Y = g(X)

1. تبدیل y = g(x) را مشخص کنید
2. وارون را بیابید: x = g⁻¹(y)
3. ژاکوبی را محاسبه کنید: J = |dx/dy| = |d[g⁻¹(y)]/dy|
4. اعمال کنید: f_Y(y) = f_X(g⁻¹(y)) · |J|

### مثال گام‌به‌گام: نمایی گاوسی

X ~ N(μ, σ²). Y = eˣ (تبدیل لگ‌نرمال).

1. g(x) = eˣ (یکنوای صعودی)
2. x = ln(y)، معتبر برای y > 0
3. J = |dx/dy| = 1/y
4. f_Y(y) = f_X(ln y) · (1/y) = (1/(yσ√(2π))) · exp(-(ln y - μ)²/(2σ²))

این همان **توزیع لگ‌نرمال** است — بسیاری از کمیت‌های مهندسی را مدل می‌کند (سایه‌اندازی در بی‌سیم، قیمت سهام، عمر قطعات همراه با فرسودگی).

---

## 5.6 کاربرد مهندسی: رایلی از گاوسی

### استخراج توزیع رایلی

در مخابرات، سیگنال دریافتی مؤلفه‌های هم‌فاز (I) و مربعی (Q) دارد:
- I ~ N(0, σ²)، Q ~ N(0, σ²)، مستقل

پوش: R = √(I² + Q²)

با استفاده از تبدیل (I, Q) → (R, θ) در مختصات قطبی:
- I = R·cos(θ)، Q = R·sin(θ)
- ژاکوبی: |∂(I,Q)/∂(R,θ)| = R

PDF مشترک (R, θ):
f_{R,Θ}(r,θ) = f_{I,Q}(r·cosθ, r·sinθ) · r = (r/(2πσ²)) · e^(-r²/(2σ²))

حاشیه‌سازی روی θ ∈ [0, 2π):

$$f_R(r) = \frac{r}{\sigma^2} e^{-r^2/(2\sigma^2)}, \quad r \geq 0$$

این همان **توزیع رایلی** است — بنیادی برای مدل‌سازی کانال محوشدگی بی‌سیم.

---

## 5.7 مثال‌های MATLAB

### مثال 1: بررسی تبدیل خطی

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

### مثال 2: توان از ولتاژ گاوسی

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

### مثال 3: SNR بر حسب dB از SNR خطی

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

### مثال 4: پوش رایلی از مؤلفه‌های گاوسی

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

### مثال 5: لگ‌نرمال از گاوسی

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

## 5.8 مسائل تمرینی

### مسئله 1
سیگنال X ~ Uniform[0, 1]. خروجی Y = -2·ln(X). PDF مربوط به Y را بیابید و توزیع را تشخیص دهید.

**حل:** روش CDF: F_Y(y) = P(-2ln(X) ≤ y) = P(X ≥ e^(-y/2)) = 1 - e^(-y/2) برای y ≥ 0.
f_Y(y) = (1/2)e^(-y/2) → Y ~ Exponential(β = 2). (این همان روش CDF وارون برای تولید توزیع نمایی است!)

### مسئله 2
ولتاژ نویز X ~ N(0, σ²) با σ = 2V. توان تلف‌شده در R = 50Ω: P = X²/R.
(a) E[P] را بیابید. (ب) PDF مربوط به P را بیابید. (ج) P(P > 0.2W) را بیابید.

**حل:**
(a) E[P] = E[X²]/R = σ²/R = 4/50 = 0.08W
(b) P = X²/50. فرض کنید W = X² ~ σ²·χ²(1). آنگاه P = W/50. f_P(p) = 50·f_W(50p) = (50/(2σ²))·(50p/σ²)^(-1/2)·e^(-50p/(2σ²)) برای p > 0.
(c) از MATLAB استفاده کنید: `1 - chi2cdf(0.2*50/4, 1)` = 1 - chi2cdf(2.5, 1) ≈ 0.114

### مسئله 3
X ~ Exponential(λ = 1). Y = √X. مقدار f_Y(y) را بیابید.

**حل:** g(x) = √x → x = y²، dx/dy = 2y.
f_Y(y) = f_X(y²)·|2y| = e^(-y²)·2y برای y ≥ 0. این یک توزیع رایلی با σ² = 1/2 است.

### مسئله 4
فاصله D ~ Uniform[1, 10] km. تلفات مسیر: L = 20·log₁₀(D) dB. مقدار E[L] و PDF مربوط به L را بیابید.

**حل:** E[L] = E[20·log₁₀(D)] = ∫₁¹⁰ 20·log₁₀(d)·(1/9) dd = (20/9)·∫₁¹⁰ log₁₀(d) dd
= (20/9)·[d·log₁₀(d) - d/ln(10)]₁¹⁰ = (20/9)·[10 - 10/ln10 + 1/ln10] = (20/9)·(10 - 9/ln10) ≈ 13.55 dB

PDF: L از 0 تا 20 dB تغییر می‌کند. g⁻¹(l) = 10^(l/20)، |dg⁻¹/dl| = (ln10/20)·10^(l/20).
f_L(l) = (1/9)·(ln10/20)·10^(l/20) برای 0 ≤ l ≤ 20.

### مسئله 5
کد MATLAB را برای بررسی مسئله 2 با شبیه‌سازی بنویسید.

**حل:**
```matlab
sigma = 2; R = 50; N = 500000;
X = sigma*randn(1,N);
P = X.^2 / R;
fprintf('E[P]: Theory=%.4f W, Sim=%.4f W\n', sigma^2/R, mean(P));
fprintf('P(P>0.2): Theory=%.4f, Sim=%.4f\n', 1-chi2cdf(0.2*R/sigma^2,1), mean(P>0.2));
```

---

*ماژول بعدی: [ماژول 6 — دو متغیر تصادفی](module06-two-random-variables.md)*
<!-- TRANSLATION END -->
