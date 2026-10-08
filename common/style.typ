

#let apply = (body) => {

  show heading.where(level: 4): set heading(numbering: none)

  // ------ math settings ----------------------

  set math.equation(numbering: none)
  show math.equation: math.display

  set math.mat(delim: "[")
  set math.vec(delim: "[")

  // ------ END --------------------------------

  body
}
