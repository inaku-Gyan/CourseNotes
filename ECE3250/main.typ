#import "@preview/ilm:2.1.1": *
#import "../common/style.typ"

#show: ilm.with(
  title: [ECE 3250\ System and Control],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 11, day: 1),
)

#show: style.apply

#let Vec(v) = $bold(#v)$
#let Mat(M) = $bold(upright(#M))$

#let Re = $op("Re")$

#let e = $upright(e)$

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

*Initial and final value theorems*

The following are the standard forms for *causal* signals, for which
$X(s) = X_+(s)$; use the causal ROC.

- *Initial value:*
  $ x(0^+) = lim_(s -> +infinity) s X(s) $
  Take the limit along the positive real axis within the ROC. The finite
  right-hand value must exist, with no impulse or impulse derivatives at the origin.

- *Final value:*
  $ lim_(t -> infinity) x(t) = lim_(s -> 0^+) s X(s) $
  For rational $X(s)$, every pole of $s X(s)$ after cancellation must lie strictly
  in the open left half-plane. Thus $X(s)$ may have a simple pole at zero,
  while all other poles must have negative real parts. A finite algebraic limit
  alone is insufficient.

These are not general identities for noncausal signals; the signal's time support
and ROC matter.

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

- The unilateral transform does not determine the pre-initial values
  $x^((k))(0^-)$; supply these separately when transforming derivatives.

*Initial and final value theorems*

These use $X_+(s)$ and do not require the original signal to be causal.

- *Initial value:*
  $ x(0^+) = lim_(s -> +infinity) s X_+(s) $
  The limit is taken along the positive real axis. The finite right-hand
  value must exist, and $x$ must have no impulse or impulse derivatives at
  the origin. This gives $x(0^+)$; the derivative formulas instead use $x(0^-)$.

- *Final value:*
  $ lim_(t -> infinity) x(t) = lim_(s -> 0^+) s X_+(s) $
  For rational transforms, check that every pole of $s X_+(s)$, after
  cancellation, lies strictly in the open left half-plane. Equivalently,
  $X_+(s)$ may have a simple pole at zero, while all its other poles must
  have negative real parts. A finite algebraic limit alone is insufficient:
  growing exponentials, sustained sinusoids, and ramps fail this check.

= System Modeling

== Modeling Methods

A mathematical model relates a system's physical variables, especially its input and output.

- *First-principle modeling:* derive equations from physical laws.
- *System identification:* infer input--output relations from experimental data.
- The two methods may be combined.

== State-Space Models

$
  dot(Vec(x))(t) & = Mat(A) Vec(x)(t) + Mat(B) Vec(u)(t) \
       Vec(y)(t) & = Mat(C) Vec(x)(t) + Mat(D) Vec(u)(t)
$

- $Vec(x)(t) in RR^n$: state vector
- $Vec(u)(t) in RR^m$: input vector
- $Vec(y)(t) in RR^r$: output vector

For $n$ states, $m$ inputs, and $r$ outputs,
$Mat(A) in RR^(n times n)$, $Mat(B) in RR^(n times m)$,
$Mat(C) in RR^(r times n)$, and $Mat(D) in RR^(r times m)$.

*Higher-Order ODEs*

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

== Linearization

For a time-invariant nonlinear system with continuously differentiable $Vec(f), Vec(g)$,

$
  dot(Vec(x)) = Vec(f)(Vec(x), Vec(u)), quad Vec(y) = Vec(g)(Vec(x), Vec(u))
$

An *operating point* $(Vec(x)_0, Vec(u)_0, Vec(y)_0)$ satisfies

$
  Vec(0) = Vec(f)(Vec(x)_0, Vec(u)_0), quad
  Vec(y)_0 = Vec(g)(Vec(x)_0, Vec(u)_0)
$

With constant input $Vec(u)_0$ and initial state $Vec(x)_0$, the state and output
remain at $Vec(x)_0$ and $Vec(y)_0$.

