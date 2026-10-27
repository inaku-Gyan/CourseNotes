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
  quad quad quad
  Rm(B, f: A) Vec(p, f: B) = Vec(p, f: A)
  quad quad quad
  Rm(A, f: C) = Rm(B, f: C) Rm(A, f: B)
$
where the columns are the unit direction vectors of the axes of frame $B$ expressed in frame $A$.

Rotation matrices are *orthogonal* matrices, i.e.,
$
                         Mat(R)^(-1) & = Mat(R)^top  & Vec(p, f: A) & = mat(
                                                                        bar.h, UVec(x, f: B)_A, bar.h;
                                                                        bar.h, UVec(y, f: B)_A, bar.h;
                                                                        bar.h, UVec(z, f: B)_A, bar.h;
                                                                      )                           & Vec(p, f: B) \
  Rm(A, f: B)^top = Rm(A, f: B)^(-1) & = Rm(B, f: A) &              & = #h(2em) (Rm(A, f: B))^top & Vec(p, f: B) \
                                     & #h(8em)       &              & = #h(2.5em) Rm(B, f: A)     & Vec(p, f: B)
$

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

Any rotation matrix can be represented by a rotation of angle $phi.alt$ about an equivalent axis $UVec(u)$,
and $(UVec(u), phi.alt)$ is called the *equivalent angle-axis* of the rotation matrix.

For $quad UVec(u) = vec(u_1, u_2, u_3), quad
Mat(R)(UVec(u), phi.alt) = mat(
  r_11, r_12, r_13;
  r_21, r_22, r_23;
  r_31, r_32, r_33;
),quad$ and $quad Mat(U) = mat(
  0, -u_3, u_2;
  u_3, 0, -u_1;
  -u_2, u_1, 0;
)$:
$
  Mat(R)(UVec(u), phi.alt) & = Mat(I) + (sin phi.alt) Mat(U) + (1 - cos phi.alt) Mat(U)^2 \
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
  UVec(u) = 1 / (2 sin phi.alt) vec(r_32 - r_23, r_13 - r_31, r_21 - r_12)
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

#grid(
  columns: (1fr, 1fr),
  [
    $Vec(r) = mat(x, y, z, 1)^top$ represents a point:
    $
      mat(
        1, 0, 0, a;
        0, 1, 0, b;
        0, 0, 1, c;
        0, 0, 0, 1;
      ) vec(x, y, z, 1) =
      vec(x + a, y + b, z + c, 1)
    $
  ],
  [
    $Vec(v) = mat(x, y, z, 0)^top$ represents a direction:
    $
      mat(
        1, 0, 0, a;
        0, 1, 0, b;
        0, 0, 1, c;
        0, 0, 0, 1;
      ) vec(x, y, z, 0) =
      vec(x, y, z, 0)
    $
  ],
)

=== Inverse Transformation

$
  Vec(p) & = Mat(R) Vec(q) + Vec(r) & ==> quad quad Vec(q) & = Mat(R)^top (Vec(p) - Vec(r)) \
  Mat(T) & = mat(
             Mat(R), Vec(r);
             Mat(O)_(1 times 3), 1
           ) quad quad              &          Mat(T)^(-1) & = mat(
                                                               Mat(R)^top, -Mat(R)^top Vec(p);
                                                               Mat(O)_(1 times 3), 1
                                                             )
$

=== Arithmetic

- $Vec(r, f: A) = Tm(B, f: A) Vec(r, f: B)$: coordinates transformation of a vector
- $Vec(p, f: A) = Tm(B, f: A) Vec(q, f: A)$: transformation of a vector within the same frame

$
  Tm(A, f: C) = Tm(B, f: C) Tm(A, f: B)
$

#[
  #let T = $text(Mat(T), fill: #blue)$
  #let O = $text(Tm(O, f: Sigma), fill: #orange)$

  - Aspect 1:

    Frame $C$ is obtained by transforming frame $B$ by $#T$ w.r.t. frame $B$:
    $
      Tm(C, f: A) = Tm(B, f: A) #T
      quad quad "and" quad quad
      Tm(C, f: B) = #T
    $

    Frame $C$ is obtained by transforming frame $B$ by $#T$ w.r.t. frame $A$:
    $
      quad quad quad quad quad
      Tm(C, f: A) = #T Tm(B, f: A)
      quad quad "and" quad quad
      Tm(C, f: B) = Tm(B, f: A)^(-1) #T Tm(B, f: A)
    $

  - Aspect 2:
    $Tm(O, f: Sigma)$ is the initial pose of the object w.r.t. the frame $Sigma$.

    Transforming the object by $#T$ w.r.t. the frame $Sigma$:
    $ Tm(O', f: Sigma) = #T Tm(O, f: Sigma) $

    Transforming the object by $#T$ w.r.t. its own frame:
    $ Tm(O'', f: Sigma) = Tm(O, f: Sigma) #T $
]

= Denavit-Hartenberg Representation

In this chapter, we use the modified Denavit-Hartenberg convention (modified D-H method).
It is a systematic way to assign coordinate frames to the links of a robot manipulator.

Two joint types:
- Revolute Joint
- Prismatic Joint

Four parameters for each link. For link $i$ (frame $i$):
- $alpha_(i-1)$: *link twist*, the angle from $z_(i-1)$ to $z_i$ about $x_(i-1)$.
- $a_(i-1)$: *link length*, the distance from $z_(i-1)$ to $z_i$ along $x_(i-1)$.
- $d_i$: *link offset*, the distance from $x_(i-1)$ to $x_i$ along $z_i$.
- $theta_i$: *joint angle*, the angle from $x_(i-1)$ to $x_i$ about $z_i$.

#table(
  columns: (1fr, 1fr, 1fr, 1fr, 1fr),
  align: center + horizon,
  [ Joint $i$ ], $alpha_(i-1)$, $a_(i-1)$, $d_i$, $theta_i$,
  [ Revolute Joint], [ constant ], [ constant ], [ constant ], [ _variable_ ],
  [ Prismatic Joint], [ constant ], [ constant ], [ _variable_ ], [ constant ],
)

$
  Tm(i, f: i-1) space &= space Mat(R)_x (alpha_(i-1)) space Mat(T)_x (a_(i-1)) space Mat(T)_z (d_i) space Mat(R)_z (theta_i) \
  "or equivalently" space
  &= space Mat(T)_x (a_(i-1)) space Mat(R)_x (alpha_(i-1)) space Mat(T)_z (d_i) space Mat(R)_z (theta_i) \
$

