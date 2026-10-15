
#set page(
  paper: "a4",
  margin: (
    top: 1.7cm,
    bottom: 1.7cm,
    left: 2cm,
    right: 2cm,
  ),
)

#set text(
  font: "Lato",
  size: 10.5pt,
  fill: rgb("#243047"),
)

#set par(
  justify: true,
  leading: 0.65em,
)

#let accent = rgb("#3730a3")
#let muted = rgb("#64748b")

// --------------------------------------------------
// EDIT THESE DETAILS FOR EACH APPLICATION
// --------------------------------------------------

#let name = "YOUR FULL NAME"
#let job_title = "Mainframe Developer"

#let email = "your.email@example.com"
#let phone = "+49 XXX XXXXXXX"
#let location = "Your City, Germany"
#let linkedin = "linkedin.com/in/your-profile"

#let application_date = "15 October 2026"

#let company = "Company Name"
#let recipient = "Hiring Manager"
#let company_address = "Company Street and Number"
#let company_location = "Postal Code, City, Germany"

#let subject = "Application for the Mainframe Developer Position"
#let work_authorization = "Authorized to work in Germany"

// --------------------------------------------------
// HEADER
// --------------------------------------------------

#text(
  size: 23pt,
  weight: "bold",
  fill: accent,
)[#name]

#v(2pt)

#text(
  size: 11pt,
  weight: "medium",
  fill: muted,
)[#job_title]

#v(8pt)

#text(size: 9pt)[
  #email
  #h(5pt)
  #text(fill: muted)[|]
  #h(5pt)
  #phone
]

#text(size: 9pt)[
  #location
  #h(5pt)
  #text(fill: muted)[|]
  #h(5pt)
  #linkedin
]

#v(10pt)

#line(length: 100%, stroke: 1.2pt + accent)

#v(17pt)

// --------------------------------------------------
// RECIPIENT AND DATE
// --------------------------------------------------

#text(weight: "bold")[#recipient]

#company

#company_address

#company_location

#align(right)[#application_date]

#v(15pt)

// --------------------------------------------------
// SUBJECT
// --------------------------------------------------

#text(
  size: 11pt,
  weight: "bold",
  fill: accent,
)[#subject]

#v(14pt)

// --------------------------------------------------
// LETTER BODY
// Edit these paragraphs for the specific job.
// --------------------------------------------------

Dear Hiring Manager,

#v(8pt)

I am writing to apply for the Mainframe Developer position at #company. I bring over five years of IT experience, with a strong background in mainframe development, production support, batch processing, and troubleshooting. I am interested in contributing my technical skills and practical experience to your team.

#v(8pt)

My technical experience includes COBOL, JCL, DB2, CICS, VSAM, and mainframe environments. I have worked on development and support activities, investigated production issues, supported batch jobs, and contributed to reliable application processing. My experience across retail and healthcare projects has helped me understand the importance of accuracy, system stability, and timely issue resolution.

#v(8pt)

I am comfortable working with established processes, collaborating with team members, and following the software development life cycle. I also have experience with automation and technical troubleshooting. I am keen to continue developing my mainframe expertise and learn the tools and technologies required by your team.

#v(8pt)

I would welcome the opportunity to discuss how my experience and skills could contribute to your organization. Thank you for considering my application. I look forward to hearing from you.

#v(14pt)

Kind regards,

#v(18pt)

#text(weight: "bold", fill: accent)[#name]

#text(size: 9pt, fill: muted)[#work_authorization]

