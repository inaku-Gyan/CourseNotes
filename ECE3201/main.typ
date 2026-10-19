#import "@preview/ilm:2.1.1": *
#import "@preview/unify:0.8.1": qty, unit
#import "../common/style.typ"

#show: ilm.with(
  title: [ECE 3201\ Introduction to Microelectronic Circuits],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 09, day: 21),
)

#show: style.apply

#let e = $upright(e)$
#let Vec(v) = $bold(#v)$

= Introduction

== The Amplifier Model

- Voltage Gain: $A_v = v_"O" / v_"I"$

- Current Gain: $A_i = i_"O" / i_"I"$

- Power Gain: $A_P = A_v A_i$

Gain expressed in decibels (originally defined for the power gain, i.e., the power ratio):
- Power Gain: $A_P ("dB") = 10 lg abs(P_"O" / P_"I") = 10 lg abs(A_P)$

- Voltage Gain: $A_v ("dB") = 20 lg abs(A_v)$
- Current Gain: $A_i ("dB") = 20 lg abs(A_i)$

_Treating `(dB)` as an operator functioning on the value before it._

=== The power model

#image("assets/Amplifier Power.png", width: 50%)


- Power balance: $P_"dc" + P_"I" = P_"L" + P_"dissipated"$
- Total dc power delivered to the amplifier: $P_"dc" = V_"CC" I_"CC" + V_"EE" I_"EE"$

- Amplifier power efficiency: $eta := P_"L" / P_"dc" times 100%$

== Symbol Convention

#image("assets/Symbol Convention.png")

== Amplifier Classification

#image("assets/Amplifier Types.png")

The 4 models are interchangeable.

= Operational Amplifiers

- Differential input signal: $quad quad space space v_"Id" := v_("I"+) - v_("I"-)$
- Common-mode input signal: $quad v_"Icm" := (v_("I"+) + v_("I"-)) slash 2$
- Output signal: $quad quad quad quad quad quad quad v_"O" = A_"d" v_"Id" + A_"cm" v_"Icm"$

*For an ideal op amp*:

#grid(
  columns: 2,
  gutter: 3em,
  [
    - Zero common-mode gain: $A_"cm" = 0$
    - Infinite open-loop gain: $quad A_v = A_"d" = infinity$
    - Infinite input impedance: $space R_"I" = infinity$
    - Zero output impedance: $quad R_"O" = 0$
    - Infinite bandwidth: $quad quad quad f_"L" = infinity$
  ],
  [
    _*Virtual short*_:

    $
      v_("I"+) - v_("I"-) = v_"O" / A_v = 0
      quad ==> quad
      v_("I"+) = v_("I"-)
    $

    _*Virtual open*_:

    $
      i_"I" = (v_("I"+) - v_("I"-)) / R_"I"
      quad ==> quad
      i_"I" = 0
    $
  ],
)

#image("assets/Op Amp circuit model.png")

== Inverting Amplifier

#grid(
  columns: (1fr, 1.2fr),
  image("assets/Inverting Amplifier.png"),
  [
    *Input impedance*: $R_"I" = R_1$

    *Output impedance*: $R_"O" = 0$\
    It can be found by setting $v_"I" = 0$.\
    Implication: the output voltage is independent of the load current.
  ],
)

=== With infinite open-loop gain

By virtual short, $v_1 = v_2 = 0$.
#sym.space.quad
Closed-loop gain: $G = - R_2 / R_1$.

=== With finite open-loop gain

$A$ is finite, so virtual short does not hold.
$quad v_2 - v_1 = v_O / A != 0 quad ==> quad v_1 = - v_O / A != 0$.

Closed-loop gain: $G = (- R_2 slash R_1) / (1 + (1 + R_2 slash R_1) slash A)$.

To minimize the dependence of $G$ on the open-loop gain $A$, we need
$(1 + R_2 / R_1) << A$. Thus also $G << A$.

=== Weighted summer

#align(center, image("assets/Weighted Summer.png", width: 60%))

== Non-Inverting Amplifier

#grid(
  columns: (1fr, 2fr),
  image("assets/Non-Inverting Amplifier.png"),
  [
    *Input impedance*: $R_"I" = infinity$\
    For an ideal op amp, no current flows into the input terminals.

    *Output impedance*: $R_"O" = 0$\
    It can be found by setting $v_"I" = 0$.\
    Implication: the output voltage is independent of the load current.
  ],
)

=== With infinite open-loop gain

By virtual short, $v_1 = v_2 = v_"I"$.
#sym.space.quad
Closed-loop gain: $G = 1 + R_2 / R_1$.

=== With finite open-loop gain

