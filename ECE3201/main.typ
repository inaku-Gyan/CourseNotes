#import "@preview/ilm:2.1.1": *

#set text(lang: "en")

#show: ilm.with(
  title: [ECE 3201\ Introduction to Microelectronic Circuits],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 09, day: 21),
)

#set math.equation(numbering: none)

= Introduction

== The Amplifier Model

- Voltage Gain: $display(A_v = v_"O" / v_"I")$

- Current Gain: $display(A_i = i_"O" / i_"I")$

- Power Gain: $A_P = A_v A_i$

Gain expressed in decibels (originally defined for the power gain, i.e., the power ratio):

- Power Gain: $display(A_P ("dB") = 10 lg abs(P_"O" / P_"I") = 10 lg abs(A_P))$

- Voltage Gain: $display(A_v ("dB") = 20 lg abs(A_v))$
- Current Gain: $display(A_i ("dB") = 20 lg abs(A_i))$

_Treating `(dB)` as an operator functioning on the value before it._

=== The power model

#image("assets/Amplifier Power.png", width: 50%)


- Power balance: $P_"dc" + P_"I" = P_"L" + P_"dissipated"$
- Total dc power delivered to the amplifier: $P_"dc" = V_"CC" I_"CC" + V_"EE" I_"EE"$

- Amplifier power efficiency: $display(eta := P_"L" / P_"dc" times 100%)$

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

    $display(
      v_("I"+) - v_("I"-) = v_"O" / A_v = 0
      quad ==> quad
      v_("I"+) = v_("I"-)
    )$

    _*Virtual open*_:

    $display(
      i_"I" = (v_("I"+) - v_("I"-)) / R_"I"
      quad ==> quad
      i_"I" = 0
    )$
  ],
)

#image("assets/Op Amp circuit model.png")

== Inverting Amplifier

#grid(
  columns: 2,
  align: horizon,
  [#image("assets/Inverting Amplifier.png")], [#image("assets/Inverting Amplifier 2.png")],
)

=== With infinite open-loop gain

By virtual short, $v_1 = v_2 = 0$.
#sym.space.quad
Closed-loop gain: $display(G = - R_2 / R_1)$.

=== With finite open-loop gain

$A$ is finite, so virtual short does not hold.
$quad display(v_2 - v_1 = v_O / A != 0 quad arrow.double.long quad v_1 = - v_O / A != 0)$.

Closed-loop gain: $display(G = (- R_2 slash R_1) / (1 + (1 + R_2 slash R_1) slash A))$.

To minimize the dependence of $G$ on the open-loop gain $A$, we need
$display((1 + R_2 / R_1) << A)$. Thus also $G << A$.

=== Weighted summer

#align(center, image("assets/Weighted Summer.png", width: 60%))

== Non-Inverting Amplifier

#align(center, image("assets/Non-Inverting Amplifier.png", width: 40%))

