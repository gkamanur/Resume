
#import "vantage-typst.typ": vantage, term, skill, styled-link

#let configuration = yaml("configuration.yaml")

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

    - COBOL application development and maintenance.
    - JCL batch processing and job troubleshooting.
    - DB2 SQL data processing and application support.
    - Production incident investigation and resolution.
    - Application testing, automation and reporting.
  ],

  [
    == Career Objective

    #configuration.objective

    == Technical Expertise

    #for expertise in configuration.technical_expertise [
      #skill(expertise.name, expertise.level)
      #v(3pt)
    ]

    == Additional Skills

    #for item in configuration.skills [
      - #item
    ]

    == Tools

    #for tool in configuration.tools [
      - #tool
    ]

    == Education

    #for edu in configuration.education [
      === #edu.degree

      #edu.place.name

      #edu.major

      #edu.from — #edu.to

      #edu.location
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
  ],
)
