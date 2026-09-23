#!/usr/bin/env python3
"""Build the ProbAndStats lecture notes.

markdown/{fa,en}/*.md  --pandoc + tools/md2tex.lua-->  {fa,en}/NN-slug/content.tex
and a standalone main file per module, plus the complete book in {fa,en}/full-notes/.
Every main file is then compiled with tectonic (XeTeX engine).

Usage:  python3 tools/build.py [--no-pdf] [--only fa|en] [--module 01]
"""
import argparse
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
FILTER = ROOT / "tools" / "md2tex.lua"
PANDOC_FROM = ("markdown+hard_line_breaks+lists_without_preceding_blankline"
               "-auto_identifiers-implicit_figures")

FA_DIGITS = str.maketrans("0123456789", "۰۱۲۳۴۵۶۷۸۹")


def md_title(md: Path):
    for line in md.read_text(encoding="utf-8").splitlines():
        if line.startswith("# "):
            head = line[2:].strip()
            parts = re.split(r"\s+[—–-]\s+", head, maxsplit=1)
            title = parts[1].strip() if len(parts) == 2 else head
            return title.replace("ئ", "ی")
    return md.stem


def pandoc_body(md: Path, lang: str) -> str:
    env = dict(os.environ, PS_LANG=lang)
    tex = subprocess.run(
        ["pandoc", "-f", PANDOC_FROM, "-t", "latex", "--wrap=preserve",
         "--syntax-highlighting=tango", "--lua-filter", str(FILTER), str(md)],
        check=True, capture_output=True, text=True, env=env).stdout
    # navy header row for every table
    tex = tex.replace("\\toprule\\noalign{}\n", "\\toprule\\noalign{}\n\\rowcolor{PSnavy}")
    # plain header cells (pandoc wraps them in minipages for wide tables)
    tex = re.sub(r"\\begin\{minipage\}\[b\]\{\\linewidth\}\\raggedright\n(.*?)\n\\end\{minipage\}",
                 lambda m: m.group(1), tex, flags=re.S)
    # centred tables with centred cells
    tex = tex.replace("\\begin{longtable}[]", "\\begin{longtable}[c]")
    tex = tex.replace(">{\\raggedright\\arraybackslash}p{", ">{\\centering\\arraybackslash}p{")
    tex = re.sub(r"(\\begin\{longtable\}\[c\]\{@\{\})([lr]+)(@\{\}\})",
                 lambda m: m.group(1) + "c" * len(m.group(2)) + m.group(3), tex)
    # keep wide tables inside the text block
    tex = tex.replace("p{(\\linewidth - ", "p{(0.965\\linewidth - ")
    return tex


def main_file(lang, preamble_extra, body):
    size = "12pt" if lang == "fa" else "11pt"
    return (
        "% !TEX program = xelatex\n"
        f"% Engineering Probability & Statistics — Fall 2026-2027 ({'Persian' if lang == 'fa' else 'English'})\n"
        "% Generated from markdown/ by tools/build.py — compile with XeLaTeX or tectonic.\n"
        f"\\documentclass[{size}]{{article}}\n"
        "\\def\\PSroot{../../template}\n"
        f"\\input{{\\PSroot/probstats-{lang}}}\n"
        f"{preamble_extra}"
        "\\begin{document}\n"
        f"{body}"
        "\\end{document}\n")


