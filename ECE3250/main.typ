#import "@preview/ilm:2.1.1": *
#import "../common/style.typ"

#show: ilm.with(
  title: [DDA 3250\ System and Control],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 10, day: 30),
)

#show: style.apply

#let Vec(v) = $bold(#v)$
#let Mat(M) = $bold(upright(#M))$

= State-Space Models

$
  dot(Vec(x))(t) & = Mat(A) Vec(x)(t) + Mat(B) Vec(u)(t) \
       Vec(y)(t) & = Mat(C) Vec(x)(t) + Mat(D) Vec(u)(t)
$
- $Vec(x)(t)$: state vector
- $Vec(u)(t)$: input vector
- $Vec(y)(t)$: output vector

Under zero initial conditions $Vec(x)(0) = Vec(0)$,
$
  (s Mat(I) - Mat(A)) Vec(X)(s) & = Mat(B) Vec(U)(s) \
                      Vec(Y)(s) & = Mat(C) Vec(X)(s) + Mat(D) Vec(U)(s)
$
The transfer function matrix is given by
$
  Mat(G)(s) = Mat(C) (s Mat(I) - Mat(A))^(-1) Mat(B) + Mat(D)
$

#line()

Any $n$-th order ODE can be rewritten as a system of $n$ first-order ODEs.
Given an $n$-th order ODE
$
  y^((n)) = F(t, y, y', ..., y^((n-1)))
$
substituting $z_1 = y$, $z_2 = y'$, ..., $z_n = y^((n-1))$,
we have
$
      z'_1 & = z_2 \
      z'_2 & = z_3 \
           & space dots.v \
  z'_(n-1) & = z_n \
      z'_n & = F(t, z_1, z_2, ..., z_n)
$
