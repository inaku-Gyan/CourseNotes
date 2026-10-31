#import "@preview/ilm:2.1.1": *
#import "../common/style.typ"

#show: ilm.with(
  title: [ECE 3250\ System and Control],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 10, day: 30),
)

#show: style.apply

#let Vec(v) = $bold(#v)$
#let Mat(M) = $bold(upright(#M))$

#let Re = $op("Re")$

#let e = $upright(e)$

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
  Mat(H)(s) = Mat(C) (s Mat(I) - Mat(A))^(-1) Mat(B) + Mat(D)
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

= Laplace Transforms

Here $sigma(t)$ denotes the unit step and $delta(t)$ the unit impulse.

== Bilateral Laplace Transform

The bilateral (two-sided) Laplace transform is
$
  X(s) = cal(L)_"b" {x(t)} := integral_(-infinity)^infinity x(t) #e^(-s t) dif t
$
#block(sticky: true)[*Common transform pairs*]

#block[
  #set text(size: 10pt)
  #table(
    columns: (1.4fr, 1.2fr, 1.1fr),
    align: center + horizon,
    inset: (x: 5pt, y: 8pt),
    table.header([$x(t)$], [$X(s)$], [ROC]),
    $delta(t)$, $1$, [$s in CC$],
    $delta(t - t_0)$, $#e^(-s t_0)$, [$s in CC$],
    $sigma(t)$, $1 / s$, $Re(s) > 0$,
    $-sigma(-t)$, $1 / s$, $Re(s) < 0$,
    $#e^(-a t) sigma(t)$, $1 / (s + a)$, $Re(s) > -Re(a)$,
    $-#e^(-a t) sigma(-t)$, $1 / (s + a)$, $Re(s) < -Re(a)$,
    $t sigma(t)$, $1 / s^2$, $Re(s) > 0$,
    $t^n sigma(t)$, $frac(n!, s^(n+1))$, $Re(s) > 0$,
    $t^n #e^(-a t) sigma(t)$, $frac(n!, (s + a)^(n+1))$, $Re(s) > -Re(a)$,
    $sin(omega_0 t) sigma(t)$, $omega_0 / (s^2 + omega_0^2)$, $Re(s) > 0$,
    $cos(omega_0 t) sigma(t)$, $s / (s^2 + omega_0^2)$, $Re(s) > 0$,
    $#e^(-a t) sin(omega_0 t) sigma(t)$, $omega_0 / ((s + a)^2 + omega_0^2)$, $Re(s) > -Re(a)$,
    $#e^(-a t) cos(omega_0 t) sigma(t)$, $(s + a) / ((s + a)^2 + omega_0^2)$, $Re(s) > -Re(a)$,
    [$#e^(-b abs(t))$, $b > 0$ real], $frac(2 b, b^2 - s^2)$, $-b < Re(s) < b$,
  )
]

A bare sinusoid or constant extending over all time has no nonempty bilateral ROC.

*Properties*

Let $cal(L)_"b" {x(t)} = X(s)$ and $cal(L)_"b" {y(t)} = Y(s)$,
with ROCs $R_X$ and $R_Y$.

#block[
  #set text(size: 10pt)
  #table(
    columns: (1.1fr, 1.35fr, 1.45fr, 1.5fr),
    align: center + horizon,
    inset: (x: 5pt, y: 8pt),
    table.header([Property], [Time domain], [$s$-domain], [ROC]),
    [Linearity], $A x(t) + B y(t)$, $A X(s) + B Y(s)$, $supset.eq R_X inter R_Y$,
    [Time shift; $t_0 in RR$], $x(t - t_0)$, $#e^(-s t_0) X(s)$, $= R_X$,
    [Frequency shift], $#e^(-a t) x(t)$, $X(s + a)$, $= {s : s + a in R_X}$,
    [Time scaling\ $c in RR$, $c != 0$], $x(c t)$, $1 / abs(c) X(s / c)$, $= {s : s / c in R_X}$,
    [Time reversal], $x(-t)$, $X(-s)$, $= {s : -s in R_X}$,
    [Differentiation\ $n >= 1$], $x^((n))(t)$, $s^n X(s)$, $supset.eq R_X$,
    [Multiplication by $t^n$], $t^n x(t)$, $(-1)^n (dif^n X(s)) / (dif s^n)$, $= R_X$,
    [Integration], $integral_(-infinity)^t x(tau) dif tau$, $1/s X(s)$, $supset.eq {s in R_X : Re(s) > 0}$,
    [Convolution], $(x * y)(t)$, $X(s) Y(s)$, $supset.eq R_X inter R_Y$,
  )
]

- The convolution is defined as
  $ (x * y)(t) := integral_(-infinity)^infinity x(tau) y(t - tau) dif tau $

*ROC rules and conditions*

- A nonempty ROC is a vertical strip or half-plane (possibly the whole plane)
  and contains no poles. For rational transforms, a right-sided signal has its
  ROC to the right of the rightmost pole, a left-sided signal to the left of
  the leftmost pole, and a two-sided signal between poles.

- The Fourier transform is obtained as $X(j omega)$ when the imaginary axis
  lies in the ROC.

- For causal signals, the initial and final value theorems
  below also apply, subject to their stated conditions.

== Unilateral Laplace Transform

The unilateral (one-sided) Laplace transform uses the $0^-$ convention:
$
  X_+(s) = cal(L)_+ {x(t)} := integral_(0^-)^infinity x(t) #e^(-s t) dif t
$
For a causal signal, $X_+(s) = X(s)$.

