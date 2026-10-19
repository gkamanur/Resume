// Template C — nabcv two-column layout.
// Reads the SAME /configuration.yaml as templates a and b and maps it onto
// the fields nabcv expects. Compile with `--root` set to the project root.
#import "vendor/nabcv/cv.typ": cv

#let configuration = yaml("/configuration.yaml")

// ─────────────────────────────────────────────────────
// Tiny helpers (safe against missing keys / wrong types)
// ─────────────────────────────────────────────────────
#let get(d, key, default: none) = {
  if type(d) == dictionary {
    let v = d.at(key, default: default)
    if v == none or v == "" { default } else { v }
  } else { default }
}

#let lst(x) = if x == none { () } else if type(x) == array { x } else { (x,) }

#let name-of(x) = {
  if type(x) == dictionary { get(x, "name", default: "") }
  else if x == none { "" }
  else { str(x) }
}

// YAML folded text (`>`) ends with a newline; trim it. Empty → none.
#let txt(x) = {
  if type(x) == str {
    let t = x.trim()
    if t == "" { none } else { t }
  } else { x }
}

#let or-none(x) = if x == "" or x == () { none } else { x }

// ─────────────────────────────────────────────────────
// Map configuration.yaml → nabcv fields
// ─────────────────────────────────────────────────────
#let contacts = get(configuration, "contacts", default: (:))

#let profile(network, node) = {
  let url = if type(node) == str { node } else { get(node, "url", default: "") }
  let shown = if type(node) == str { node } else { get(node, "displayText", default: url) }
  if url == "" { () } else { ((network: network, url: url, display: shown),) }
}

#let profiles = (
  ..profile("LinkedIn", get(contacts, "linkedin")),
  ..profile("GitHub", get(contacts, "github")),
  ..profile("Website", get(contacts, "website")),
)

#let experience = lst(get(configuration, "jobs")).map(job => (
  company: name-of(get(job, "company")),
  position: get(job, "position"),
  summary: or-none(name-of(get(job, "product"))),
  location: get(job, "location"),
  start_date: get(job, "from"),
  end_date: get(job, "to"),
  highlights: lst(get(job, "description")),
))

#let education = lst(get(configuration, "education")).map(edu => (
  company: get(edu, "degree", default: ""),
  position: get(edu, "major"),
  summary: or-none(name-of(get(edu, "place"))),
  location: get(edu, "location"),
  start_date: get(edu, "from"),
  end_date: get(edu, "to"),
  highlights: (),
))

#let expertise-names = (
  lst(get(configuration, "technical_expertise"))
    .map(x => if type(x) == dictionary { get(x, "name", default: "") } else { str(x) })
    .filter(x => x != "")
)

#let strs(x) = lst(x).map(i => str(i))

#let skills = (
  (group: "Technical Expertise", items: expertise-names.join(", ")),
  (group: "Additional Skills", items: strs(get(configuration, "skills"))),
  (group: "Tools", items: strs(get(configuration, "tools"))),
  (group: "Methodology", items: strs(get(configuration, "methodology"))),
).filter(g => g.items != "" and g.items != ())

#let awards = lst(get(configuration, "achievements")).map(a => {
  if type(a) == dictionary {
    (name: get(a, "name", default: ""), date: "", summary: txt(get(a, "description")))
  } else { (name: str(a), date: "") }
})

#show: cv.with(
  name: get(contacts, "name", default: ""),
  headline: get(configuration, "position"),
  location: get(contacts, "address"),
  keywords: or-none(get(configuration, "keywords", default: expertise-names)),
  email: get(contacts, "email"),
  phone: get(contacts, "mobile"),
  profiles: or-none(profiles),
  summary: txt(get(configuration, "tagline")),
  motivation: txt(get(configuration, "objective")),
  experience: or-none(experience),
  responsibilities: or-none(strs(get(configuration, "responsibilities"))),
  education: or-none(education),
  awards: or-none(awards),
  skills: or-none(skills),

  profiles-config: (
    LinkedIn: (icon: "linkedin", url-base: ""),
    GitHub: (icon: "github", url-base: ""),
    Website: (icon: "globe", url-base: ""),
  ),
  skill-icons: (
    "Technical Expertise": "terminal",
    "Additional Skills": "gears",
    "Tools": "screwdriver-wrench",
    "Methodology": "diagram-project",
  ),
  section-titles: (
    motivation: "CAREER OBJECTIVE",
    awards: "CERTIFICATIONS & ACHIEVEMENTS",
  ),
)