$
  G = (1 + R_2 / R_1) / (1 + (1 + R_2 / R_1) slash A)
  quad quad quad
  "Percent gain error: "
  - (1 + R_2 slash R_1) / (A + 1 + R_2 slash R_1) times 100%
$

== Voltage Follower: Unity Gain Amplifier

#align(center, image("assets/Voltage Follower.png", width: 80%))

A buffer stage that present infinite input impedance to the source,
and zero output impedance to the load.

== Difference Amplifiers

#grid(
  columns: (1fr, 1fr),
  align: horizon + center,
  image("assets/Difference Amplifier.png", width: 60%),
  [
    with $R_1 = R_3$ and $R_2 = R_4$,
    $ v_"O" = R_2 / R_1 (v_"I2" - v_"I1") $
  ],
)

$
  "Differential gain: "
  A_"d" = R_2 / R_1
  quad quad quad quad
  "Common-mode gain: "
  A_"cm" = 0
$

=== Differential input resistance

Suppose the currents flowing through $R_1$ and $R_3$ are the same.

#image("assets/Differential Input Resistance.png", width: 50%)

Using KVL and virtual short,
$v_"Id" = R_1 i_"I" + 0 + R_1 i_"I"$,
we have
$ "Differential input resistance: " R_"Id" = 2 R_1 $

== Integrators and Differentiators

#grid(
  columns: (1fr, 1.5fr),
  align: center + horizon,
  image("assets/Op-Amp Integrators.png"),
  [
    $
      (V_"O" (j omega)) / (V_"I" (j omega)) = - 1 / (j omega R C) \
      abs((V_"O" (j omega)) / (V_"I" (j omega))) = 1 / (omega R C)
      quad quad
      angle((V_"O" (j omega)) / (V_"I" (j omega))) = pi / 2 \
      "Integrator freq: "
      omega_"int" = 1 / (R C)
      "(0 dB point)"
    $
  ],
)

#grid(
  columns: (1fr, 1.5fr),
  align: center + horizon,
  image("assets/Op-Amp Differentiators.png"),
  [
    $
      (V_"O" (j omega)) / (V_"I" (j omega)) = - j omega R C \
      abs((V_"O" (j omega)) / (V_"I" (j omega))) = omega R C
      quad quad
      angle((V_"O" (j omega)) / (V_"I" (j omega))) = -pi / 2 \
      "Differentiator time constant: "
      R C
    $
  ],
)

= Semiconductors


/ Conduction band (导带): the energy band in which electrons are free to move and conduct electricity.

/ Valence band (价带): the energy band in which electrons are bound to atoms and do not conduct electricity.

/ Forbidden band (禁带): the energy band between the conduction band and the valence band, where no electron states exist.

/ Donors (施主): impurities that donate electrons to the conduction band, e.g., P, As, Sb, etc.

/ Acceptors (受主): impurities that accept electrons from the valence band, e.g., B, Al, Ga, etc.

/ Intrinsic semiconductors (本征半导体): pure semiconductors without impurities, e.g., Si, Ge, GaAs, etc.

/ N-type semiconductors: semiconductors doped with donor impurities so that the majority carriers are of negative charge (electrons).

/ P-type semiconductors: semiconductors doped with acceptor impurities so that the majority carriers are of positive charge (holes).

== Energy and Carrier Concentrations

=== Energy Band Diagrams

#import "energy-bands.typ": doped-bands, fermi-energy, intrinsic-bands

#intrinsic-bands

#doped-bands

Donor electrons are excited from $E_D$ into the conduction band;
acceptors capture valence electrons at $E_A$, leaving mobile holes.
Occupied acceptor states are localized.

=== Fermi-Dirac Distribution

The Fermi-Dirac distribution function gives the probability that an electron state at energy $E$ is occupied by an electron:
$
  f(E) = 1 / (1 + exp((E - E_F) / (k_"B" T)))
$
And hole probability:
$ 1 - f(E) = 1 / (1 + exp((E_F - E) / (k_"B" T))) $
where $E_F$ is the *Fermi energy*, $k_"B"$ is the Boltzmann constant, and $T$ is the absolute temperature.

==== Fermi Energy

Fermi energy is the energy level where $f(E_F) = 0.5$.
It is a _virtual_ energy level between $E_C$ and $E_V$.
It is affected by the doping level.

#fermi-energy

The actual distribution of electrons is given by
the product of the Fermi-Dirac distribution function $f(E)$
and the density of states $g(E)$:
$ n(E) = g(E) f(E) $
In the forbidden band, $g(E) = 0$, so $n(E) = 0$ although $f(E)$ is non-zero.