Define deviations $tilde(Vec(x)) = Vec(x) - Vec(x)_0$,
$tilde(Vec(u)) = Vec(u) - Vec(u)_0$, and $tilde(Vec(y)) = Vec(y) - Vec(y)_0$.
The first-order Taylor expansion gives

$
  dot(Vec(x)) = Vec(f)(Vec(x)_0 + tilde(Vec(x)), Vec(u)_0 + tilde(Vec(u)))
  & approx Vec(f)(Vec(x)_0, Vec(u)_0) + Mat(A) tilde(Vec(x)) + Mat(B) tilde(Vec(u)) \
  Vec(y) = Vec(g)(Vec(x)_0 + tilde(Vec(x)), Vec(u)_0 + tilde(Vec(u)))
  & approx Vec(y)_0 + Mat(C) tilde(Vec(x)) + Mat(D) tilde(Vec(u))
$

Using the operating-point equations and dropping higher-order terms,

$
  dot(tilde(Vec(x))) & approx Mat(A) tilde(Vec(x)) + Mat(B) tilde(Vec(u)) &
  wide "where" wide
  Mat(A) = lr((partial Vec(f)) / (partial Vec(x)) |)_((Vec(x)_0, Vec(u)_0)),
  quad
  Mat(B) = lr((partial Vec(f)) / (partial Vec(u)) |)_((Vec(x)_0, Vec(u)_0)) \
  tilde(Vec(y)) & approx Mat(C) tilde(Vec(x)) + Mat(D) tilde(Vec(u)) &
  Mat(C) = lr((partial Vec(g)) / (partial Vec(x)) |)_((Vec(x)_0, Vec(u)_0)),
  quad
  Mat(D) = lr((partial Vec(g)) / (partial Vec(u)) |)_((Vec(x)_0, Vec(u)_0))
$

- The linear model describes *deviations*, rather than the original variables.
- Validity is local while the deviations remain small; smoothness alone does
  not guarantee that a perturbed trajectory stays near the operating point.

== Transfer Functions

With *zero initial conditions*, the SISO LTI *transfer function* is

$
  G(s) := Y(s) / U(s)
$

A nonzero initial state adds a separate response.

*State space to transfer function*

Taking the Laplace transform with $Vec(x)(0^-) = Vec(0)$ gives

$
  s Vec(X) & = Mat(A) Vec(X) + Mat(B) Vec(U) \
    Vec(X) & = (s Mat(I) - Mat(A))^(-1) Mat(B) Vec(U)
$

Substitution into the output equation gives the transfer function matrix

$
  Mat(H)(s) = Mat(C) (s Mat(I) - Mat(A))^(-1) Mat(B) + Mat(D)
$

For SISO systems, $Mat(H)(s)$ reduces to the scalar $G(s)$.

== Block Diagram Algebra

The following rules apply to scalar transfer functions, with zero initial conditions.

#table(
  columns: (1fr, 2fr),
  align: center + horizon,
  table.header([Connection], [Equivalent transfer function]),
  [Cascade], $G_1 G_2$,
  [Parallel], $G_1 plus.minus G_2$,
  [Negative feedback], $G / (1 + G H)$,
  [Positive feedback], $G / (1 - G H)$,
)

= Stability Analysis

== Polynomial Stability

A real polynomial is *Hurwitz* (stable) if all its roots satisfy $Re(s) < 0$.
Write $a(s) = a_0 s^n + a_1 s^(n-1) + dots + a_n$, with real coefficients and $a_0 != 0$.

Scaling the whole polynomial by a nonzero constant preserves its roots.
Use $a_0 > 0$ below; division by $a_0$ makes it *monic* (leading coefficient $1$).
Before scaling, all first-column entries must have the same nonzero sign.
Remove leading zeros before fixing the degree $n$.

*Equivalent stability tests*

Each of the following is necessary and sufficient for $a(s)$ to be Hurwitz:

