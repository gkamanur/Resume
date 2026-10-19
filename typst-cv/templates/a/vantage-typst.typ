#import "/shared/theme.typ": body-font
// ─────────────────────────────────────────────────────
// Palette
// ─────────────────────────────────────────────────────
#let primary_colour = rgb("#4F46E5")
#let accent_colour  = rgb("#06B6D4")
#let dark_colour    = rgb("#0F172A")
#let muted_colour   = rgb("#64748B")
#let light_bg       = rgb("#F1F5F9")
#let hair_colour    = rgb("#E2E8F0")
#let track_colour   = rgb("#CBD5E1")

// Set to true only if you have icons/{email,linkedin,location,mobile,calendar}.svg
#let use_icons = false
#let max_rating = 5

// ─────────────────────────────────────────────────────
// Small utilities
// ─────────────────────────────────────────────────────
#let as-list(x) = {
  if x == none { () } else if type(x) == array { x } else { (x,) }
}

#let field(d, key, default: "") = {
  if type(d) == dictionary {
    let v = d.at(key, default: default)
    if v == none { default } else { v }
  } else { default }
}

// "company: Foo" and "company: {name: Foo}" both work
#let name-of(x) = {
  if type(x) == dictionary { field(x, "name") } else if x == none { "" } else { x }
}

