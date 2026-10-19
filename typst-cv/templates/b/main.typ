
#import "vantage-typst.typ": vantage, term, skill, language, styled-link

#let configuration = yaml("/configuration.yaml")

#vantage(
  name: configuration.contacts.name,
  position: configuration.position,

  links: (
    (
      name: "email",
      link: "mailto:" + configuration.contacts.email,
      display: configuration.contacts.email,
    ),
    (
      name: "linkedin",
      link: configuration.contacts.linkedin.url,
      display: configuration.contacts.linkedin.displayText,
    ),
    (
      name: "location",
      link: "",
      display: configuration.contacts.address,
    ),
    (
      name: "mobile",
      link: "",
      display: configuration.contacts.mobile,
    ),
  ),

  tagline: configuration.tagline,

  [
    == Professional Experience

    #for job in configuration.jobs [
      === #job.position

      #job.company.name

      #term(job.from + " — " + job.to, job.location)

      #for point in job.description [
        - #point
      ]

      #v(5pt)
    ]

    == Key Responsibilities

    #for point in configuration.at("responsibilities", default: ()) [
      - #point
    ]
  ],

  [
    == Career Objective

    #configuration.objective

    == Technical Expertise

    #for expertise in configuration.technical_expertise [
      #skill(expertise.name, expertise.level)
      #v(3pt)
    ]

    #let languages = configuration.at("languages", default: ())
    #if languages.len() > 0 [
      == Languages

      #for entry in languages [
        #language(entry)
        #v(3pt)
      ]
    ]

    == Additional Skills

    #for item in configuration.skills [
      - #item
    ]

    == Tools

    #for tool in configuration.tools [
      - #tool
    ]

    == Methodology

    #for method in configuration.methodology [
      - #method
    ]

    == Certifications & Achievements

    #for achievement in configuration.achievements [
      === #achievement.name

      #achievement.description
    ]

    == Education

    #for edu in configuration.education [
      === #edu.degree

      #edu.place.name

      #edu.major

      #edu.from — #edu.to

      #edu.location
    ]

  ],
)
