<!-- TRANSLATION START -->
# ماژول 8 — امید ریاضی و واریانس شرطی

## اهداف یادگیری

پس از تکمیل این ماژول، دانشجویان قادر خواهند بود:
1. امیدهای ریاضی و واریانس‌های شرطی را محاسبه کنند
2. قانون امید ریاضی کل را به کار ببرند
3. قانون واریانس کل را به کار ببرند
4. از این ابزارها برای تحلیل مهندسی در شرایط کاری متعدد استفاده کنند

---

## 8.1 مقدمه

بسیاری از سیستم‌های مهندسی تحت **شرایط مختلف** کار می‌کنند (وضعیت‌های کانال، حالت‌ها، محیط‌ها). ما اغلب به **عملکرد میانگین کل** نیاز داریم که از عملکرد شرطی در هر وضعیت محاسبه می‌شود.

- میانگین BER چقدر است هنگامی که کانال به‌طور تصادفی میان خوب و بد جابه‌جا می‌شود؟
- واریانس کل اندازه‌گیری چقدر است هنگامی که حسگر در محیط‌های مختلف کار می‌کند؟

---

## 8.2 امید ریاضی شرطی E[X|Y=y]

### تعریف

**پیوسته:**
$$E[X|Y=y] = \int_{-\infty}^{\infty} x \cdot f_{X|Y}(x|y) \, dx$$

**گسسته:**
$$E[X|Y=y] = \sum_x x \cdot p_{X|Y}(x|y)$$

### تفسیر

E[X|Y=y] همان **مقدار میانگین X** است هنگامی که Y = y را می‌دانیم. این تابعی از y است.

### E[X|Y] به‌عنوان یک متغیر تصادفی

هنگامی که خود Y تصادفی باشد، E[X|Y] یک **متغیر تصادفی** است — وقتی Y = y باشد مقدار E[X|Y=y] را اختیار می‌کند.

### مثال مهندسی

توان دریافتی میانگین به‌شرط وضعیت کانال:
- کانال خوب (Y=1): E[P|Y=1] = 10 mW
- کانال ضعیف (Y=0): E[P|Y=0] = 1 mW
- P(Y=1) = 0.7، P(Y=0) = 0.3

---

## 8.3 واریانس شرطی Var(X|Y=y)

### تعریف

$$\text{Var}(X|Y=y) = E[(X - E[X|Y=y])^2 | Y=y] = E[X^2|Y=y] - (E[X|Y=y])^2$$

### تفسیر

واریانس شرطی **عدم‌قطعیت باقی‌مانده در X** را پس از معلوم‌شدن Y می‌سنجد.

### مثال مهندسی

دقت اندازه‌گیری به دما وابسته است:
- در T=20°C: Var(X|T=20) = 0.01 (دقت بالا)
- در T=80°C: Var(X|T=80) = 0.09 (دقت پایین به‌دلیل اثرهای گرمایی)

---

## 8.4 قانون امید ریاضی کل (خاصیت برج)

### بیان

$$E[X] = E[E[X|Y]]$$

**نسخه گسسته:**
$$E[X] = \sum_y E[X|Y=y] \cdot P(Y=y)$$

**نسخه پیوسته:**
$$E[X] = \int_{-\infty}^{\infty} E[X|Y=y] \cdot f_Y(y) \, dy$$

### اثبات (گسسته)

E[E[X|Y]] = Σ_y E[X|Y=y] · P(Y=y)
           = Σ_y [Σ_x x · P(X=x|Y=y)] · P(Y=y)
           = Σ_x Σ_y x · P(X=x, Y=y)
           = Σ_x x · P(X=x) = E[X] ✓

### تفسیر

**میانگین کل** برابر است با **میانگین وزنی میانگین‌های شرطی**، با وزن احتمال هر شرط.

### مثال مهندسی: میانگین BER در وضعیت‌های کانال

یک سیستم بی‌سیم میان سه حالت جابه‌جا می‌شود:
- حالت 1 (60% زمان): BER = 10⁻⁶
- حالت 2 (30% زمان): BER = 10⁻⁴
- حالت 3 (10% زمان): BER = 10⁻²

BER کل = E[BER] = 0.6(10⁻⁶) + 0.3(10⁻⁴) + 0.1(10⁻²)
            = 0.6×10⁻⁶ + 30×10⁻⁶ + 10000×10⁻⁶ ≈ 1.003 × 10⁻³

**نکته مهندسی:** BER کل تحت تسلط بدترین حالت است، هرچند که این حالت تنها در 10% زمان رخ می‌دهد.

### مثال مهندسی: عمر میانگین با انواع نقص

قطعات بدون نقص (90%) یا دارای نقص پنهان (10%) هستند:
- بدون نقص: E[T|good] = 10000 ساعت
- با نقص: E[T|defect] = 500 ساعت

