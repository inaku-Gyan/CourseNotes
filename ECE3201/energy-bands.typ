// Native vector diagrams; coordinates describe energy, not spatial position.
#let electron-color = rgb("235789")
#let transition-color = rgb("b85b22")
#let band-stroke = 0.7pt + rgb("52616b")

#let at(x, y, body) = place(top + left, dx: x * 1mm, dy: y * 1mm, body)
#let label(x, y, body, width: 48mm) = at(x, y, box(width: width, body))
#let segment(x, y, dx, dy, stroke: band-stroke) = at(x, y, line(
  start: (0pt, 0pt),
  end: (dx * 1mm, dy * 1mm),
  stroke: stroke,
))
#let up-arrow(x, bottom, top, color: transition-color, both: false) = {
  let stroke = 0.8pt + color
  segment(x, bottom, 0, top - bottom, stroke: stroke)
  segment(x, top, -1, 1.8, stroke: stroke)
  segment(x, top, 1, 1.8, stroke: stroke)
  if both {
    segment(x, bottom, -1, -1.8, stroke: stroke)
    segment(x, bottom, 1, -1.8, stroke: stroke)
  }
}
#let carrier(x, y, hole: false) = at(x - 1, y - 1, circle(
  radius: 1mm,
  fill: if hole { white } else { electron-color },
  stroke: 0.8pt + electron-color,
))

#let panel(kind) = {
  set text(size: 9pt)
  let intrinsic = kind in ("zero", "warm")
  box(width: 72mm, height: 73mm)[
    #label(10, 0, strong(if kind == "zero" { [(a) $T = 0 thin "K"$] } else if kind == "warm" {
      [(b) $T > 0 thin "K"$]
    } else if kind == "n" { [(a) n-type] } else { [(b) p-type] }))
    #label(0, 7, [$E$], width: 8mm)
    #up-arrow(3, 68, 14, color: black)
    #at(10, 14, rect(width: 49mm, height: 14mm, fill: rgb("eaf2fa"), stroke: none))
    #at(10, 48, rect(width: 49mm, height: 19mm, fill: rgb("eef3e7"), stroke: none))
    #segment(10, 28, 49, 0)
    #segment(10, 48, 49, 0)
    #label(61, 26, [$E_C$], width: 11mm)
    #label(61, 46, [$E_V$], width: 11mm)
    #label(12, 15, [Conduction band])
    #label(12, 61, [Valence band])
    #if intrinsic {
      label(21, 34, align(center, [Forbidden band]), width: 20mm)
      up-arrow(55, 48, 28, color: rgb("52616b"), both: true)
      label(58, 37, [$E_g$], width: 12mm)
    }
    #if kind == "warm" {
      for x in (16, 44) {
        up-arrow(x, 53.5, 24.5)
        carrier(x, 23)
      }
    } else if kind == "n" {
      segment(10, 33, 49, 0, stroke: (paint: transition-color, thickness: 0.8pt, dash: "dashed"))
      label(61, 31, [$E_D$], width: 11mm)
      for x in (16, 44) {
        up-arrow(x, 33, 24.5)
        carrier(x, 23)
      }
    } else if kind == "p" {
      segment(10, 43, 49, 0, stroke: (paint: transition-color, thickness: 0.8pt, dash: "dashed"))
      label(61, 41, [$E_A$], width: 11mm)
      for x in (16, 44) {
        up-arrow(x, 53.5, 44.5)
        carrier(x, 43)
      }
    }
    #for x in (16, 23, 30, 37, 44, 51) {
      carrier(x, 55, hole: kind in ("warm", "p") and x in (16, 44))
    }
  ]
}

#let legend = {
  set text(size: 9pt)
  align(center)[
    #box(circle(radius: 1mm, fill: electron-color, stroke: none)) Electron
    #h(4mm)
    #box(circle(radius: 1mm, fill: white, stroke: 0.8pt + electron-color)) Hole
    #h(4mm)
    #text(fill: transition-color)[↑] Electron excitation
  ]
}

#let intrinsic-bands = figure(
  {
    grid(
      columns: (1fr, 1fr),
      gutter: 3mm,
      align: center,
      panel("zero"), panel("warm"),
    )
    legend
    v(1mm)
    align(center, text(size: 9pt)[$E_g = E_C - E_V$; thermal excitation creates electron–hole pairs ($n = p$).])
  },
  caption: [Intrinsic semiconductor energy bands.],
)

#let doped-bands = figure(
  {
    grid(
      columns: (1fr, 1fr),
      gutter: 3mm,
      align: center,
      panel("n"), panel("p"),
    )
    legend
    v(1mm)
    align(center, text(size: 9pt)[Room temperature; shallow dopants approximately fully ionized.])
  },
  caption: [Doped semiconductor energy bands.],
)