#let date-range(start, end) = {
  if start != "" and end != "" { [#start – #end] }
  else if start != "" { [#start] }
  else if end != "" { [#end] }
  else { [] }
}

// ─────────────────────────────────────────────────────
// Icons & contact chips
// ─────────────────────────────────────────────────────
#let dot = box(width: 3pt, height: 3pt, radius: 50%, fill: accent_colour, baseline: -1.3pt)

#let icon(name, shift: 1.5pt) = {
  if use_icons {
    box(baseline: shift, height: 10pt, image("icons/" + name + ".svg"))
    h(3pt)
  }
}

#let findMe(services) = {
  set text(size: 8.3pt, fill: muted_colour, weight: "medium")
  let items = ()
  for service in as-list(services) {
    let url     = field(service, "link")
    let display = field(service, "display")
    let name    = field(service, "name")
    let shown = if type(service) == str { service }
      else if display != "" { display }
      else if url != "" { url }
      else { name }
    if shown == "" { continue }
    let marker = if use_icons and name != "" { icon(name, shift: 2.2pt) } else { [#dot#h(3pt)] }
    items.push(box[#marker#if url != "" { link(url)[#shown] } else { shown }])
  }
  items.join([ #h(10pt)])
}

// ─────────────────────────────────────────────────────
// Date / location line
// ─────────────────────────────────────────────────────
#let term(period, location) = {
  set text(size: 8.2pt, fill: muted_colour, weight: "medium")
  grid(
    columns: (1fr, auto),
    column-gutter: 8pt,
    align: (left, right),
    [#icon("calendar")#period],
    [#icon("location")#location],
  )
}

// ─────────────────────────────────────────────────────
// Skill bar (accepts 0–5, 0–10 or 0–100)
// ─────────────────────────────────────────────────────
#let skill(name, rating) = {
  let r = if type(rating) in (int, float) { rating } else { 0 }
  if r > 10 { r = r / 20 } else if r > max_rating { r = r / 2 }
  r = calc.clamp(calc.round(r), 0, max_rating)

  grid(
    columns: (1fr, auto),
    column-gutter: 6pt,
    align: (left + horizon, right + horizon),
    text(size: 8.8pt)[#name],
    stack(
      dir: ltr,
      spacing: 2pt,
      ..range(max_rating).map(i => rect(
        width: 11pt,
        height: 4pt,
        radius: 2pt,
        stroke: none,
        fill: if i < r { primary_colour } else { track_colour },
      )),
    ),
  )
}

#let skill-entry(x) = block(width: 100%, above: 0pt, below: 5pt, {
  if type(x) == dictionary {
    skill(field(x, "name"), field(x, "level", default: field(x, "rating", default: 0)))
  } else {
    text(size: 8.8pt)[#x]
  }
})

// ─────────────────────────────────────────────────────
// Tag list (compact chips instead of long bullet lists)
// ─────────────────────────────────────────────────────
#let tag-list(items) = {
  let tags = as-list(items).map(t => box(
    fill: white,
    stroke: 0.5pt + track_colour,
    radius: 3pt,
    inset: (x: 4.5pt, y: 2.4pt),
    text(size: 8pt)[#t],
  ))
  block(width: 100%, above: 0pt, below: 4pt)[
    #set par(leading: 4.5pt)
    #tags.join[ ]
  ]
}

// ─────────────────────────────────────────────────────
// Entry header (accent rule + title + subtitle + meta)
// ─────────────────────────────────────────────────────
#let entry-header(title, subtitle: none, meta: none, accent: primary_colour) = block(
  width: 100%,
  breakable: false,
  above: 0pt,
  below: 0pt,
  stroke: (left: 2.2pt + accent),
  inset: (left: 7pt, y: 1pt),
  {
    text(size: 9.8pt, weight: "bold", fill: dark_colour)[#title]
    if subtitle != none and subtitle != "" {
      h(5pt)
      text(size: 9pt, weight: "medium", fill: primary_colour)[#subtitle]
    }
    if meta != none {
      v(2pt)
      meta
    }
  },
)

// ─────────────────────────────────────────────────────
// Entry builders
// ─────────────────────────────────────────────────────
#let job-entry(job) = {
  entry-header(
    field(job, "position"),
    subtitle: name-of(field(job, "company")),
    meta: term(
      date-range(field(job, "from"), field(job, "to")),
      field(job, "location"),
    ),
  )
  v(3pt)
  let points = as-list(field(job, "description", default: ()))
  if points.len() > 0 { list(..points.map(p => [#p])) }
  v(7pt)
}

#let edu-entry(edu) = {
  let major = field(edu, "major")
  entry-header(
    field(edu, "degree"),
    subtitle: name-of(field(edu, "place")),
    accent: accent_colour,
    meta: {
      if major != "" {
        text(size: 8.6pt, fill: dark_colour)[#major]
        v(1pt)
      }
      term(date-range(field(edu, "from"), field(edu, "to")), field(edu, "location"))
    },
  )
  v(6pt)
}

// ─────────────────────────────────────────────────────
// Main document skeleton
// ─────────────────────────────────────────────────────
#let vantage(
  leftSide,
  rightSide,
  name: "",
  position: "",
  links: (),
  tagline: none,
  sidebar_width: 6.7cm,
) = {
  set document(title: [#name — #position], author: name)
  set page(paper: "a4", margin: (x: 1.2cm, y: 1.1cm), fill: white)
  set text(
    size: 8.9pt,
    font: body-font,
    fill: dark_colour,
    lang: "en",
  )
  set par(justify: false, leading: 0.6em, spacing: 0.7em)
  set list(
    marker: text(fill: primary_colour)[•],
    indent: 1pt,
    body-indent: 5pt,
    spacing: 4pt,
  )

  // ── Headings ──
  show heading.where(level: 2): it => block(above: 11pt, below: 6pt, width: 100%)[
    #set text(size: 10.4pt, weight: "bold", tracking: 0.4pt)
    #grid(
      columns: (4pt, 1fr),
      column-gutter: 6pt,
      align: left + horizon,
      rect(
        width: 4pt,
        height: 11pt,
        radius: 1.5pt,
        fill: gradient.linear(primary_colour, accent_colour, angle: 90deg),
      ),
      upper(it.body),
    )
    #v(1pt)
    #line(length: 100%, stroke: 0.6pt + primary_colour.lighten(60%))
  ]

  show heading.where(level: 3): it => {
    set text(size: 9.4pt, weight: "bold", fill: dark_colour)
    block(above: 7pt, below: 5pt, it.body)
  }

  show heading.where(level: 4): it => {
    set text(size: 9.2pt, weight: "bold", fill: primary_colour)
    block(above: 3pt, below: 1pt, it.body)
  }

  // ── Header banner ──
  grid(
    columns: (5pt, 1fr),
    column-gutter: 12pt,
    align: (left + horizon, left),
    rect(
      width: 5pt,
      height: 46pt,
      radius: 2.5pt,
      fill: gradient.linear(primary_colour, accent_colour, angle: 90deg),
    ),
    [
      #text(size: 24pt, weight: "bold", tracking: -0.3pt)[#name]
      #v(4pt)
      #box(
        fill: primary_colour.lighten(93%),
        stroke: 0.7pt + primary_colour.lighten(72%),
        radius: 4pt,
        inset: (x: 8pt, y: 3.2pt),
      )[#text(size: 10pt, weight: "bold", fill: primary_colour)[#position]]
    ],
  )

  v(9pt)
  findMe(links)

  if tagline != none and tagline != [] and tagline != "" {
    v(6pt)
    block(width: 100%)[
      #set text(size: 9.2pt)
      #if type(tagline) == array { tagline.join(linebreak()) } else { tagline }
    ]
  }

  v(6pt)
  line(length: 100%, stroke: 0.55pt + hair_colour)
  v(8pt)

  // ── Two-column body: main column + tinted sidebar ──
  grid(
    columns: (1fr, sidebar_width),
    column-gutter: 0pt,
    grid.cell(inset: (right: 14pt), leftSide),
    grid.cell(fill: light_bg, inset: (x: 10pt, y: 8pt), rightSide),
  )
}