E[T] = 0.9(10000) + 0.1(500) = 9050 ساعت

---

## 8.5 قانون واریانس کل

### بیان

$$\text{Var}(X) = E[\text{Var}(X|Y)] + \text{Var}(E[X|Y])$$

| جمله | نام | تفسیر |
|------|------|---------------|
| Var(X) | واریانس کل | عدم‌قطعیت کل در X |
| E[Var(X\|Y)] | واریانس شرطی مورد انتظار | تغییرپذیری «درون‌گروهی» میانگین |
| Var(E[X\|Y]) | واریانس میانگین‌های شرطی | تغییرپذیری «بین‌گروهی» |

### اثبات

Var(X) = E[X²] - (E[X])²

E[X²] = E[E[X²|Y]] (خاصیت برج)
       = E[Var(X|Y) + (E[X|Y])²]
       = E[Var(X|Y)] + E[(E[X|Y])²]

(E[X])² = (E[E[X|Y]])²

Var(X) = E[Var(X|Y)] + E[(E[X|Y])²] - (E[E[X|Y]])²
       = E[Var(X|Y)] + Var(E[X|Y]) ✓

### تفسیر: تجزیه عدم‌قطعیت

عدم‌قطعیت کل = میانگین عدم‌قطعیت درون هر شرط + تغییرپذیری میانگین میان شرایط

### مثال مهندسی: حسگر در دو محیط

یک حسگر در فضای بسته (Y=1، احتمال 0.6) و فضای باز (Y=2، احتمال 0.4) کار می‌کند:
- فضای بسته: E[X|Y=1] = 25°C، Var(X|Y=1) = 1
- فضای باز: E[X|Y=2] = 15°C، Var(X|Y=2) = 16

**E[Var(X|Y)]** = 0.6(1) + 0.4(16) = 7.0 (میانگین واریانس درون‌شرطی)

**Var(E[X|Y])** = E[(E[X|Y])²] - (E[E[X|Y]])²
= 0.6(25²) + 0.4(15²) - [0.6(25) + 0.4(15)]² = 375 + 90 - (21)² = 465 - 441 = 24

**Var(X)** = 7.0 + 24.0 = 31.0

بیشتر واریانس از تفاوت **بین‌شرطی** ناشی می‌شود (24 از 31).

---

## 8.6 مثال‌های MATLAB

### مثال 1: قانون امید ریاضی کل

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

### مثال 2: قانون واریانس کل

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

### مثال 3: امید ریاضی شرطی به‌عنوان بهترین پیش‌بینی‌کننده

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

## 8.7 مسائل تمرینی

### مسئله 1
یک لینک دیجیتال روی دو نوع کانال کار می‌کند:
- نوع A (احتمال 0.7): E[delay|A] = 5ms، Var(delay|A) = 2
- نوع B (احتمال 0.3): E[delay|B] = 20ms، Var(delay|B) = 25

موارد زیر را بیابید: (الف) E[delay]، (ب) Var(delay).

**حل:**
(a) E[D] = 0.7(5) + 0.3(20) = 3.5 + 6 = 9.5 ms
(b) E[Var(D|type)] = 0.7(2) + 0.3(25) = 1.4 + 7.5 = 8.9
    Var(E[D|type]) = 0.7(5²) + 0.3(20²) - 9.5² = 17.5 + 120 - 90.25 = 47.25
    Var(D) = 8.9 + 47.25 = 56.15

### مسئله 2
تعداد تصادفی N از قطعات آزمایش می‌شوند. N ~ Poisson(10). هر قطعه احتمال خرابی مستقل p=0.05 دارد. فرض کنید X = تعداد خرابی‌ها. E[X] و Var(X) را بیابید.

**حل:**
X|N ~ Binomial(N, 0.05). E[X|N] = 0.05N. Var(X|N) = N(0.05)(0.95) = 0.0475N.
E[X] = E[E[X|N]] = E[0.05N] = 0.05(10) = 0.5
Var(X) = E[Var(X|N)] + Var(E[X|N]) = E[0.0475N] + Var(0.05N) = 0.0475(10) + 0.05²(10) = 0.475 + 0.025 = 0.5

### مسئله 3
کد MATLAB را برای بررسی مسئله 2 با شبیه‌سازی بنویسید.

**حل:**
```matlab
N_trials = 100000; p = 0.05; lambda = 10;
N = poissrnd(lambda, 1, N_trials);
X = binornd(N, p);
fprintf('E[X]: theory=0.5, sim=%.3f\n', mean(X));
fprintf('Var(X): theory=0.5, sim=%.3f\n', var(X));
```

---

*ماژول بعدی: [ماژول 9 — کوواریانس و همبستگی](module09-covariance-correlation.md)*
<!-- TRANSLATION END -->
