#import "@preview/ilm:2.1.1": *

#set text(lang: "en")

#show: ilm.with(
  title: [ECE 3060\ Introduction to Robotics],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 09, day: 21),
)

#set math.equation(numbering: none)

#let Vec(v, f: none) = $attach(accent(#v, arrow), tl: #f)$
#let UVec(v, f: none) = $attach(accent(#v, hat), tl: #f)$

#let Mat(M) = $upright(bold(#M))$

#let Rm(target, f: none) = $attach(Mat(R), tl: #f, br: #target)$

#let Rot(angle, axis) = $op("Rot")_(#axis)(#angle)$

= Frames and Transformations

== Vectors and Coordinate Frames

- Coordinate Frames
- Cartesian Coordinate Frames

The coordinates of a vector $Vec(p)$ w.r.t. a coordinate frame $Sigma$:
$quad Vec(p, f: Sigma)$

=== Rotation Matrix

Suppose $A$ and $B$ are two orthogonal coordinate frames with the same origin.

#align(center, image("assets/Frame A and B.png", width: 30%))

The rotation matrix of frame $B$ w.r.t. frame $A$ is given by:
$
  Rm(B, f: A) = mat(
    bar, bar, bar;
    UVec(x, f: A)_B, UVec(y, f: A)_B, UVec(z, f: A)_B;
    bar, bar, bar
  )
  quad quad quad quad quad quad quad
  Rm(B, f: A) Vec(p, f: B) = Vec(p, f: A)
$
where the columns are the unit direction vectors of the axes of frame $B$ expressed in frame $A$.

Rotation matrices are *orthogonal* matrices, i.e.,
$ Mat(R)^(-1) = Mat(R)^top $

- _Tip:_
$
  Vec(p, f: B) & = mat(
                   bar.h, UVec(x, f: A)_B, bar.h;
                   bar.h, UVec(y, f: A)_B, bar.h;
                   bar.h, UVec(z, f: A)_B, bar.h;
                 )                                & Vec(p, f: A) \
               & = quad quad (Rm(B, f: A))^top    & Vec(p, f: A) \
               & = quad quad space.en Rm(A, f: B) & Vec(p, f: A)
$

=== Fundamental Rotations

- Rotations about a single axis.

#align(center, grid(
  align: center + horizon,
  columns: (1fr, 1fr),
  row-gutter: 3em,
  [About the $x$-axis],
  [
    $
      quad Rot(phi.alt, x) = mat(
        1, 0, 0;
        0, cos phi.alt, -sin phi.alt;
        0, sin phi.alt, cos phi.alt;
      )
    $
  ],

  [About the $y$-axis],
  [
    $
      quad Rot(phi.alt, y) = mat(
        cos phi.alt, 0, sin phi.alt;
        0, 1, 0;
        -sin phi.alt, 0, cos phi.alt;
      )
    $
  ],

  [About the $z$-axis],
  [
    $
      quad Rot(phi.alt, z) = mat(
        cos phi.alt, -sin phi.alt, 0;
        sin phi.alt, cos phi.alt, 0;
        0, 0, 1;
      )
    $
  ],
))
