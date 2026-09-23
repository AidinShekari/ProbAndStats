<div align="center">

<img src="template/ferdowsi-logo.png" width="110" alt="Ferdowsi University of Mashhad">

# آمار و احتمال مهندسی
### Engineering Probability & Statistics

**نیمسال پاییز ۱۴۰۵-۱۴۰۶ · Fall 2026–2027**
دانشگاه فردوسی مشهد · Ferdowsi University of Mashhad

استاد: [امین آذری](https://github.com/AminAzari) · Instructor: [Amin Azari](https://github.com/AminAzari)

</div>

---

## 📘 جزوه کامل · Complete Notes

| | فارسی | English |
|---|---|---|
| جزوه کامل (همه ماژول‌ها) · Full notes | [ProbAndStats-fa.pdf](fa/full-notes/ProbAndStats-fa.pdf) | [ProbAndStats-en.pdf](en/full-notes/ProbAndStats-en.pdf) |
| طرح درس · Syllabus | [syllabus.pdf](fa/00-syllabus/syllabus.pdf) | — |

## 📑 ماژول‌ها · Modules

| # | ماژول | Module | PDF (fa) | PDF (en) |
|---|---|---|---|---|
| 1 | احتمال | Probability | [PDF](fa/01-probability/module01-probability.pdf) | [PDF](en/01-probability/module01-probability.pdf) |
| 2 | یک متغیر تصادفی | One Random Variable | [PDF](fa/02-one-random-variable/module02-one-random-variable.pdf) | [PDF](en/02-one-random-variable/module02-one-random-variable.pdf) |
| 3 | توزیع‌های مهم | Important Distributions | [PDF](fa/03-important-distributions/module03-important-distributions.pdf) | [PDF](en/03-important-distributions/module03-important-distributions.pdf) |
| 4 | امید ریاضی و گشتاورها | Expectation & Moments | [PDF](fa/04-expectation-moments/module04-expectation-moments.pdf) | [PDF](en/04-expectation-moments/module04-expectation-moments.pdf) |
| 5 | توابع متغیر تصادفی | Functions of a RV | [PDF](fa/05-rv-functions/module05-rv-functions.pdf) | [PDF](en/05-rv-functions/module05-rv-functions.pdf) |
| 6 | دو متغیر تصادفی | Two Random Variables | [PDF](fa/06-two-random-variables/module06-two-random-variables.pdf) | [PDF](en/06-two-random-variables/module06-two-random-variables.pdf) |
| 7 | توابع دو متغیر تصادفی | Functions of Two RVs | [PDF](fa/07-functions-two-rv/module07-functions-two-rv.pdf) | [PDF](en/07-functions-two-rv/module07-functions-two-rv.pdf) |
| 8 | امید ریاضی شرطی | Conditional Expectation | [PDF](fa/08-conditional-expectation/module08-conditional-expectation.pdf) | [PDF](en/08-conditional-expectation/module08-conditional-expectation.pdf) |
| 9 | کوواریانس و همبستگی | Covariance & Correlation | [PDF](fa/09-covariance-correlation/module09-covariance-correlation.pdf) | [PDF](en/09-covariance-correlation/module09-covariance-correlation.pdf) |
| 10 | چند متغیر تصادفی | Multiple Random Variables | [PDF](fa/10-multiple-random-variables/module10-multiple-random-variables.pdf) | [PDF](en/10-multiple-random-variables/module10-multiple-random-variables.pdf) |
| 11 | قضیه حد مرکزی | Central Limit Theorem | [PDF](fa/11-central-limit-theorem/module11-central-limit-theorem.pdf) | [PDF](en/11-central-limit-theorem/module11-central-limit-theorem.pdf) |
| 12 | مقدمه‌ای بر آمار | Intro to Statistics | [PDF](fa/12-intro-statistics/module12-intro-statistics.pdf) | [PDF](en/12-intro-statistics/module12-intro-statistics.pdf) |
| 13 | برآورد پارامتر | Parameter Estimation | [PDF](fa/13-parameter-estimation/module13-parameter-estimation.pdf) | [PDF](en/13-parameter-estimation/module13-parameter-estimation.pdf) |
| 14 | فاصله اطمینان | Confidence Intervals | [PDF](fa/14-confidence-intervals/module14-confidence-intervals.pdf) | [PDF](en/14-confidence-intervals/module14-confidence-intervals.pdf) |
| 15 | آزمون فرض | Hypothesis Testing | [PDF](fa/15-hypothesis-testing/module15-hypothesis-testing.pdf) | [PDF](en/15-hypothesis-testing/module15-hypothesis-testing.pdf) |
| 16 | کاربردهای مهندسی | Engineering Applications | [PDF](fa/16-engineering-applications/module16-engineering-applications.pdf) | [PDF](en/16-engineering-applications/module16-engineering-applications.pdf) |

## 🗂 ساختار پوشه‌ها · Repository layout

```
ProbAndStats/
├── fa/                     جزوه فارسی (راست‌به‌چپ، B Nazanin + Times New Roman)
│   ├── 00-syllabus/        طرح درس
│   ├── 01-probability/     moduleNN-*.tex (فایل اصلی) + content.tex (متن) + moduleNN-*.pdf
│   ├── …
│   └── full-notes/         ProbAndStats-fa.tex / .pdf  (جزوه کامل با فهرست مطالب)
├── en/                     English notes (same layout)
├── markdown/{fa,en}/       Markdown sources (منبع اصلی متن)
├── template/               probstats-*.tex (قالب)، لوگوی دانشگاه، فونت B Nazanin
└── tools/                  build.py + md2tex.lua (تبدیل Markdown → LaTeX → PDF)
```

## 🛠 ساخت دوباره · Rebuilding

The `.tex` files are generated from the Markdown sources — edit `markdown/`, then run:

```bash
python3 tools/build.py            # everything (fa + en)
python3 tools/build.py --only fa --module 03
```

Requirements: [pandoc](https://pandoc.org) ≥ 3 and [tectonic](https://tectonic-typesetting.github.io) (or any TeX Live with XeLaTeX).
Each `.tex` also compiles on its own with `xelatex` from inside its folder. Fonts: *B Nazanin* (bundled in `template/fonts/`), *Times New Roman* and *Menlo* (system fonts).
