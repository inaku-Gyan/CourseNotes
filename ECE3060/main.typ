#import "@preview/ilm:2.1.1": *
#import "../common/style.typ"

#show: ilm.with(
  title: [ECE 3060\ Introduction to Robotics],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 09, day: 21),
)

#show: style.apply

#let Vec(v, f: none) = $attach(arrow(#v), tl: #f)$
#let UVec(v, f: none) = $attach(hat(#v), tl: #f)$

#let Mat(M, f: none) = $attach(upright(bold(#M)), tl: #f)$

#let Rm(target, f: none) = $attach(Mat(R, f: #f), br: #target)$

#let Rot(angle, axis) = $op("Rot")_(#axis)(#angle)$

= Frames and Transformations

== Vectors and Coordinate Frames

- Coordinate Frames
- Cartesian Coordinate Frames

The coordinates of a vector $Vec(p)$ w.r.t. a coordinate frame $Sigma$:
$quad Vec(p, f: Sigma)$

$
  Vec(p) = c_1 Vec(x)_Sigma + c_2 Vec(y)_Sigma + c_3 Vec(z)_Sigma
  = mat(
    bar, bar, bar;
    Vec(x)_Sigma, Vec(y)_Sigma, Vec(z)_Sigma;
    bar, bar, bar;
    delim: "["
  )
  vec(c_1, c_2, c_3, delim: "[")
  = Mat(E)_Sigma Vec(p, f: Sigma)
$
where $Vec(x)_Sigma$, $Vec(y)_Sigma$, and $Vec(z)_Sigma$ are the basis vectors of the frame $Sigma$
and they are linearly independent (orthonormal for Cartesian $Sigma$).
$Vec(x)_Sigma$, $Vec(y)_Sigma$, $Vec(z)_Sigma$, and $Vec(p)$ are independent of coordinate frames.


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

$
  Vec(p, f: A) & = mat(
                   bar.h, UVec(x, f: B)_A, bar.h;
                   bar.h, UVec(y, f: B)_A, bar.h;
                   bar.h, UVec(z, f: B)_A, bar.h;
                 )                                & Vec(p, f: B) \
               & = quad quad (Rm(A, f: B))^top    & Vec(p, f: B) \
               & = quad quad space.en Rm(B, f: A) & Vec(p, f: B)
$

=== Fundamental Rotations

i.e., rotations about a single axis.

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
