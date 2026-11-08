#!/usr/bin/env python3
"""The catalogs and the code that reads them, checked against each other.

  - every key the window or lib/ asks for is in i18n/en.json, and nothing in
    en.json is left that nobody asks for;
  - a key read with tn() is a plural entry and one read with t() is not;
  - every other catalog only carries keys English has, keeps the same %1
    holes, and gives a plural entry its "other" form;
  - no page or component has gained words written straight into it.

The last one is a heuristic, deliberately narrow: a capitalised literal
assigned to one of the properties a reader sees. It is what a new row looks
like when it was written the old way, and it is the mistake that would
otherwise only be found by someone reading the window in another language.
"""
import json
import re
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[4]
i18n = root / "i18n"
problems = []

qml = [root / "SettingsWindow.qml", root / "Panel.qml", root / "Service.qml"]
qml += sorted((root / "sections").glob("*.qml")) + sorted((root / "ui").glob("*.qml"))
shell = sorted((root / "lib").glob("*.sh")) + sorted((root / "bin").glob("*"))

used_t, used_tn = {}, {}
for f in qml:
    for n, line in enumerate(f.read_text().splitlines(), 1):
        for m in re.finditer(r'Strings\.(tn?)\("([^"]+)"', line):
            (used_tn if m.group(1) == "tn" else used_t).setdefault(m.group(2), f"{f.relative_to(root)}:{n}")
for f in shell:
    for n, line in enumerate(f.read_text().splitlines(), 1):
        for m in re.finditer(r'(?:^|[\s(;])t ([A-Za-z][\w.]*)', line):
            used_t.setdefault(m.group(1), f"{f.relative_to(root)}:{n}")

def load(path):
    try:
        data = json.loads(path.read_text())
    except json.JSONDecodeError as e:
        problems.append(f"{path.name}: not JSON ({e})")
        return {}
    if not isinstance(data, dict):
        problems.append(f"{path.name}: not an object")
        return {}
    return data

en = load(i18n / "en.json")

for key, where in sorted(used_t.items()):
    if key not in en:
        problems.append(f"{where}: {key} is not in en.json")
    elif isinstance(en[key], dict):
        problems.append(f"{where}: {key} is a plural entry, read it with tn()")
for key, where in sorted(used_tn.items()):
    if key not in en:
        problems.append(f"{where}: {key} is not in en.json")
    elif not isinstance(en[key], dict):
        problems.append(f"{where}: {key} is read with tn() but is not a plural entry")
for key in sorted(set(en) - set(used_t) - set(used_tn)):
    problems.append(f"en.json: {key} is not used anywhere")

def holes(value):
    texts = value.values() if isinstance(value, dict) else [value]
    return {h for t in texts for h in re.findall(r"%\d", str(t))}

for cat_path in sorted(i18n.glob("*.json")):
    if cat_path.name == "en.json":
        continue
    cat = load(cat_path)
    for key, value in cat.items():
        if key not in en:
            problems.append(f"{cat_path.name}: {key} is not in en.json")
            continue
        if isinstance(en[key], dict):
            if not isinstance(value, dict) or not value.get("other"):
                problems.append(f"{cat_path.name}: {key} needs plural forms with at least \"other\"")
                continue
        elif not isinstance(value, str) or value == "":
            problems.append(f"{cat_path.name}: {key} must be a non-empty string")
            continue
        # A form that drops the number ("One application…") is allowed to
        # drop its hole; every other difference is a sentence that lost or
        # invented a value.
        if isinstance(value, dict):
            missing = holes(en[key]) - holes(value)
            if missing and holes({k: v for k, v in value.items() if k != "one"}) != holes(en[key]):
                problems.append(f"{cat_path.name}: {key} drops {', '.join(sorted(missing))}")
        elif holes(value) != holes(en[key]):
            problems.append(f"{cat_path.name}: {key} has {sorted(holes(value))}, English has {sorted(holes(en[key]))}")

COPY = (r"(?<![\w.])(label|title|description|note|text|buttonText|placeholder|placeholderText|"
        r"emptyNote|actionText|cancelText|confirmText|tooltipText|headerNote|subtitle|tag)\s*:\s*"
        r"\"(\(?[A-Za-z][a-z][^\"]*)\"")
# Names, not words: they read the same in every language.
NAMES = {"Omarchy", "OmaControl", "Hyprland", "Bluetooth", "Herdr", "Tmux", "Neovim", "Linear", "Lazydocker"}
for f in qml:
    for n, line in enumerate(f.read_text().splitlines(), 1):
        if line.lstrip().startswith("//"):
            continue
        for m in re.finditer(COPY, line):
            if m.group(2) not in NAMES:
                problems.append(f"{f.relative_to(root)}:{n}: \"{m.group(2)}\" is written into the page, not the catalog")

if problems:
    print("\n".join(problems))
    print(f"\n{len(problems)} problems")
    sys.exit(1)
langs = sorted(p.stem for p in i18n.glob("*.json"))
print(f"{len(en)} strings, all used; catalogs: {', '.join(langs)}")
