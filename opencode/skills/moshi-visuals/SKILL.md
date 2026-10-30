---
name: moshi-visuals
description: Show a chart, diagram, table, report or mockup inline in the user's Moshi chat as an HTML page. Use when a visual would make your answer clearer than text.
user-invocable: false
---

# Inline visuals in Moshi

Moshi shows an HTML page inside your reply. Use one whenever a visual makes the answer clearer: charts, diagrams, comparisons, timelines, UI mockups.

## Writing the page

- Save it in `~/.moshi/visuals/` (create the folder if needed). Use one complete HTML file per visual, directly in that folder, under 512 KB, with a new file name each time (e.g. `latency-by-region-7c1e.html`).
- Inline your styles, scripts and data. Libraries and fonts may load only from cdn.jsdelivr.net, unpkg.com, cdnjs.cloudflare.com, esm.sh, fonts.googleapis.com and fonts.gstatic.com. The page can't make network requests; use inline SVG or `data:` URLs for images.
- Don't size anything to the viewport height (`100vh`); Moshi fits the frame to your content. Width is the chat column (about 700px, narrower on small windows).
- Moshi's theme colors are available as CSS variables: `--background`, `--foreground`, `--muted-foreground`, `--border`, `--primary`, `--chart-1` to `--chart-5`. Use them so the page matches light and dark themes.

## Showing it

After the file exists, put this on its own line in your reply, outside any code block, with the file's absolute path (expand `~`):

::moshi-visual{file="/Users/me/.moshi/visuals/latency-by-region-7c1e.html" title="Latency by region"}

`title` is optional. Keep the explanation in your reply text; the visual supports it.