#block(sticky: true)[*Common transform pairs*]

#block[
  #set text(size: 10pt)
  #table(
    columns: (1.4fr, 1.2fr, 1.1fr),
    align: center + horizon,
    inset: (x: 5pt, y: 8pt),
    table.header([$x(t)$ when $t >= 0$], [$X_+(s)$], [ROC]),
    $delta(t)$, $1$, [$s in CC$],
    [$delta(t - t_0)$, $t_0 >= 0$], $#e^(-s t_0)$, [$s in CC$],
    [$1$ or $sigma(t)$], $1 / s$, $Re(s) > 0$,
    $#e^(-a t)$, $1 / (s + a)$, $Re(s) > -Re(a)$,
    $t$, $1 / s^2$, $Re(s) > 0$,
    $t^n$, $frac(n!, s^(n+1))$, $Re(s) > 0$,
    $t^n #e^(-a t)$, $frac(n!, (s + a)^(n+1))$, $Re(s) > -Re(a)$,
    $sin(omega_0 t)$, $omega_0 / (s^2 + omega_0^2)$, $Re(s) > 0$,
    $cos(omega_0 t)$, $s / (s^2 + omega_0^2)$, $Re(s) > 0$,
    $#e^(-a t) sin(omega_0 t)$, $omega_0 / ((s + a)^2 + omega_0^2)$, $Re(s) > -Re(a)$,
    $#e^(-a t) cos(omega_0 t)$, $(s + a) / ((s + a)^2 + omega_0^2)$, $Re(s) > -Re(a)$,
    [$sigma(t - t_0)$, $t_0 >= 0$], $#e^(-s t_0) / s$, $Re(s) > 0$,
    [$(t - t_0)^n sigma(t - t_0)$, $t_0 >= 0$], $frac(n! #e^(-s t_0), s^(n+1))$, $Re(s) > 0$,
  )
]

*Properties*

Let $cal(L)_+ {x(t)} = X_+(s)$ and $cal(L)_+ {y(t)} = Y_+(s)$,
with ROCs $R_X$ and $R_Y$.
Write $x_c, y_c$ for their causal extensions, retaining any impulses at zero.

#block[
  #set text(size: 10pt)
  #table(
    columns: (1.1fr, 1.2fr, 1.6fr, 1.5fr),
    align: center + horizon,
    inset: (x: 5pt, y: 8pt),
    table.header([Property], [Time domain], [$s$-domain], [ROC]),
    [Linearity], $A x(t) + B y(t)$, $A X_+(s) + B Y_+(s)$, $supset.eq R_X inter R_Y$,
    [Delay; $t_0 >= 0$], $x_c (t - t_0)$, $#e^(-s t_0) X_+(s)$, $= R_X$,
    [Frequency shift], $#e^(-a t) x(t)$, $X_+(s + a)$, $= {s : s + a in R_X}$,
    [Time scaling; $c > 0$], $x(c t)$, $1 / c X_+(s / c)$, $= {s : s / c in R_X}$,
    [First derivative], $x'(t)$, $s X_+(s) - x(0^-)$, $supset.eq R_X$,
    [Second derivative], $x''(t)$, $s^2 X_+(s) -s x(0^-) - x'(0^-)$, $supset.eq R_X$,
    [Multiplication by $t^n$], $t^n x(t)$, $(-1)^n (dif^n X_+(s)) / (dif s^n)$, $= R_X$,
    [Integration\ from zero], $integral_(0^-)^t x(tau) dif tau$, $1/s X_+(s)$, $supset.eq {s in R_X : Re(s) > 0}$,
    [Causal convolution], $(x_c * y_c)(t)$, $X_+(s) Y_+(s)$, $supset.eq R_X inter R_Y$,
  )
]

- For $n >= 1$, the general derivative formula is
  $
    cal(L)_+ {x^((n))(t)} = s^n X_+(s)
    - sum_(k=0)^(n-1) s^(n-1-k) x^((k))(0^-)
  $

- For ordinary signals, the delayed signal is
  $x_c (t - t_0) := x(t - t_0) sigma(t - t_0)$
  and the causal convolution is defined as
  $ (x_c * y_c)(t) := integral_0^t x(tau) y(t - tau) dif tau $

- Unilateral ROCs are right half-planes, possibly the whole plane.
  The same open-ROC convention and existence conditions apply; cancellation
  of terms may enlarge the guaranteed regions in the table.

- The signals $x(t) = 1$ and $x(t) = sigma(t)$ both transform to $1 slash s$, but their
  pre-initial values are $1$ and $0$, respectively. Thus their derivatives
  transform to $0$ and $1$, consistently with $dif sigma(t) slash dif t = delta(t)$.

*Initial and final value theorems*

- *Initial value:*
  $ x(0^+) = lim_(s -> +infinity) s X_+(s) $
  The limit is taken along the positive real axis. The finite right-hand
  value must exist, and $x$ must have no impulse or impulse derivatives at
  the origin. This gives $x(0^+)$, not at the initial time $0^-$ of the transform.

- *Final value:*
  $ lim_(t -> infinity) x(t) = lim_(s -> 0^+) s X_+(s) $
  For rational transforms, check that every pole of $s X_+(s)$, after
  cancellation, lies strictly in the open left half-plane. Equivalently,
  $X_+(s)$ may have a simple pole at zero, while all its other poles must
  have negative real parts. A finite algebraic limit alone is insufficient:
  growing exponentials, sustained sinusoids, and ramps fail this check.
