

#let apply = (body) => {

  show heading.where(level: 4): set heading(numbering: none)

  set math.equation(numbering: none)
  show math.equation: math.display

  body
}