=== Mass Action Law

When not heavily doped ($<= 10^17 " cm"^(-3)$),
the product of the electron and hole concentrations in a semiconductor is constant
at a given temperature, independent of the doping level:
$ n p = "constant" $
For intrinsic semiconductors, $n = p = n_i$, so
$ n p = n_i^2 $

For lowly doped semiconductors, the dopants are nearly all ionized, so
the concentrations of electrons and holes can also be approximated by
the concentrations of the donors and acceptors:
$
  "N-type:" quad quad n = N_D quad quad p = n_i^2 / N_D
  quad quad quad quad
  "P-type:" quad quad p = N_A quad quad n = n_i^2 / N_A
$

==== Concentrations of electrons and holes

$
  n = integral_(E_C)^(infinity) g_C (E) f(E) dif E
  quad quad quad quad
  p = integral_(-infinity)^(E_V) g_V (E) (1 - f(E)) dif E
$

When $E - E_F >> k_"B" T$ and $E_F - E_V >> k_"B" T$,
we can use the *Boltzmann approximation*:
$
  f(E) approx exp(-(E - E_F) / (k_"B" T)) \
  n approx N_C exp(-(E_C - E_F) / (k_"B" T))
  quad quad quad quad
  p approx N_V exp(-(E_F - E_V) / (k_"B" T))
$
where $N_C$ and $N_V$ are the effective density of states in the conduction band and valence band, respectively.
Thus
$
  n p approx N_C N_V exp(- E_g / (k_"B" T))
  quad quad "where" quad
  E_g = E_C - E_V
$
which is independent of the Fermi level $E_F$ and the doping level
(when the semiconductor is not heavily doped, $E_g$ is approximately constant).

==== Intrinsic carrier concentration (本征载流子浓度)

$
  n_i = B T^(3/2) exp(- E_g / (2 k_"B" T))
  quad quad "or" quad
  = sqrt(N_C N_V) exp(- E_g / (2 k_"B" T))
$
The number of free electrons or holes per unit volume in an intrinsic semiconductor at temperature $T$.

$n_i$ for silicon at room temperature (300 K) is about $qty("1.5e10", "cm^-3")$.

=== Boltzmann Approximation

At thermal equilibrium, the Boltzmann approximation applies to electrons
when $E_C - E_F >> k_"B" T$ and to holes when $E_F - E_V >> k_"B" T$.
When both conditions hold, the semiconductor is *nondegenerate*, and
$
  n approx n_i exp((E_F - E_i) / (k_"B" T))
  quad quad
  p approx n_i exp((E_i - E_F) / (k_"B" T))
$
where $n_i$ and $E_i$ are the intrinsic carrier concentration and
intrinsic Fermi level of the same material at temperature $T$.
If $E_F$ lies near or inside a band, the corresponding carriers become
*degenerate* (简并态), and the relevant exponential formula must be replaced
by full Fermi–Dirac statistics.

== Current Flow in Semiconductors

/ Drift current: the motion of charge carriers under the influence of an electric field.
/ Diffusion current: the motion of charge carriers due to a concentration gradient.

=== Drift Current

$I_"drift" = I_p + I_n$

$
  v_(p"-drift") = mu_p E
  quad quad quad quad
  v_(n"-drift") = - mu_n E
$
- $E$: the electric field.
- $mu_p$, $mu_n$: the mobility of holes and electrons, respectively.\
  In intrinsic Si, $mu_n approx 1350 unit("cm^2/V/s")$ and $mu_p approx 480 unit("cm^2/V/s")$.
$
  I_p = q p A v_(p"-drift") = q p A mu_p E
  quad quad quad quad
  I_n = (-q) n A v_(n"-drift") = q n A mu_n E
$
- $A$: the cross-sectional area of the semiconductor.
- $q = qty(1.602e-19, "C")$: the charge of an electron.
- $p$, $n$: the concentrations of holes and electrons, respectively.
$
  J_"drift" = q (p mu_p + n mu_n) E = sigma E
$
- $J = I slash A$: the current density.
- $sigma$: the electrical conductivity. ($unit("S/cm")$)
- $rho = 1 slash sigma$: the electrical resistivity. ($unit("O cm")$)

==== Temperature effect on conductivity

#figure(
  image("assets/Temperature effect on conductivity.png"),
)

=== Diffusion Current

$
  J_"diff" = J_(p"-diff") + J_(n"-diff")
$
$
  J_(p"-diff") = - q D_p (dif p(x)) / (dif x)
  quad quad quad quad
  J_(n"-diff") = q D_n (dif n(x)) / (dif x)
