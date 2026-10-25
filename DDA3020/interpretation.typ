#import "@preview/ilm:2.1.1": *
#import "../common/style.typ"

#show: ilm.with(
  cover-page: none,
  table-of-contents: none,
  date: datetime(year: 2026, month: 10, day: 23),
)

#show: style.apply

#let Vec(v) = $bold(#v)$
#let UVec(v) = $accent(Vec(#v), hat)$

#let Mat(M) = $bold(#M)$

#let Var = $op("Var")$

#let argmax = $op("arg max", limits: #true)$
#let argmin = $op("arg min", limits: #true)$

= Models And Objectives

== The Model

$X$, $Y$, and $W$ are random variables.
The model describes the relationship between the input $x$ and the output $y$ parameterized by $w$:
$
  PP(Y = y | X = x, W = w)
$
where $x$, $y$, and $w$ are samples of $X$, $Y$, and $W$ respectively.

Given $x$ and $w$, the output $y$ is not deterministic, but rather a random variable with a distribution defined by the model.

- An assumption: $X$ is independent of $W$.

== Maximum Likelihood Estimation (MLE)

- The data observed: $cal(D) = (x_"o", y_"o")$
- The *likelihood* of observing the data given the model parameter $w$:
  $ L(w; cal(D)) := PP(Y = y_"o" | X = x_"o", W = w) $

_Note_: $L(w; cal(D)) != PP(cal(D) | W = w)$.

Then the optimal $w$ is given by:
$
  w_"MLE" & = argmax_w space L(w; cal(D)) \
          & = argmax_w space PP(Y = y_"o" | X = x_"o", W = w)
$
which is equivalent to minimizing the negative log-likelihood.

== Maximum a Posteriori (MAP) Estimation

MAP estimation is equivalent to MLE with a *prior distribution* on the model parameter $w$.

Applying Bayes' theorem on the *posterior distribution* of $W$ given the observed data $cal(D)$:
$
  PP(W = w | cal(D)) &= PP(W = w | X = x_"o", Y = y_"o") \
  &= PP(X = x_"o", Y = y_"o", W = w) / PP(X = x_"o", W = w) dot (PP(X = x_"o") PP(W = w)) / PP(X = x_"o", Y = y_"o") \
  &= PP(Y = y_"o" | X = x_"o", W = w) dot PP(W = w) / PP(Y = y_"o" | X = x_"o") \
$

Then the optimal $w$ is given by:
$
  w_"MAP" & = argmax_w space PP(W = w | cal(D)) \
          & = argmax_w space PP(Y = y_"o" | X = x_"o", W = w) dot PP(W = w) \
          & = argmax_w space L(w; cal(D)) dot PP(W = w)
$
where $PP(W = w)$ is the *prior distribution* of $W$.
