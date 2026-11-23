---
name: flat-svg-logo
description: Design a hand-written SVG logo for a project in a flat, two-colour, thick-rounded-stroke retro-cartoon style, with colours chosen to fit each project. Use whenever asked to make, redo or refresh a project's logo or icon, even if no style is mentioned.
---

# Flat SVG logo

Make a project logo as a small SVG written by hand. The **style** stays the same across projects so they feel like a family. The **content and colours** are chosen for each project.

## 1. Understand the project

- Find the project's name, what it does and its mood (playful, technical, calm, fast, …). Read the README and package metadata if you're in a repo. Ask only if neither tells you.
- Look for existing colours the project already uses: CSS variables or theme files in a site/docs folder, an existing favicon or logo, badge colours in the README. A logo should match its own website.

## 2. Choose the palette

The structure is fixed. The values are not. Every logo uses exactly:

- **ink**: one dark colour for outlines and small solid details. Pick a deep, slightly tinted dark (navy, plum, forest, espresso, charcoal-teal) rather than pure black, so the logo feels warmer and less like clip art.
- **accent**: one saturated colour for 2–4 small eye-catching elements. Pick it from the project's mood or domain (e.g. green for growth/data, coral for media/social, violet for dev tools, amber for energy/speed, teal for networking).
- **white** (`#fff`): main shape fills and knockouts.

Pick values in this order:

1. Colours the user names.
2. Colours the project already uses (step 1).
3. Otherwise, choose a fresh pair for this project. Don't reuse a palette from another logo unless asked, because each project should be recognisable on its own.

Checks:

- ink vs white: strong contrast (ink lightness under ~25%).
- accent vs white: still clearly visible (contrast ≥ ~3:1). Darken the accent slightly if it washes out.
- ink and accent should be clearly different hues, so the accent actually pops.

State the chosen pair and a few words on why (e.g. "ink #2B1B3D (deep plum), accent #2FB59A (mint) — calm and technical").

## 3. Pick a concept

- Write 3 concepts, one sentence each. Each should be a visual pun on the name or a literal mash-up of two everyday objects that represent it (e.g. "tv pipe" → a retro TV with a smoking pipe coming out of the screen).
- No letters or text in the mark.
- Pick the strongest concept (the clearest silhouette, readable at 32 px) and say which one in a line. If the user wants to choose, show the 3 and wait.

## 4. Style rules

These rules are what keep the logos a family. Follow them closely.

- Flat, friendly, retro-cartoon icon, like a sticker.
- Only the three palette colours. No extra tints, gradients, shadows, filters, textures or text.
- Thick uniform strokes: 12–16 px on a ~560 px canvas. `stroke-linecap="round"` and `stroke-linejoin="round"` everywhere.
- Main shapes: white fill + ink outline. Accent shapes: accent fill + ink outline. Small details (tips, feet, dots) can be solid ink or solid accent with no outline.
- Accent goes on only a few elements, so it guides the eye instead of taking over.
- Slightly imperfect, hand-drawn geometry: big corner radii, gently bowed edges (quadratic curves instead of straight lines), and playful extras like dots, puffs, motion/smoke lines.
- Overlaps: draw the front shape first as a thick white stroke (~40 px) as a knockout, then the real shape on top, so the shapes separate cleanly.
- No fine detail. It must still read at 32 px.

## 5. Code rules

- Write the SVG by hand. Don't use a drawing library, tracing tool or image model. Hand-written SVG stays tiny, clean and easy to tweak later.
- Primitives: `line`, `circle`, `rect`, `ellipse`, and short `path`s with arcs and Q/C curves.
- Integer coordinates only. `viewBox="0 0 560 520"` (adjust if the shape needs it), matching `width`/`height`, and a `<title>`.
- Put shared stroke settings on a parent `<g>`. Group the elements logically and comment each group.
- Put the palette in a comment at the top so it's easy to recolour later.
- Aim for under ~3 KB.

Skeleton (replace INK and ACCENT with the chosen hex values):

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 560 520" width="560" height="520">
  <title>project name</title>
  <!-- palette: ink INK, accent ACCENT -->
  <g fill="none" stroke-linecap="round" stroke-linejoin="round">
    <!-- main body -->
    <rect x="40" y="140" width="400" height="320" rx="48" stroke="INK" stroke-width="16" fill="#fff"/>
    <!-- details -->
    <circle cx="390" cy="220" r="16" fill="ACCENT"/>
    <!-- second object: white knockout, then shape -->
    <g stroke-width="14">
      <path d="..." stroke="#fff" stroke-width="40"/>
      <path d="..." fill="ACCENT" stroke="INK"/>
    </g>
  </g>
</svg>
```

## 6. Render, look, fix

Don't stop after the first draft. SVG proportions are almost always off at first.

1. Render it: `rsvg-convert -w 512 logo.svg -o /tmp/logo.png` (fallback: `pip install cairosvg`, then `python3 -c "import cairosvg; cairosvg.svg2png(url='logo.svg', write_to='/tmp/logo.png', output_width=512)"`).
2. View the PNG. Check: silhouette clear? balanced inside the canvas, nothing clipped? strokes consistent? accent limited to a few spots? colours working together? the pun obvious?
3. Also render at 32 px and check it still reads.
4. Edit and repeat. Usually 2–4 rounds.

## 7. Deliver

- Save as `docs/logo/<project>.svg` in a repo (or `logo.svg` otherwise). Copy it to the site's static folder if there is one.
- Offer to add it to the top of the README: `<p align="center"><img src="docs/logo/<project>.svg" alt="<project> logo" width="260"></p>`.
- Show the final render to the user with the chosen concept and palette in one line each, and mention that recolouring is just a find-and-replace on the two hex values.