$
- $D_p$, $D_n$: the diffusion coefficients of holes and electrons, respectively. ($unit("cm^2/s")$)\
  In intrinsic Si, $D_n approx 35 unit("cm^2/s")$ and $D_p approx 12 unit("cm^2/s")$.

=== Einstein Relationship

$
  D_n / mu_n = D_p / mu_p = V_"T" := (k_"B" T) / q
$
- $V_"T"$: the thermal voltage, defined as the thermal energy per unit charge. \
  At room temperature (300 K), $V_"T" approx 25.9 unit("mV")$.
- $k_"B"$: the Boltzmann constant. ($unit("eV/K")$)

_Proof_ (about the electron current):

$
  J_n = J_(n"-drift") + J_(n"-diff")
  = q n(x) mu_n E + q D_n (dif n(x)) / (dif x)
$
In equilibrium, no net current flow:
$
  q n(x) mu_n E + q D_n (dif n(x)) / (dif x) = 0
$
Using the Boltzmann approximation:
$
  n(x) & = n_i exp((E_F - E_i (x)) / (k_"B" T)) quad quad &      quad "where" quad E_i (x) = E_i (x_0) - q dot phi.alt(x) \
       & = n_0 exp(phi.alt(x) / V_"T")                    & phi.alt "is the potential, " quad E = (dif phi.alt) / (dif x) \
  p(x) & = p_0 exp(- phi.alt(x) / V_"T")
$
$
  q n(x) mu_n E + q D_n (dif n(x)) / (dif phi.alt(x)) (dif phi.alt(x)) / (dif x) & = 0 \
                          quad ==> quad q n(x) mu_n E + q D_n (n(x)) / (V_"T") E & = 0 quad ==> quad D_n / mu_n = V_"T"
$

== PN Junctions

/ depletion region (耗尽区): approximately no free carriers; not electrically neutral
/ quasi-neutral region (准中性区): the region outside the depletion region, where the concentrations of electrons and holes are approximately equal to the dopant concentrations
/ built-in potential (内建电势): the potential difference across the depletion region

#figure(image("assets/image.png"))

=== Built-in Voltage

#figure(image("assets/PN_Junction.png", width: 50%))

(Considering the electron current only)
Under thermal equilibrium, $J_(n"-drift") + J_(n"-diff") = 0$:
$
  q n(x) mu_n E + q D_n (dif n(x)) / (dif x) = 0
$
Using Einstein relationship $V_"T" = D_n / mu_n$:
$
  - E dif x = V_"T" (dif n(x)) / (n(x))
  quad quad ==> quad quad
  integral_(-x_p)^(x_n) - E dif x = V_"T" integral_(n(-x_p))^(n(x_n)) (dif n(x)) / (n(x))
$
$
  "Built-in voltage: "
  V_0 = V(x_n) - V(-x_p) & = V_"T" ln n(x_n) / n(-x_p) \
                         & = V_"T" ln (N_D N_A) / n_i^2
$
where $n(x_n) = N_D$ and $n(-x_p) = n_i^2 / N_A$.

$N_D$ and $N_A$ are the dopant concentrations of the n-type and p-type semiconductors, respectively.

For holes, similarly, we have:
$
  V_0 = V_"T" ln p(-x_p) / p(x_n)
$
And equivalently, we have the minority carrier concentrations at the edges of the depletion region:
$
  p(-x_p) / p(x_n) = n(x_n) / n(-x_p) = #e^(V_0 slash V_"T") = exp((q V_0) / (k_"B" T))
$

=== Electrostatic Analysis

#figure(image("assets/PN_Junction.png", width: 50%))

Charge in the depletion region:
$
  [-x_p, 0]": " quad
  abs(Q_-) = q N_A x_p A
  quad quad quad quad quad
  [0, x_n]": " quad
  abs(Q_+) = q N_D x_n A \
  "Charge neutrality: " quad N_A x_p = N_D x_n
$

Gauss's law:
$integral.cont Vec(E) dot dif Vec(A) = Q / epsilon$,
where $Q$ is the total charge enclosed by the surface
and $Vec(E)$ is the electric field created by both the enclosed and external charges.

Permittivity in silicon: $epsilon_"Si" = 11.7 epsilon_0 = qty(8.854e-14, "F/cm")$

In one dimension (assuming all the electric field lines are parallel to the $x$-axis):
$
  E(x) dot A + E(-x_p) dot (-A) = (Q_((-x_p, x))) / epsilon_"Si"
$
Since $E(-x_p) = 0$,
$
  E(x) = cases(
    display((- q N_A (x + x_p)) / epsilon_"Si") quad quad & -x_p <= x <= 0, ,
    display((q N_D (x_n - x)) / epsilon_"Si") & quad space 0 <= x <= x_n
  )
