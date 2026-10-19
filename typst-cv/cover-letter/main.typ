// Cover letter. Letter content: cover-letter.yaml (this folder).
// Sender details: /configuration.yaml (shared with the CV templates).
// Compile with `--root` set to the project root.
#import "/shared/theme.typ": body-font
#let letter-data = yaml("cover-letter.yaml")
#let configuration = yaml("/configuration.yaml")

#let get(d, key, default: "") = {
  if type(d) == dictionary {
    let v = d.at(key, default: default)
    if v == none { default } else { v }
  } else { default }
}

// ── Data ──
#let contacts = get(configuration, "contacts", default: (:))
#let sender = get(letter-data, "sender", default: (:))
#let pick(key, fallback) = {
  let v = get(sender, key)
  if v != "" { v } else { fallback }
}

#let linkedin-node = get(contacts, "linkedin")
#let linkedin-url = if type(linkedin-node) == str { linkedin-node } else { get(linkedin-node, "url") }
#let linkedin-default = if type(linkedin-node) == str { linkedin-node } else {
  get(linkedin-node, "displayText", default: linkedin-url)
}

#let name = pick("name", get(contacts, "name"))
#let job_title = pick("title", get(contacts, "title", default: get(configuration, "position")))
#let email = pick("email", get(contacts, "email"))
#let phone = pick("phone", get(contacts, "mobile"))
#let location = pick("location", get(contacts, "address"))
#let linkedin = pick("linkedin", linkedin-default)
#let linkedin-link = if get(sender, "linkedin") == "" { linkedin-url } else { "" }

#let recipient = get(letter-data, "recipient", default: (:))
#let company = get(recipient, "company")
#let application_date = {
  let d = get(letter-data, "date")
  if d != "" { d } else { datetime.today().display("[day] [month repr:long] [year]") }
}

// ── Palette ──
#let primary = rgb("#4F46E5")
#let accent = rgb("#06B6D4")
#let dark = rgb("#0F172A")
#let body-colour = rgb("#1E293B")
#let muted = rgb("#64748B")
#let hair = rgb("#E2E8F0")

// ── Page and text ──
#set document(title: "Cover Letter — " + name, author: name)
#set page(
  paper: "a4",
  margin: (top: 1.8cm, bottom: 2.4cm, left: 2.2cm, right: 2.2cm),
  footer: context {
    set text(size: 8pt, fill: muted)
    line(length: 100%, stroke: 0.5pt + hair)
    v(3pt)
    align(center)[
      #name
      #h(6pt)#text(fill: primary)[·]#h(6pt)
      #email
      #if phone != "" [#h(6pt)#text(fill: primary)[·]#h(6pt)#phone]
    ]
  },
)
#set text(
  font: body-font,
  size: 10.3pt,
  fill: body-colour,
  lang: "en",
  hyphenate: false,
)
#set par(justify: true, leading: 0.72em)
#show link: set text(fill: primary)

#let gradient-bar(h) = rect(
  width: 4.5pt,
  height: h,
  radius: 2pt,
  fill: gradient.linear(primary, accent, angle: 90deg),
)

// ── Header: identity left, contact details right ──
#grid(
  columns: (4.5pt, 1fr, auto),
  column-gutter: 12pt,
  align: (left + horizon, left + horizon, right + horizon),
  gradient-bar(48pt),
  [
    #set par(spacing: 0pt, leading: 0.4em)
    #text(size: 22pt, weight: "bold", fill: dark, tracking: -0.2pt)[#name]
    #v(8pt)
    #text(size: 10.5pt, weight: "medium", fill: primary)[#job_title]
  ],
  {
    set text(size: 8.8pt, fill: muted)
    set par(leading: 0.55em, spacing: 0.55em, justify: false)
    align(right)[
      #if email != "" [#link("mailto:" + email)[#email] \ ]
      #if phone != "" [#phone \ ]
      #if location != "" [#location \ ]
      #if linkedin != "" {
        if linkedin-link != "" { link(linkedin-link)[#linkedin] } else { linkedin }
      }
    ]
  },
)

#v(10pt)
#line(length: 100%, stroke: 0.8pt + primary.lighten(55%))
#v(16pt)

// ── Recipient (left) and date (right) ──
#let recipient-lines = (
  (get(recipient, "name"), true),
  (company, false),
  (get(recipient, "address"), false),
  (get(recipient, "location"), false),
).filter(l => l.at(0) != "")

#grid(
  columns: (1fr, auto),
  align: (left + top, right + top),
  {
    set par(leading: 0.6em, spacing: 0.6em, justify: false)
    for (i, l) in recipient-lines.enumerate() {
      if l.at(1) { text(weight: "bold", fill: dark)[#l.at(0)] } else { l.at(0) }
      if i < recipient-lines.len() - 1 { linebreak() }
    }
  },
  text(fill: muted)[#application_date],
)

#v(22pt)

// ── Subject ──
#block(below: 14pt)[
  #text(size: 11.5pt, weight: "bold", fill: dark)[#get(letter-data, "subject")]
  #v(4pt)
  #line(length: 2.2cm, stroke: 1.6pt + primary)
]

// ── Body ──
#block(below: 12pt)[#get(letter-data, "salutation", default: "Dear Hiring Manager,")]

#for para in get(letter-data, "body", default: ()) {
  para.replace("{company}", company)
  parbreak()
  v(2pt)
}

// ── Closing and signature ──
#v(8pt)
#block(breakable: false)[
  #set par(spacing: 0pt, leading: 0.85em, justify: false)
  #get(letter-data, "closing", default: "Kind regards,")
  #v(30pt)
  #text(size: 11pt, weight: "bold", fill: dark)[#name] \
  #text(size: 9pt, fill: muted)[#job_title]
  #let wa = get(letter-data, "work_authorization")
  #if wa != "" [ \ #text(size: 9pt, fill: muted)[#wa]]
]
