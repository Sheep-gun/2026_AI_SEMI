#!/usr/bin/env python3
"""Render final Innovus post-route DEF coordinates into presentation PNGs."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


LAYER_COLORS = {
    "Metal1": "#ef8354", "Metal2": "#4ea5d9", "Metal3": "#9b7ede",
    "Metal4": "#58c4a3", "Metal5": "#e26dcb", "Metal6": "#f2cc60",
    "Metal7": "#f08a5d", "Metal8": "#63c7b2", "Metal9": "#ca8df2",
    "Metal10": "#f6d365",
}


def section(text: str, name: str) -> str:
    match = re.search(rf"(?ms)^{name}\s+\d+\s*;(.*?)^END {name}\s*$", text)
    if not match:
        raise ValueError(f"DEF section {name} not found")
    return match.group(1)


def parse_point(token: tuple[str, str], reference=(0.0, 0.0)):
    x = reference[0] if token[0] == "*" else float(token[0])
    y = reference[1] if token[1] == "*" else float(token[1])
    return x, y


def routed_segments(body: str):
    segments = []
    current_layer = None
    previous = None
    for line in body.splitlines():
        route = re.search(r"\b(?:ROUTED|NEW)\s+(Metal(?:10|[1-9]))\b", line)
        if route:
            current_layer = route.group(1)
            previous = None
        if not current_layer:
            continue
        points = re.findall(r"\(\s*(\*|-?\d+)\s+(\*|-?\d+)(?:\s+-?\d+)?\s*\)", line)
        for token in points:
            point = parse_point(token, previous or (0.0, 0.0))
            if previous is not None and point != previous:
                segments.append((current_layer, previous, point))
            previous = point
        if ";" in line:
            current_layer = None
            previous = None
    return segments


def parse_def(path: Path):
    text = path.read_text(encoding="utf-8", errors="replace")
    units_match = re.search(r"UNITS DISTANCE MICRONS\s+(\d+)", text)
    die_match = re.search(
        r"DIEAREA\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)\s+"
        r"\(\s*(-?\d+)\s+(-?\d+)\s*\)", text, re.S,
    )
    if not units_match or not die_match:
        raise ValueError(f"Cannot read DEF units or DIEAREA from {path}")
    units = float(units_match.group(1))
    die = tuple(float(value) / units for value in die_match.groups())

    core_values = []
    for key in ("LL_X", "LL_Y", "UR_X", "UR_Y"):
        match = re.search(rf"FE_CORE_BOX_{key}\s+REAL\s+([0-9.]+)", text)
        core_values.append(float(match.group(1)) if match else None)
    if any(value is None for value in core_values):
        x1, y1, x2, y2 = die
        core_values = [x1 + 5, y1 + 5, x2 - 5, y2 - 5]
    core = tuple(core_values)

    components = []
    for block in re.findall(r"(?ms)^-\s+(.+?)\s*;", section(text, "COMPONENTS")):
        header = re.match(r"(\S+)\s+(\S+)", block)
        placed = re.search(r"\+\s+(?:PLACED|FIXED)\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)", block)
        if header and placed:
            x, y = (float(value) / units for value in placed.groups())
            components.append((*header.groups(), x, y))

    pins = []
    for block in re.findall(r"(?ms)^-\s+(.+?)\s*;", section(text, "PINS")):
        name_match = re.match(r"(\S+)", block)
        direction = re.search(r"\+\s+DIRECTION\s+(INPUT|OUTPUT|INOUT)", block)
        placed = re.search(r"\+\s+(?:PLACED|FIXED)\s+\(\s*(-?\d+)\s+(-?\d+)\s*\)", block)
        if name_match and direction and placed:
            x, y = (float(value) / units for value in placed.groups())
            pins.append((name_match.group(1), direction.group(1), x, y))

    return (
        die, core, components, pins,
        routed_segments(section(text, "SPECIALNETS")),
        routed_segments(section(text, "NETS")), units,
    )


def rgba(hex_color: str, alpha=255):
    value = hex_color.lstrip("#")
    return tuple(int(value[index:index + 2], 16) for index in (0, 2, 4)) + (alpha,)


def load_font(size: int, bold=False):
    candidates = [
        r"C:\Windows\Fonts\malgunbd.ttf" if bold else r"C:\Windows\Fonts\malgun.ttf",
        r"C:\Windows\Fonts\arialbd.ttf" if bold else r"C:\Windows\Fonts\arial.ttf",
    ]
    for candidate in candidates:
        try:
            return ImageFont.truetype(candidate, size)
        except OSError:
            pass
    return ImageFont.load_default()


def draw_layout(output: Path, title: str, data):
    die, core, components, pins, special, routes, units = data
    die_x1, die_y1, die_x2, die_y2 = die
    die_w, die_h = die_x2 - die_x1, die_y2 - die_y1
    core_x1, core_y1, core_x2, core_y2 = core
    width, height = 1800, 1500
    left, top, right, bottom = 120, 190, 1680, 1330
    scale = min((right - left) / die_w, (bottom - top) / die_h)
    plot_w, plot_h = die_w * scale, die_h * scale
    x0 = left + ((right - left) - plot_w) / 2
    y0 = top + ((bottom - top) - plot_h) / 2

    def point(x, y):
        return x0 + (x - die_x1) * scale, y0 + (die_y2 - y) * scale

    image = Image.new("RGBA", (width, height), "#0d1520")
    draw = ImageDraw.Draw(image, "RGBA")
    title_font, body_font, small_font = load_font(36, True), load_font(21), load_font(16)
    draw.rectangle((*point(die_x1, die_y2), *point(die_x2, die_y1)), outline="#e8eef5", width=3)
    draw.rectangle((*point(core_x1, core_y2), *point(core_x2, core_y1)), fill="#162736", outline="#64dcc9", width=3)

    for layer, p1, p2 in special:
        draw.line((*point(p1[0] / units, p1[1] / units), *point(p2[0] / units, p2[1] / units)),
                  fill=rgba(LAYER_COLORS.get(layer, "#f6d365"), 230), width=7)
    for layer, p1, p2 in routes:
        draw.line((*point(p1[0] / units, p1[1] / units), *point(p2[0] / units, p2[1] / units)),
                  fill=rgba(LAYER_COLORS.get(layer, "#a7b7c7"), 72), width=2)

    for _, master, x, y in components:
        px, py = point(x, y)
        if master.startswith(("DFF", "SDFF", "TLAT")):
            color, radius = "#ffb454", 4
        elif master.startswith(("CLK", "DLY")):
            color, radius = "#63d6ff", 4
        else:
            color, radius = "#e0e8ef", 2
        draw.rectangle((px - radius, py - radius, px + radius, py + radius), fill=color)
    for _, direction, x, y in pins:
        px, py = point(x, y)
        color = "#74e6c4" if direction == "INPUT" else "#ff8ca3"
        draw.ellipse((px - 5, py - 5, px + 5, py + 5), fill=color, outline="#0d1520")

    title_box = draw.textbbox((0, 0), title, font=title_font)
    draw.text(((width - title_box[2]) / 2, 38), title, font=title_font, fill="#f4f7fa")
    subtitle = (
        f"Innovus post-route DEF 좌표  |  Die {die_w:.2f} x {die_h:.2f} µm  |  "
        f"Core {(core_x2-core_x1):.2f} x {(core_y2-core_y1):.2f} µm  |  {len(components)} instances"
    )
    subtitle_box = draw.textbbox((0, 0), subtitle, font=body_font)
    draw.text(((width - subtitle_box[2]) / 2, 94), subtitle, font=body_font, fill="#aebdca")
    note = "셀은 실제 배치 중심, 배선은 DEF routing 좌표를 표시합니다. 색상은 가독성을 위한 시각화입니다."
    note_box = draw.textbbox((0, 0), note, font=small_font)
    draw.text(((width - note_box[2]) / 2, 1385), note, font=small_font, fill="#aebdca")

    legend = [("조합 셀", "#e0e8ef"), ("FF/Latch", "#ffb454"), ("Clock/Delay", "#63d6ff"),
              ("입력 pin", "#74e6c4"), ("출력 pin", "#ff8ca3")]
    cursor, legend_y = 330, 1430
    for label, color in legend:
        draw.rectangle((cursor, legend_y, cursor + 18, legend_y + 18), fill=color)
        draw.text((cursor + 27, legend_y - 2), label, font=small_font, fill="#d2dce5")
        cursor += 72 + int(draw.textlength(label, font=small_font))

    output.parent.mkdir(parents=True, exist_ok=True)
    image.convert("RGB").save(output, quality=95)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("def_file", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--title", required=True)
    args = parser.parse_args()
    draw_layout(args.output, args.title, parse_def(args.def_file))


if __name__ == "__main__":
    main()