#table(
  columns: (1fr, 2.5fr),
  align: center + horizon,
  inset: (x: 5pt, y: 6pt),
  table.header([Method], [Condition]),
  [Root locations], [Every root satisfies $Re(s) < 0$.],
  [Routh first column], [$r_(i,0) > 0$ for $i = 0, ..., n$.],
  [Entire Routh array], [All entries are positive, excluding zero padding.],
)

*BIBO stability*

For a causal, proper rational LTI system with reduced transfer function
$G(s) = b(s) slash a(s)$, the following are equivalent:

$
  "BIBO stable" quad <==> quad "poles in open LHP" quad <==> quad a(s) "is Hurwitz"
$

Input--output stability of one channel does not by itself establish internal
stability when unstable modes may be hidden by pole--zero cancellation.

== Routh Table

For the polynomial above, the first two rows contain alternating coefficients:

#table(
  columns: (0.8fr, 1fr, 1fr, 1fr, 0.5fr),
  align: center + horizon,
  inset: (x: 5pt, y: 6pt),
  table.header([Power], [Column 0], [Column 1], [Column 2], []),
  $s^n$, $r_(0,0) = a_0$, $r_(0,1) = a_2$, $r_(0,2) = a_4$, $dots$,
  $s^(n-1)$, $r_(1,0) = a_1$, $r_(1,1) = a_3$, $r_(1,2) = a_5$, $dots$,
  $s^(n-2)$, $r_(2,0)$, $r_(2,1)$, $r_(2,2)$, $dots$,
  $dots.v$, $dots.v$, $dots.v$, $dots.v$, [],
  $s^0$, $r_(n,0)$, [], [], [],
)

For $i >= 2$, use the preceding two rows:

$
  r_(i,j) = -1 / r_(i-1,0) mat(
    delim: "|",
    r_(i-2,0), r_(i-2,j+1);
    r_(i-1,0), r_(i-1,j+1),
  )
$

Missing entries are zero. Positive rescaling of a row preserves the stability test.

#block(sticky: true)[
  *Routh criterion:* with $a_0 > 0$, $a(s)$ is Hurwitz iff every $r_(i,0) > 0$.
]

#block(sticky: true)[
  For degrees $1$--$3$, the first-column test gives the following *Hurwitz conditions*,
  with $a_0 > 0$:
]

#table(
  columns: (0.5fr, 2fr, 2fr),
  align: center + horizon,
  inset: (x: 5pt, y: 7pt),
  table.header([$n$], [Routh first column], [Hurwitz iff]),
  $1$, [$a_0, a_1$], [$a_1 > 0$],
  $2$, [$a_0, a_1, a_2$], [$a_1 > 0$, $a_2 > 0$],
  $3$, [$a_0, a_1, (a_1 a_2 - a_0 a_3) / a_1, a_3$], [$a_1 > 0$, $a_2 > 0$, $a_3 > 0$;\ $a_1 a_2 > a_0 a_3$],
)

- Positive coefficients are necessary, but are not sufficient in general.
- For parameter-dependent coefficients, require every first-column entry to be
  strictly positive and intersect the resulting inequalities.
- A zero pivot requires special handling before continuing the recursion;
  a zero first-column entry does not satisfy the strict stability test.