def build_sources(lang, only_module=None):
    src = ROOT / "markdown" / lang
    other = "en" if lang == "fa" else "fa"
    out_dirs = []
    modules = []
    for md in sorted(src.glob("module*.md")):
        m = re.match(r"module(\d+)-(.+)\.md", md.name)
        num, slug = m.group(1), m.group(2)
        n = str(int(num))
        title = md_title(md)
        other_md = ROOT / "markdown" / other / md.name
        other_title = md_title(other_md) if other_md.exists() else ""
        folder = ROOT / lang / f"{num}-{slug}"
        modules.append((n, title, other_title, folder))
        if only_module and num != only_module:
            continue
        folder.mkdir(parents=True, exist_ok=True)
        (folder / "content.tex").write_text(pandoc_body(md, lang), encoding="utf-8")
        label = f"ماژول {n.translate(FA_DIGITS)}" if lang == "fa" else f"Module {n}"
        name = f"module{num}-{slug}"
        (folder / f"{name}.tex").write_text(main_file(
            lang,
            f"\\PSsetmodule{{{n}}}{{{title}}}{{{other_title}}}\n",
            f"\\PScoverpage{{{label}}}{{{title}}}{{{other_title}}}\n\\input{{content}}\n"),
            encoding="utf-8")
        out_dirs.append(folder / f"{name}.tex")

    syllabus = src / "syllabus.md"
    if syllabus.exists() and not only_module:
        folder = ROOT / lang / "00-syllabus"
        folder.mkdir(parents=True, exist_ok=True)
        (folder / "content.tex").write_text(pandoc_body(syllabus, lang), encoding="utf-8")
        (folder / "syllabus.tex").write_text(main_file(
            lang, "\\PSsetmodule{}{طرح درس}{Course Syllabus}\n",
            "\\PScoverpage{طرح درس}{اهداف، سرفصل‌ها و ارزشیابی}{Course Syllabus}\n"
            "\\input{content}\n"), encoding="utf-8")
        out_dirs.append(folder / "syllabus.tex")

    if not only_module:
        folder = ROOT / lang / "full-notes"
        folder.mkdir(parents=True, exist_ok=True)
        parts = []
        if lang == "fa":
            cover = "\\PScoverpage{جزوه کامل درس}{ماژول‌های ۱ تا ۱۶}{Complete Lecture Notes - Modules 1-16}\n"
        else:
            cover = "\\PScoverpage{Complete Lecture Notes}{Modules 1-16}{جزوه کامل درس - ماژول‌های ۱ تا ۱۶}\n"
        parts.append(cover)
        parts.append("\\PSsetmodule{}{\\PSlangContents}{}\n"
                     "{\\hypersetup{linkcolor=PSnavy}\\tableofcontents}\n\\clearpage\n")
        if syllabus.exists():
            parts.append("\\PSsetmodule{}{\\PSlangSyllabus}{}\n"
                         "\\addcontentsline{toc}{part}{\\PSlangSyllabus}\n"
                         "\\input{../00-syllabus/content}\n")
        for n, title, other_title, mfolder in modules:
            parts.append(f"\\PSmoduleopener{{{n}}}{{{title}}}{{{other_title}}}\n"
                         f"\\input{{../{mfolder.name}/content}}\n")
        name = f"ProbAndStats-{lang}"
        (folder / f"{name}.tex").write_text(main_file(lang, "", "".join(parts)), encoding="utf-8")
        out_dirs.append(folder / f"{name}.tex")
    return out_dirs


def compile_tex(tex: Path):
    r = subprocess.run(["tectonic", "--keep-logs", "--chatter", "minimal", tex.name],
                       cwd=tex.parent, capture_output=True, text=True)
    log = tex.with_suffix(".log")
    missing = set()
    if log.exists():
        missing = set(re.findall(r"Missing character: There is no (.) ", log.read_text(errors="replace")))
    status = "ok" if r.returncode == 0 else "FAILED"
    msg = f"[{status}] {tex.relative_to(ROOT)}"
    if missing:
        msg += f"  missing glyphs: {''.join(sorted(missing))}"
    if r.returncode != 0:
        msg += "\n" + r.stderr[-3000:]
    return r.returncode == 0, msg


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--no-pdf", action="store_true")
    ap.add_argument("--only", choices=["fa", "en"])
    ap.add_argument("--module")
    ap.add_argument("--jobs", type=int, default=4)
    a = ap.parse_args()
    langs = [a.only] if a.only else ["fa", "en"]
    texs = []
    for lang in langs:
        texs += build_sources(lang, a.module)
    print(f"generated {len(texs)} LaTeX files")
    if a.no_pdf:
        return
    ok = True
    with ThreadPoolExecutor(a.jobs) as ex:
        for good, msg in ex.map(compile_tex, texs):
            ok &= good
            print(msg, flush=True)
    sys.exit(0 if ok else 1)


if __name__ == "__main__":
    main()
