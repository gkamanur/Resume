#import "vantage-typst.typ": vantage, job-entry, edu-entry, skill-entry, tag-list, as-list, field

#let configuration = yaml("/configuration.yaml")
#let contacts = field(configuration, "contacts", default: (:))
#let linkedin = field(contacts, "linkedin", default: (:))
#let email    = field(contacts, "email")

#let li-url = if type(linkedin) == str { linkedin } else { field(linkedin, "url") }
#let li-txt = if type(linkedin) == str { linkedin } else { field(linkedin, "displayText") }

#vantage(
  // ═══ LEFT COLUMN ═══
  [
    == Professional Experience

    #for job in as-list(field(configuration, "jobs", default: ())) {
      job-entry(job)
    }

    == Key Responsibilities

    #let responsibilities = as-list(field(configuration, "responsibilities", default: ()))
    #if responsibilities.len() > 0 { list(..responsibilities.map(p => [#p])) }

    == Education

    #for edu in as-list(field(configuration, "education", default: ())) {
      edu-entry(edu)
    }
  ],

  // ═══ RIGHT COLUMN (sidebar) ═══
  [
    == Career Objective

    #field(configuration, "objective")

    == Technical Expertise

    #for item in as-list(field(configuration, "technical_expertise", default: ())) {
      skill-entry(item)
    }

    == Additional Skills

    #tag-list(field(configuration, "skills", default: ()))

    == Tools

    #tag-list(field(configuration, "tools", default: ()))

    == Methodology

    #tag-list(field(configuration, "methodology", default: ()))

    == Certifications & Achievements

    #for a in as-list(field(configuration, "achievements", default: ())) {
      if type(a) == dictionary [
        === #field(a, "name")
        #text(size: 8.6pt, fill: rgb("#64748B"))[#field(a, "description")]
      ] else [
        - #a
      ]
    }
  ],

  name: field(contacts, "name"),
  position: field(configuration, "position"),

  links: (
    (
      name: "email",
      link: if email != "" { "mailto:" + email } else { "" },
      display: email,
    ),
    (name: "linkedin", link: li-url, display: li-txt),
    (name: "location", link: "", display: field(contacts, "address")),
    (name: "mobile",   link: "", display: field(contacts, "mobile")),
  ),

  tagline: field(configuration, "tagline", default: none),
)