#block(breakable: false)[
  == Robust Stability

  An *interval polynomial family* has independently varying real coefficients:

  $
    cal(P) = {a(s) = sum_(i=0)^n a_i s^(n-i) : a_i in [underline(a)_i, overline(a)_i]}
  $

  Assume a fixed degree and $0 < underline(a)_0 <= overline(a)_0$.
  The family is *robustly stable* if every member is Hurwitz.

  *Kharitonov theorem*

  Under the assumptions above, robust stability is equivalent to either test:

  - All four Kharitonov polynomials $K_1, ..., K_4$ are Hurwitz.
  - All four Routh tables, one for each $K_j$, have strictly positive first columns.

  *Endpoint construction*

  Construct the four polynomials by repeating these patterns in the *descending-power*
  order $a_0, a_1, ..., a_n$:

  #table(
    columns: (0.7fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    align: center + horizon,
    inset: (x: 5pt, y: 6pt),
    table.header([Poly.], [$a_0$], [$a_1$], [$a_2$], [$a_3$], [Repeat]),
    $K_1$, $underline(a)_0$, $underline(a)_1$, $overline(a)_2$, $overline(a)_3$, [LLUU],
    $K_2$, $underline(a)_0$, $overline(a)_1$, $overline(a)_2$, $underline(a)_3$, [LUUL],
    $K_3$, $overline(a)_0$, $underline(a)_1$, $underline(a)_2$, $overline(a)_3$, [ULLU],
    $K_4$, $overline(a)_0$, $overline(a)_1$, $underline(a)_2$, $underline(a)_3$, [UULL],
  )

  Here L and U select the lower bound $underline(a)_i$ and upper bound $overline(a)_i$, respectively.
  Checking only the all-lower and all-upper polynomials is insufficient.
  For correlated coefficient families, robust stability of an independent interval
  enclosure is a sufficient guarantee; it need not be necessary.
]

= Feedback Stabilization and Design

== Internal Stability and the Gang of Four

Consider a continuous-time LTI negative-feedback loop with a *SISO plant* $P(s)$
and a *SISO controller* $C(s)$.
*Internal stability* requires every closed-loop transfer channel to be stable.

The *Gang of Four (GoF)* consists of four scalar closed-loop transfer functions,
including sensitivity $S$ and complementary sensitivity $T$:

$
    S & := 1 / (1 + P C) & wide C S & := C / (1 + P C)     &                \
  P S & := P / (1 + P C) &        T & := (P C) / (1 + P C) & wide S + T = 1
$

Use real coprime plant/controller factors and define the characteristic polynomial $Delta(s)$:

$
      P(s) & = b(s) / a(s), quad C(s) = q(s) / p(s), quad gcd(a, b) = gcd(p, q) = 1 \
  Delta(s) & := a(s) p(s) + b(s) q(s)
$

*Well-posedness*

Assume $P,C$ are *proper* (numerator degree does not exceed denominator degree).
The feedback loop is *well posed* when its instantaneous feedback relations are
uniquely solvable; equivalently, all four GoF functions exist and are proper.

Let $n=deg a$, $m=deg p$, with leading coefficients $a_0,p_0 != 0$.
Pad the numerator coefficients $b_0,q_0$ to the same respective degrees. Then

$
  1 + P(infinity) C(infinity) = 1 + frac(b_0, a_0) frac(q_0, p_0)
  = (a_0 p_0 + b_0 q_0) / (a_0 p_0)
$

Well-posedness requires this quantity to be nonzero, equivalently
$a_0 p_0 + b_0 q_0 != 0$ and $deg Delta = n+m$.
If either $P$ or $C$ is strictly proper, the condition is automatic.

If the leading terms cancel, $S = a p slash Delta$ is undefined or improper.
Check well-posedness before testing $Delta$ for Hurwitz stability;
lowering its degree and checking only the remaining finite roots is insufficient.

*Equivalent internal-stability tests*

Assume:

- Loop: continuous-time SISO LTI negative feedback.
- Models: $P=b slash a$ and $C=q slash p$ are proper real-rational transfer functions.
- Coprime factors: $gcd(a, b)=gcd(p, q)=1$.
- Well-posedness: $1+P(infinity) C(infinity) != 0$.

*Internal stability* is then equivalent to each of the following:

- *Gang of Four:* $S$, $C S$, $P S$, and $T$ are all stable.
- *Characteristic polynomial:* $Delta(s)$ is Hurwitz (stable).
- *Cancellation test:* forming $P C$ involves no pole--zero cancellation in
  $Re(s) >= 0$, and any one of $S$, $C S$, $P S$, or $T$ is stable.