$

#grid(
  columns: (1fr, 1fr),
  align: center + horizon,
  image("assets/PN_Junction EF.png", width: 70%), image("assets/PN_Junction V.png", width: 85%),
)

$
  V(x) = cases(
    display((q N_A (x + x_p)^2) / (2 epsilon_"Si")) & -x_p <= x <= 0, ,
    display(V_0 - (q N_D (x - x_n)^2) / (2 epsilon_"Si")) quad quad & quad space 0 <= x <= x_n
  )
$
$
  "Built-in voltage: "
  V_0 = V(x_n) - V(-x_p) = (q (N_A x_p^2 + N_D x_n^2)) / (2 epsilon_"Si") \
  "Depletion width: "
  W = x_n + x_p = sqrt((2 epsilon_"Si") / q ( 1 / N_A + 1 / N_D ) V_0) \
  x_p = (N_D / (N_A + N_D)) W
  quad quad quad quad
  x_n = (N_A / (N_A + N_D)) W \
$

#figure(image("assets/PN_Junction biased.png"))
$
  W = sqrt((2 epsilon_"Si") / q ( 1 / N_A + 1 / N_D ) (V_0 - V))
$
where $V$ is the applied voltage to the junction.

=== $I$-$V$ Characteristics

#figure(image("assets/image-1.png"))

The concentration of minority carriers can be found by solving the continuity equation with the boundary conditions.
Taking the electrons in the p-type region as an example:
$
  (partial n_p) / (partial t) = D_n (partial^2 n_p) / (partial x^2) - (n_p - n_(p 0)) / tau_n \
  "Steady state: " quad (partial n_p) / (partial t) = 0 \
  "Boundary conditions: " quad n_p |_(x=-x_p) = n_(p 0) #e^(V slash V_"T")
  quad quad n_p |_(x=-infinity) = n_(p 0)
$
- $n_(p 0)$: the equilibrium electron concentration in the p-type region.
- $tau_n$: the electron lifetime in the p-type region.
- $V$: the applied voltage to the junction.
- $L_n := sqrt(D_n tau_n)$: diffusion length.

The solution is
$
  n_p (x) = n_(p 0) + n_(p 0) ( #e^(V slash V_"T") - 1 ) #e^((x + x_p) slash L_n)
  quad quad x <= -x_p
$
Similarly, for holes in the n-type region:
$
  p_n (x) = p_(n 0) + p_(n 0) ( #e^(V slash V_"T") - 1 ) #e^(-(x - x_n) slash L_p)
  quad quad x >= x_n
$

Diffusion current at the edges of the depletion region:
$
  J_(n"-diff") |_(x=-x_p) = q D_n (dif n_p) / (dif x) |_(x=-x_p) = (q D_n n_(p 0)) / L_n ( #e^(V slash V_"T") - 1 ) \
  J_(p"-diff") |_(x=x_n) = - q D_p (dif p_n) / (dif x) |_(x=x_n) = (q D_p p_(n 0)) / L_p ( #e^(V slash V_"T") - 1 )
$

Some assumptions:
- The electric field in quasi-neutral regions is negligible.
  $ J_n approx J_(n"-diff") quad quad quad J_p approx J_(p"-diff") $
- The depletion region is narrow, so recombinations and generations of carriers in the depletion region are negligible.
  $ J_n (x_n) approx J_n (-x_p) quad quad quad J_p (x_n) approx J_p (-x_p) $

Then the total current:
$
  I = (J_n + J_p) A = I_S ( #e^(V slash V_"T") - 1 )
$
where $I_S$ is the reverse saturation current:
$
  I_S = A q (D_n n_(p 0) / L_n + D_p p_(n 0) / L_p)
  = A q n_i^2 (D_n / (L_n N_A) + D_p / (L_p N_D))
$
as $p_(n 0) = n_i^2 slash N_D$ and $n_(p 0) = n_i^2 slash N_A$.

#grid(
  columns: (1fr, 1fr),
  align: center + horizon,
  image("assets/image-2.png", width: 80%), image("assets/image-3.png", width: 80%),
)

Two types of reverse breakdown:

/ Zener breakdown (齐纳击穿): Carrier tunneling occurs due to a strong electric field.\
  Usually for $V_Z < 5 unit(V)$.
/ Avalanche breakdown (雪崩击穿): Carrier multiplication occurs due to impact ionization.\
  Usually for $V_Z > 7 unit(V)$.

Both breakdowns do not necessarily damage the junction as long as the current and time are limited.



