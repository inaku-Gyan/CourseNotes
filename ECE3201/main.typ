#import "@preview/ilm:2.1.1": *
#import "@preview/unify:0.8.1": qty, unit
#import "../common/style.typ"

#show: ilm.with(
  title: [ECE 3201\ Introduction to Microelectronic Circuits],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 09, day: 21),
)

#show: style.apply

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
  f(E) = 1 / (1 + exp((E - E_F) / (k_B T)))
$
And hole probability:
$ 1 - f(E) = 1 / (1 + exp((E_F - E) / (k_B T))) $
where $E_F$ is the *Fermi energy*, $k_B$ is the Boltzmann constant, and $T$ is the absolute temperature.

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

When $E - E_F >> k_B T$ and $E_F - E_V >> k_B T$,
we can use the *Boltzmann approximation*:
$
  f(E) approx exp(-(E - E_F) / (k_B T)) \
  n approx N_C exp(-(E_C - E_F) / (k_B T))
  quad quad quad quad
  p approx N_V exp(-(E_F - E_V) / (k_B T))
$
where $N_C$ and $N_V$ are the effective density of states in the conduction band and valence band, respectively.
Thus
$
  n p approx N_C N_V exp(- E_g / (k_B T))
  quad quad "where" quad
  E_g = E_C - E_V
$
which is independent of the Fermi level $E_F$ and the doping level
(when the semiconductor is not heavily doped, $E_g$ is approximately constant).

==== Intrinsic carrier concentration (本征载流子浓度)

$
  n_i = B T^(3/2) exp(- E_g / (2 k_B T))
  quad quad "or" quad
  = sqrt(N_C N_V) exp(- E_g / (2 k_B T))
$
The number of free electrons or holes per unit volume in an intrinsic semiconductor at temperature $T$.

$n_i$ for silicon at room temperature (300 K) is about $qty("1.5e10", "cm^-3")$.

=== Boltzmann Approximation

When $E - E_F >> k_B T$ and $E_F - E_V >> k_B T$,
the concentrations of electrons and holes can be approximated by the Boltzmann distribution:
$
  n = n_i exp((E_F - E_i) / (k_B T))
  quad quad quad quad
  p = n_i exp((E_i - E_F) / (k_B T))
$
where $E_i$ is the intrinsic Fermi level,
which is the Fermi level of an intrinsic semiconductor at a given temperature.

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
  D_n / mu_n = D_p / mu_p = V_T := (k_B T) / q
$
- $V_T$: the thermal voltage, defined as the thermal energy per unit charge. \
  At room temperature (300 K), $V_T approx 25.9 unit("mV")$.
- $k_B$: the Boltzmann constant. ($unit("eV/K")$)

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
  n(x) & = n_i exp((E_F - E_i (x)) / (k_B T)) quad quad &      quad "where" quad E_i (x) = E_i (x_0) - q dot phi.alt(x) \
       & = n_0 exp(phi.alt(x) / V_T)                    & phi.alt "is the potential, " quad E = (dif phi.alt) / (dif x) \
  p(x) & = p_0 exp(- phi.alt(x) / V_T)
$
$
  q n(x) mu_n E + q D_n (dif n(x)) / (dif phi.alt(x)) (dif phi.alt(x)) / (dif x) & = 0 \
                            quad ==> quad q n(x) mu_n E + q D_n (n(x)) / (V_T) E & = 0 quad ==> quad D_n / mu_n = V_T
$