#block(breakable: false)[
  *Characteristic-polynomial test*

  Substitution groups the four scalar GoF functions into a $2 times 2$ array
  with a common denominator:

  $
                1 + P C & = (a p + b q) / (a p) = Delta(s) / (a p) \
    mat(S, C S; P S, T) & = 1 / Delta(s) mat(a p, a q; b p, b q)
  $
]

At any zero of $Delta(s)$, coprimeness ensures that at least one of
$a p$, $a q$, $b p$, and $b q$ is nonzero. Hence each root of $Delta(s)$ remains
a pole of at least one GoF function: internal stability is equivalent to
$Delta(s)$ being Hurwitz.
Check $Delta(s)$ before cancelling cross-factors between the plant and controller;
stability of $T$ alone can hide unstable internal dynamics.

== Pole Placement Design

Pole placement chooses the controller so that $Delta(s) = Delta_"des" (s)$.
Given desired closed-loop poles $lambda_1, ..., lambda_N$, form

$
  Delta_"des" (s) = product_(i=1)^N (s - lambda_i)
$

Choose poles in $Re(s) < 0$ for stability; nonreal poles must occur in conjugate
pairs for a real-coefficient controller.

For $P = b slash a$ and $C = q slash p$, impose the polynomial identity

$
  a(s) p(s) + b(s) q(s) = Delta_"des" (s)
$

Coefficient matching gives linear equations in the controller coefficients.

Use descending coefficients, with $deg a = n >= 1$, $deg b <= n$, and $gcd(a, b) = 1$:

$
  a(s) = a_0 s^n + dots.h + a_n, quad b(s) = b_0 s^n + dots.h + b_n, quad a_0 != 0
$

Pad $b$ to degree $n$ and set $a_i = b_i = 0$ outside $0 <= i <= n$.
Bold $Mat(T),Mat(S)$ distinguish matrices from scalar GoF $T,S$.

#block(sticky: true)[*Toeplitz Matrices*]

A *Toeplitz matrix* is constant along each diagonal. The two convolution matrices are

$
  Mat(T)(a, k) = mat(
    a_0, 0, dots.h, 0;
    a_1, a_0, dots.down, dots.v;
    dots.v, dots.v, dots.down, dots.v;
    a_n, a_(n-1), dots.h, a_(n-k+1);
    dots.v, dots.v, dots.down, dots.v;
    0, 0, dots.h, a_n;
  ), quad
  Mat(T)(b, k) = mat(
    b_0, 0, dots.h, 0;
    b_1, b_0, dots.down, dots.v;
    dots.v, dots.v, dots.down, dots.v;
    b_n, b_(n-1), dots.h, b_(n-k+1);
    dots.v, dots.v, dots.down, dots.v;
    0, 0, dots.h, b_n;
  )
$

#block(breakable: false)[
  For $k >= 1$, each has $n+k$ rows and $k$ columns; equivalently,

  $
    [Mat(T)(a, k)]_(i,j) := a_(i-j)
  $
]

Here $i = 0, ..., n+k-1$ and $j = 0, ..., k-1$.
Each column is the coefficient vector shifted one position farther down.

For $h(s) = h_0 s^(k-1) + dots.h + h_(k-1)$, let $gamma_i$ be the descending
coefficients of $a h$. Multiplication becomes

$
  Mat(T)(a, k) vec(h_0, dots.v, h_(k-1)) = vec(gamma_0, dots.v, gamma_(n+k-1)),
  quad gamma_i = sum_(j=0)^(k-1) a_(i-j) h_j
$

Thus $k$ counts multiplier coefficients; the multiplier degree is at most $k-1$.

#block(sticky: true)[*Sylvester's Resultant Matrix*]

Combine the two convolution matrices:

