#!/usr/bin/env python3
"""Render an Innovus DEF as placement and routed-layout PNGs."""

from __future__ import annotations

import argparse
import re
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

LAYER_COLORS = {
    "Metal1": "#ef8354", "Metal2": "#4ea5d9", "Metal3": "#9b7ede",
    "Metal4": "#58c4a3", "Metal5": "#e26dcb", "Metal6": "#f2cc60",
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
    for line in body.splitlines():
        route = re.search(r"\b(?:ROUTED|NEW)\s+(Metal[1-6])\b", line)
        if not route:
            continue
        points = re.findall(r"\(\s*(\*|-?\d+)\s+(\*|-?\d+)(?:\s+-?\d+)?\s*\)", line)
        if len(points) < 2:
            continue
        p1 = parse_point(points[0])
        p2 = parse_point(points[1], p1)
        if p1 != p2:
            segments.append((route.group(1), p1, p2))
    return segments


def parse_def(path: Path):
    text = path.read_text(encoding="utf-8", errors="replace")
    units = float(re.search(r"UNITS DISTANCE MICRONS\s+(\d+)", text).group(1))
    die_values = [float(v) for v in re.search(
        r"DIEAREA\s+\(\s*(\d+)\s+(\d+)\s*\)\s+\(\s*(\d+)\s+(\d+)\s*\)", text
    ).groups()]
    die = tuple(value / units for value in die_values)
    core = tuple(float(re.search(rf"FE_CORE_BOX_{key}\s+REAL\s+([0-9.]+)", text).group(1))
                 for key in ("LL_X", "LL_Y", "UR_X", "UR_Y"))

    components = []
    for block in re.findall(r"(?ms)^-\s+(.+?)\s*;", section(text, "COMPONENTS")):
        header = re.match(r"(\S+)\s+(\S+)", block)
        placed = re.search(r"\+\s+(?:PLACED|FIXED)\s+\(\s*(\d+)\s+(\d+)\s*\)", block)
        if header and placed:
            x, y = (float(v) / units for v in placed.groups())
            components.append((*header.groups(), x, y))

    pins = []
    for block in re.findall(r"(?ms)^-\s+(.+?)\s*;", section(text, "PINS")):
        name = re.match(r"(\S+)", block).group(1)
        direction = re.search(r"\+\s+DIRECTION\s+(INPUT|OUTPUT|INOUT)", block)
        placed = re.search(r"\+\s+(?:PLACED|FIXED)\s+\(\s*(\d+)\s+(\d+)\s*\)", block)
        if direction and placed:
            x, y = (float(v) / units for v in placed.groups())
            pins.append((name, direction.group(1), x, y))
    return die, core, components, pins, routed_segments(section(text, "SPECIALNETS")), routed_segments(section(text, "NETS"))


def rgba(hex_color: str, alpha=255):
    value = hex_color.lstrip("#")
    return tuple(int(value[i:i + 2], 16) for i in (0, 2, 4)) + (alpha,)


def load_font(size: int, bold=False):
    names = [
        r"C:\Windows\Fonts\arialbd.ttf" if bold else r"C:\Windows\Fonts\arial.ttf",
        r"C:\Windows\Fonts\segoeuib.ttf" if bold else r"C:\Windows\Fonts\segoeui.ttf",
    ]
    for name in names:
        try:
            return ImageFont.truetype(name, size)
        except OSError:
            pass
    return ImageFont.load_default()


def draw_layout(path: Path, show_routes: bool, data):
    die, core, components, pins, special, routes = data
    _, _, die_w, die_h = die
    core_x1, core_y1, core_x2, core_y2 = core
    width, height = 1800, 1550
    left, top, right, bottom = 120, 155, 1680, 1395
    scale = min((right - left) / die_w, (bottom - top) / die_h)
    plot_w, plot_h = die_w * scale, die_h * scale
    x0 = left + ((right - left) - plot_w) / 2
    y0 = top + ((bottom - top) - plot_h) / 2

    def point(x, y):
        return x0 + x * scale, y0 + (die_h - y) * scale

    image = Image.new("RGBA", (width, height), "#10151d")
    ctx = ImageDraw.Draw(image, "RGBA")
    title_font, body_font, small_font = load_font(34), load_font(20), load_font(16)
    for step in range(0, 181, 20):
        a, b = point(step, 0), point(step, die_h)
        ctx.line((*a, *b), fill=(255, 255, 255, 10), width=1)
        a, b = point(0, step), point(die_w, step)
        ctx.line((*a, *b), fill=(255, 255, 255, 10), width=1)

    ctx.rectangle((*point(0, die_h), *point(die_w, 0)), outline="#d9e2ec", width=3)
    ctx.rectangle((*point(core_x1, core_y2), *point(core_x2, core_y1)),
                  fill="#172431", outline="#62d6c5", width=2)
    for layer, p1, p2 in special:
        a = point(p1[0] / 2000.0, p1[1] / 2000.0)
        b = point(p2[0] / 2000.0, p2[1] / 2000.0)
        ctx.line((*a, *b), fill=rgba(LAYER_COLORS[layer], 225), width=8)
    if show_routes:
        for layer, p1, p2 in routes:
            a = point(p1[0] / 2000.0, p1[1] / 2000.0)
            b = point(p2[0] / 2000.0, p2[1] / 2000.0)
            ctx.line((*a, *b), fill=rgba(LAYER_COLORS[layer], 82), width=2)

    for _, master, x, y in components:
        px, py = point(x, y)
        if master.startswith(("DFF", "SDFF", "LATCH")):
            color, radius = "#ffb454", 3
        elif master.startswith(("CLK", "DLY")):
            color, radius = "#65d6ff", 4
        else:
            color, radius = "#d9e2ec", 2
        ctx.rectangle((px - radius, py - radius, px + radius, py + radius), fill=color)
    for _, direction, x, y in pins:
        px, py = point(x, y)
        color = "#7ce6c6" if direction == "INPUT" else "#ff8ca3"
        ctx.ellipse((px - 5, py - 5, px + 5, py + 5), fill=color, outline="#10151d", width=1)

    title = "P2 TSMC 180 nm post-route layout" if show_routes else "P2 TSMC 180 nm placement and power grid"
    box = ctx.textbbox((0, 0), title, font=title_font)
    ctx.text(((width - box[2]) / 2, 42), title, font=title_font, fill="#f4f7fa")
    subtitle = "Die 182.16 x 176.40 um  |  Core 141.24 x 136.08 um  |  476 cells  |  61.45% density"
    box = ctx.textbbox((0, 0), subtitle, font=body_font)
    ctx.text(((width - box[2]) / 2, 91), subtitle, font=body_font, fill="#aebdca")

    legend = [("Comb cell", "#d9e2ec"), ("Sequential", "#ffb454"),
              ("Clock/delay", "#65d6ff"), ("Power grid", "#e26dcb")]
    if show_routes:
        legend += list(LAYER_COLORS.items())
    cursor, legend_y = 105, 1450
    for label, color in legend:
        ctx.rectangle((cursor, legend_y, cursor + 18, legend_y + 18), fill=color)
        ctx.text((cursor + 26, legend_y - 1), label, font=small_font, fill="#c9d4de")
        cursor += 60 + int(ctx.textlength(label, font=small_font))
    image.convert("RGB").save(path, quality=95)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("def_file", type=Path)
    parser.add_argument("output_dir", type=Path)
    args = parser.parse_args()
    args.output_dir.mkdir(parents=True, exist_ok=True)
    data = parse_def(args.def_file)
    if len(data[2]) != 476:
        raise ValueError(f"Expected 476 components, parsed {len(data[2])}")
    draw_layout(args.output_dir / "p2_180nm_placement_power.png", False, data)
    draw_layout(args.output_dir / "p2_180nm_postroute_layout.png", True, data)


if __name__ == "__main__":
    main()
