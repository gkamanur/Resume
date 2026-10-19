// Shared helpers for the "Languages" section (templates a, b and c).
// configuration.yaml entries look like:
//   - name: "German"
//     level: "B1"                  # A1 A2 B1 B2 C1 C2 or "Native"
//     label: "Intermediate"        # optional; overrides the default wording

#let cefr-labels = (
  A1: "Beginner",
  A2: "Elementary",
  B1: "Intermediate",
  B2: "Upper-intermediate",
  C1: "Advanced",
  C2: "Proficient",
  Native: "Native",
)

// Wording shown next to the level. Falls back to the level itself.
#let level-label(entry) = {
  let lbl = entry.at("label", default: "")
  if lbl != "" { return lbl }
  cefr-labels.at(str(entry.at("level", default: "")), default: "")
}

// Highlighted language name (bold + colour). Used by templates a, b and c.
#let lang-name(name, colour: none) = {
  if colour == none { text(weight: "bold")[#name] }
  else { text(weight: "bold", fill: colour)[#name] }
}

// "German – B1 (Intermediate)" with the name highlighted (used by template c).
#let language-line(entry, colour: none) = {
  let lvl = str(entry.at("level", default: ""))
  let lbl = level-label(entry)
  let name = lang-name(entry.at("name", default: ""), colour: colour)
  if lvl == "" { name }
  else if lbl == "" or lbl == lvl [#name – #lvl]
  else if lvl == "Native" [#name – Native]
  else [#name – #lvl (#lbl)]
}