$
  Mat(S)(a, b, k) := mat(Mat(T)(a, k), Mat(T)(b, k)) in RR^((n+k) times (2k))
$

It maps the stacked coefficients of $p,q$ (degrees at most $k-1$) to those of $a p + b q$.

#block(breakable: false)[
  The square case $k=n$ has size $2n times 2n$ and detects common factors:

  $
    gcd(a, b) = 1 quad <==> quad det(Mat(S)(a, b, n)) != 0
  $
]

For coprime $a,b$, the rank is $min(2k, n+k)$:

#table(
  columns: (0.7fr, 1.3fr, 2.5fr),
  align: center + horizon,
  inset: (x: 5pt, y: 6pt),
  table.header([$k$], [Rank], [Coefficient matching]),
  $k < n$, [$2k$; full column rank], [Unique if consistent; otherwise no solution.],
  $k = n$, [$2n$; nonsingular], [Unique solution for every target.],
  $k > n$, [$n+k$; full row rank], [Always solvable; $k-n$ free parameters.],
)

To see the rank count, $a p + b q = 0$ implies $p = b h$, $q = -a h$ by coprimeness.
The degree bounds give $deg h <= k-n-1$, so the nullity is $max(k-n, 0)$.

#block(breakable: false)[
  *Proper Controller Parameterization*

  For nominal controller order $m >= 0$, choose target degree $N=n+m$ and write

  $
               p(s) & = p_0 s^m + dots.h + p_m, quad q(s) = q_0 s^m + dots.h + q_m \
    Delta_"des" (s) & = d_0 s^(n+m) + dots.h + d_(n+m)
  $

  The intended denominator degree requires $p_0 != 0$; the monic target above has $d_0=1$.
  There are $2m+2$ unknown coefficients and $n+m+1$ matching equations:

  $
    underbrace(
      mat(
        a_0, 0, dots.h, 0, b_0, 0, dots.h, 0;
        a_1, a_0, dots.down, dots.v, b_1, b_0, dots.down, dots.v;
        dots.v, dots.v, dots.down, dots.v, dots.v, dots.v, dots.down, dots.v;
        a_n, a_(n-1), dots.h, a_(n-m), b_n, b_(n-1), dots.h, b_(n-m);
        dots.v, dots.v, dots.down, dots.v, dots.v, dots.v, dots.down, dots.v;
        0, 0, dots.h, a_n, 0, 0, dots.h, b_n;
      ),
      Mat(S)(a, b, m+1),
    ) vec(p_0, dots.v, p_m, q_0, dots.v, q_m)
    = vec(d_0, d_1, dots.v, d_(n+m))
  $
]

With $k=m+1$, every target coefficient vector is matchable iff $m >= n-1$. \
At $m=n-1$, the solution is unique; for $m>n-1$, there are $m+1-n$ free parameters.
For $m<n-1$, only consistent targets are attainable.

#block(breakable: false)[
  *Strictly Proper Controller Parameterization*

  For $m >= 1$, set $q_0=0$. Comparing the leading and remaining coefficients gives

  $
    p_0 = d_0 / a_0, quad
    Mat(S)(a, b, m) vec(p_1, dots.v, p_m, q_1, dots.v, q_m)
    = vec(d_1 - a_1 d_0 / a_0, dots.v, d_n - a_n d_0 / a_0, d_(n+1), dots.v, d_(n+m))
  $
]

The right-hand side contains the $n+m$ coefficients of
$Delta_"des" (s) - p_0 s^m a(s)$, whose degree is at most $n+m-1$.

Here $k=m$: every target coefficient vector is matchable iff $m >= n$.
At $m=n$ the solution is unique; for $m>n$ there are $m-n$ free parameters.
Lower orders require a consistent target.

These bounds concern coefficient matching. Check $p_0 != 0$, reduce $p,q$ to coprime form,
then verify actual controller order, properness, well-posedness, and internal stability.
The target's leading coefficient fixes their common scale.
