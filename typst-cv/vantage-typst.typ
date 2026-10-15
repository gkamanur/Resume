
#let primary_colour = rgb("#3730a3")
#let link_colour = rgb("#12348e")
#let dark_colour = rgb("#202D50")
#let muted_colour = rgb("#5F687A")

#let icon(name, shift: 1.5pt) = {
  box(
    baseline: shift,
    height: 10pt,
    image("icons/" + name + ".svg")
  )
  h(3pt)
}

#let findMe(services) = {
  set text(8pt, fill: muted_colour)
  let contact_icon = icon.with(shift: 2.5pt)

  services.map(service => {
    contact_icon(service.name)

    if service.link == "" and "display" not in service.keys() {
      return
    }

    let content = if "display" in service.keys() {
      service.display
    } else {
      service.link
    }

    if service.link != "" {
      link(service.link)[#content]
    } else {
      content
    }
  }).join(h(8pt))
}

#let term(period, location) = {
  text(size: 8.5pt, fill: muted_colour)[
    #icon("calendar") #period
    #h(1fr)
    #icon("location") #location
  ]
}

#let max_rating = 5

#let skill(name, rating) = {
  name
  h(1fr)

  for i in range(1, max_rating + 1) {
    let colour = if i <= rating {
      primary_colour
    } else {
      rgb("#D8DCE5")
    }

    box(
      rect(
        width: 1.1em,
        height: 0.32em,
        fill: colour,
        stroke: none,
        radius: 1pt
      )
    )
  }

  linebreak()
}

#let styled-link(dest, content) = {
  if dest == "" {
    content
  } else {
    text(
      fill: link_colour,
      link(dest, content)
    )
  }
}

#let vantage(
  name: "",
  position: "",
  links: (),
  tagline: [],
  leftSide,
  rightSide
) = {
  set document(
    title: name + " - " + position,
    author: name
  )

  set page(
    paper: "a4",
    margin: (x: 1.25cm, y: 1.15cm)
  )

  set text(
    size: 9.3pt,
    font: "Liberation Sans",
    fill: rgb("#252A34")
  )

  set par(
    justify: false,
    leading: 0.62em
  )

  show heading.where(level: 1): it => {
    set text(size: 15pt, weight: "bold", fill: dark_colour)
    it
  }

  show heading.where(level: 2): it => {
    set text(size: 10.5pt, weight: "bold", fill: primary_colour)
    block(below: 5pt)[
      #it.body
      #v(2pt)
      #line(length: 100%, stroke: 0.65pt + primary_colour)
    ]
  }

  show heading.where(level: 3): it => {
    set text(size: 9.7pt, weight: "bold", fill: dark_colour)
    it
  }

  show heading.where(level: 4): it => {
    set text(size: 9.3pt, weight: "bold", fill: primary_colour)
    it
  }

  text(size: 24pt, weight: "bold", fill: dark_colour)[#name]

  v(2pt)

  text(size: 12pt, weight: "medium", fill: primary_colour)[
    #position
  ]

  v(5pt)
  findMe(links)

  v(5pt)
  if type(tagline) == array {
    for item in tagline {
      item
    }
  } else {
    tagline
  }

  v(4pt)

  grid(
    columns: (7fr, 4fr),
    column-gutter: 1.4em,
    leftSide,
    rightSide
  )
}
