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
#let Tm(target, f: none) = $attach(Mat(T, f: #f), br: #target)$

#let Rot(angle, axis) = $op("Rot")_(#axis)(#angle)$

= Frames and Transformations

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
  )
  vec(c_1, c_2, c_3)
  = Mat(E)_Sigma Vec(p, f: Sigma)
$
where $Vec(x)_Sigma$, $Vec(y)_Sigma$, and $Vec(z)_Sigma$ are the basis vectors of the frame $Sigma$
and they are linearly independent (orthonormal for Cartesian $Sigma$).
$Vec(x)_Sigma$, $Vec(y)_Sigma$, $Vec(z)_Sigma$, and $Vec(p)$ are independent of coordinate frames.


== Rotation Matrix

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
$
  Mat(R)^(-1) = Mat(R)^top
  quad quad quad quad
  Vec(p, f: A) & = mat(
                   bar.h, UVec(x, f: B)_A, bar.h;
                   bar.h, UVec(y, f: B)_A, bar.h;
                   bar.h, UVec(z, f: B)_A, bar.h;
                 )                                & Vec(p, f: B) \
               & = quad quad (Rm(A, f: B))^top    & Vec(p, f: B) \
               & = quad quad space.en Rm(B, f: A) & Vec(p, f: B)
$

==== Constraints and Properties

#grid(
  columns: (1fr, 2fr),
  [
    For any $Mat(R) = mat(bar, bar, bar; Vec(x), Vec(y), Vec(z); bar, bar, bar)$:
  ],
  [
    - $det(Mat(R)) = 1$
    - $Vec(x) dot Vec(y) = 0, quad Vec(x) dot Vec(z) = 0, quad Vec(y) dot Vec(z) = 0$
    - $Vec(x) times Vec(y) = Vec(z), quad Vec(y) times Vec(z) = Vec(x), quad Vec(z) times Vec(x) = Vec(y)$
    - $norm(Vec(x)) = 1, quad norm(Vec(y)) = 1, quad norm(Vec(z)) = 1$
  ],
)

=== Arithmetic

$
  Rm(A, f: C) = Rm(B, f: C) Rm(A, f: B)
  quad quad quad quad Rm(A, f: B)^top = Rm(A, f: B)^(-1) = Rm(B, f: A)
$

If frame $C$ is obtained by rotating frame $B$ by $text(Mat(R), fill: #blue)$ w.r.t. frame $B$, then
$
  Rm(C, f: A) = Rm(B, f: A) text(Mat(R), fill: #blue)
  quad quad "and" quad quad
  Rm(C, f: B) = text(Mat(R), fill: #blue)
$

If frame $C$ is obtained by rotating frame $B$ by $text(Mat(R), fill: #blue)$ w.r.t. frame $A$, then
$
  quad quad quad quad quad
  Rm(C, f: A) = text(Mat(R), fill: #blue) Rm(B, f: A)
  quad quad "and" quad quad
  Rm(C, f: B) = Rm(B, f: A)^(-1) text(Mat(R), fill: #blue) Rm(B, f: A)
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

=== Equivalent Angle-Axis

Any rotation matrix can be represented by a rotation of angle $phi.alt$ about an equivalent axis $Vec(u)$,
and $(Vec(u), phi.alt)$ is called the *equivalent angle-axis* of the rotation matrix.

For $quad Vec(u) = vec(u_1, u_2, u_3), quad
Mat(R)(Vec(u), phi.alt) = mat(
  r_11, r_12, r_13;
  r_21, r_22, r_23;
  r_31, r_32, r_33;
),quad$ and $quad Mat(U) = mat(
  0, -u_3, u_2;
  u_3, 0, -u_1;
  -u_2, u_1, 0;
)$:
$
  Mat(R)(Vec(u), phi.alt) & = Mat(I) + (sin phi.alt) Mat(U) + (1 - cos phi.alt) Mat(U)^2 \
                          & = mat(
                              u_1^2 v_phi.alt + c_phi.alt, u_1 u_2 v_phi.alt - u_3 s_phi.alt, u_1 u_3 v_phi.alt + u_2 s_phi.alt;
                              u_1 u_2 v_phi.alt + u_3 s_phi.alt, u_2^2 v_phi.alt + c_phi.alt, u_2 u_3 v_phi.alt - u_1 s_phi.alt;
                              u_1 u_3 v_phi.alt - u_2 s_phi.alt, u_2 u_3 v_phi.alt + u_1 s_phi.alt, u_3^2 v_phi.alt + c_phi.alt;
                            )
$
where $c_phi.alt = cos phi.alt, quad s_phi.alt = sin phi.alt, quad v_phi.alt = 1 - cos phi.alt$.
$
  phi.alt = arccos((tr(Mat(R)) - 1) / 2)
  quad quad "and" quad quad
  Vec(u) = 1 / (2 sin phi.alt) vec(r_32 - r_23, r_13 - r_31, r_21 - r_12)
$
where $tr(Mat(R)) = r_11 + r_22 + r_33$ is the trace of the rotation matrix.

== Homogeneous Transformations

$
          Vec(r, f: A) & = Rm(B, f: A) Vec(r, f: B) + Vec(p, f: A) \
  mat(Vec(r, f: A); 1) & = mat(
                           Rm(B, f: A), Vec(p, f: A);
                           Mat(0)_(1 times 3), 1
                         ) mat(Vec(r, f: B); 1) \
           Tm(B, f: A) & = mat(
                           Rm(B, f: A), Vec(p, f: A);
                           Mat(0)_(1 times 3), 1
                         ) = mat(
                           Mat(I)_(3 times 3), Vec(p, f: A);
                           Mat(0)_(1 times 3), 1
                         ) mat(
                           Rm(B, f: A), Vec(0)_3;
                           Mat(0)_(1 times 3), 1
                         )
$

- Translation Operator: $Mat(T)(Vec(p)) := mat(
    Mat(I), Vec(p);
    Mat(0), 1
  )$

- Rotation Operator: $Mat(T)(Mat(R)) := mat(
    Mat(R), Vec(0);
    Mat(0), 1
  )$

- Transformation Operator: $Mat(T)(Mat(R), Vec(p)) := mat(
    Mat(R), Vec(p);
    Mat(0), 1
  ) = Mat(T)(Vec(p)) space Mat(T)(Mat(R))$

=== Inverse Transformation

$
      Vec(r, f: B) & = Rm(B, f: A)^top Vec(r, f: A) - Rm(B, f: A)^top Vec(p, f: A) \
  Tm(A, f: B)^(-1) & = mat(
                       Rm(B, f: A)^top, , -Rm(B, f: A)^top Vec(p, f: A);
                       Mat(0)_(1 times 3), , 1
                     )
$

=== Arithmetic

$
  Tm(A, f: C) = Tm(B, f: C) Tm(A, f: B)
  quad quad quad quad Vec(r, f: A) = Tm(B, f: A) Vec(r, f: B)
$

- $Vec(r) = mat(x, y, z, 1)^top$ represents a point whose coordinates are $(x, y, z)$.
$
  mat(
    1, 0, 0, a;
    0, 1, 0, b;
    0, 0, 1, c;
    0, 0, 0, 1;
  ) vec(x, y, z, 1) =
  vec(x + a, y + b, z + c, 1)
$

- $Vec(v) = mat(x, y, z, 0)^top$ represents a direction vector whose components are $(x, y, z)$, because translation does not affect it:
$
  mat(
    1, 0, 0, a;
    0, 1, 0, b;
    0, 0, 1, c;
    0, 0, 0, 1;
  ) vec(x, y, z, 0) =
  vec(x, y, z, 0)
$
