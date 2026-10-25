#import "@preview/ilm:2.1.1": *
#import "../common/style.typ"

#show: ilm.with(
  title: [DDA 3020\ Machine Learning],
  authors: "Yiqing Shao",
  date: datetime(year: 2026, month: 09, day: 25),
)

#show: style.apply

#let Vec(v) = $bold(#v)$
#let UVec(v) = $accent(Vec(#v), hat)$

#let Mat(M) = $bold(#M)$

#let diag = $op("diag")$

#let Var = $op("Var")$

#let Bias = $op("Bias")$

#let argmax = $op("arg max", limits: #true)$
#let argmin = $op("arg min", limits: #true)$

#let obs(x) = $accent(#x, paren.t)$

= Introduction

#figure(table(
  align: center + horizon,
  columns: 3,
  rows: 3,
  [], [Supervised Learning], [Unsupervised Learning],
  smallcaps([Discrete]), [Classification], [Clustering],
  smallcaps([Continuous]), [Regression], [Dimensionality Reduction],
))

= Linear Regression

Observed inputs and outputs are written as $obs(Vec(x))_i$ and $obs(y)_i$,
with stacked data $obs(Mat(X))$ and $obs(Vec(y))$.

== Model and Objective

The linear hypothesis function:

$
  f_Vec(w)(Vec(x)) = Vec(w)^top Vec(x),
  quad quad "where" quad
  Vec(w) = vec(w_0, w_1, dots.v, w_d)
  quad "and" quad
  Vec(x) = vec(1, x_1, dots.v, x_d)
$

=== Deterministic Perspective

_*Target*:
*Minimize the cost/loss* w.r.t. the model parameters._

$
  hat(Vec(w)) = argmin_Vec(w) 1/m sum_(i=1)^m (f_Vec(w)(obs(Vec(x))_i) - obs(y)_i)^2
$
where
- the _loss function_: squared error loss
- the _cost function_: the empirical risk (the average loss over the training set)

=== Probabilistic Perspective

_*Target*:
*Maximize the probability of the observed data* w.r.t. the parameters._

Assuming the relationship between the input and output is linear with Gaussian noise:

$
  y = Vec(w)^top Vec(x) + e,
  quad quad "where" quad
  e ~ cal(N)(0, sigma^2)
$
where $e$ is called *observation noise* or *residual error*,
and is independent of the input $Vec(x)$.
Thus the pdf of $y$ given $Vec(x)$ and $Vec(w)$ is Gaussian:
$
  p(y; Vec(x), Vec(w)) = cal(N)(y; Vec(w)^top Vec(x), sigma^2)
$

The parameter can be learned by *maximum (log-)likelihood estimation (MLE)*,
given the training dataset $D = {(obs(Vec(x))_i, obs(y)_i)}_(i=1)^m$:

$
  hat(Vec(w)) = argmax_Vec(w) space log cal(L)(Vec(w); D)
$
$
  "where" quad
  cal(L)(Vec(w); D) & = product_((obs(Vec(x)), obs(y)) in D) p(obs(y); obs(Vec(x)), Vec(w)) \
  & = product_(i=1)^m cal(N)(obs(y)_i; Vec(w)^top obs(Vec(x))_i, sigma^2) \
  & = product_(i=1)^m 1 / (sqrt(2 pi) sigma) exp(- (obs(y)_i - Vec(w)^top obs(Vec(x))_i)^2 / (2 sigma^2))
$
which yields exactly the same solution as the deterministic perspective.

== Learning Algorithm

=== Least Squares

$
  hat(Vec(y)) = obs(Mat(X)) Vec(w)
  quad quad "where" quad
  obs(Mat(X)) = mat(
    bar.h, obs(Vec(x))_1^top, bar.h;
    bar.h, obs(Vec(x))_2^top, bar.h;
    , dots.v, ;
    bar.h, obs(Vec(x))_m^top, bar.h
  ) in RR^(m times (d+1)),
  quad
  Vec(w) = vec(w_0, dots.v, w_d) in RR^(d+1).
$
$
  hat(Vec(w)) = argmin_Vec(w) norm(obs(Mat(X)) Vec(w) - obs(Vec(y)))_2^2
$
The least-squares objective is
$
  J(Vec(w)) & = ||obs(Mat(X)) Vec(w) - obs(Vec(y))||_2^2 \
  & = (obs(Mat(X)) Vec(w) - obs(Vec(y)))^top (obs(Mat(X)) Vec(w) - obs(Vec(y))) \
  & = Vec(w)^top obs(Mat(X))^top obs(Mat(X)) Vec(w) - 2 obs(Vec(y))^top obs(Mat(X)) Vec(w) + obs(Vec(y))^top obs(Vec(y)) \
  gradient J(Vec(w)) & = 2 obs(Mat(X))^top obs(Mat(X)) Vec(w) - 2 obs(Mat(X))^top obs(Vec(y)) \
$
The Hessian, $gradient^2 J(Vec(w)) &= 2 obs(Mat(X))^top obs(Mat(X))$,
is positive semi-definite (SPD), so $J(Vec(w))$ is convex.
To find the optimal solution, we set the gradient to zero:
$
  gradient J(Vec(w)) = 0
  quad ==> quad
  obs(Mat(X))^top obs(Mat(X)) Vec(w) = obs(Mat(X))^top obs(Vec(y))
$

If $obs(Mat(X))^top obs(Mat(X))$ is invertible, then
$
  hat(Vec(w)) = (obs(Mat(X))^top obs(Mat(X)))^(-1) obs(Mat(X))^top obs(Vec(y))
$

If $obs(Mat(X))^top obs(Mat(X))$ is not invertible,
it indicates that the columns of $obs(Mat(X))$ are linearly dependent,
and the solution is not unique.
The dimension of the feature space can be reduced by removing redundant features.

==== Distributional Properties

Here $Vec(y)$ denotes the random response vector, whose observed realization is $obs(Vec(y))$.
The probabilistic assumption

$
  Vec(y) = obs(Mat(X)) Vec(w) + Vec(e),
  quad quad "where" quad
  Vec(e) ~ cal(N)(Vec(0), sigma^2 Mat(I)_m)
$

Then the estimator $hat(Vec(w)) := (obs(Mat(X))^top obs(Mat(X)))^(-1) obs(Mat(X))^top Vec(y)$:

$
  hat(Vec(w)) space ~ space
  cal(N)(Vec(w), sigma^2 (obs(Mat(X))^top obs(Mat(X)))^(-1))
$

/ Unbiasedness: $Bias[hat(Vec(w))] := EE[hat(Vec(w))] - Vec(w) = 0$.

/ Estimation of noise variance $sigma^2$:

  - $ hat(sigma)^2 = norm(obs(Mat(X)) hat(Vec(w)) - obs(Vec(y)))_2^2 / (m-d-1) $

  - The _degrees of freedom_, $(m - d - 1)$, is the number of observations minus the number of estimated parameters.

/ Gauss-Markov Theorem:

  - For any *linear unbiased estimator* $tilde(Vec(w))$, $Var(tilde(Vec(w))) succ.eq Var(hat(Vec(w)))$.\
    In other words, $Var(tilde(Vec(w))) - Var(hat(Vec(w)))$ is a positive semi-definite matrix.

  - An implication: $tr(Var(tilde(Vec(w)))) >= tr(Var(hat(Vec(w)))) = sigma^2 tr((obs(Mat(X))^top obs(Mat(X)))^(-1))$,
    i.e., total variance of $hat(Vec(w))$ is minimized among all linear unbiased estimators.

=== Gradient Descent

$
  Vec(w)^* = argmin_Vec(w) J(Vec(w)),
  quad quad
  J(Vec(w))          & = 1/2 norm(obs(Mat(X)) Vec(w) - obs(Vec(y)))^2 \
  gradient J(Vec(w)) & = obs(Mat(X))^top (obs(Mat(X)) Vec(w) - obs(Vec(y)))
$
Iteratively updates the model parameters in the opposite direction of the gradient:
$
  Vec(w) quad <- quad
  Vec(w) - eta gradient J(Vec(w))
$

#figure(
  table(
    columns: (1fr, 1fr),
    [Closed-form solution], [Gradient descent],
    [
      $
        hat(Vec(w)) quad = quad
        (obs(Mat(X))^top obs(Mat(X)))^(-1) obs(Mat(X))^top obs(Vec(y))
      $
    ],
    [
      $
        Vec(w) quad <- quad
        Vec(w) - eta obs(Mat(X))^top (obs(Mat(X)) Vec(w) - obs(Vec(y)))
      $
    ],

    [ $ cal(O)(d^3 + m d^2) $], [ $ cal(O)(T dot m d) $ ],
  ),
)

Gradient descent works well for high-dimensional data,
i.e., when $d$ is very large.

== Variants

=== Polynomial Regression

For $d$-dimensional input $Vec(x) = mat(x_1, x_2, dots.c, x_d)^top$,
$
  f_Vec(w)(Vec(x)) & = w_0 + sum_(i=1)^d w_i x_i
                     + sum_(i <= j) w_(i j) x_i x_j
                     + sum_(i <= j <= k) w_(i j k) x_i x_j x_k
                     + dots.c \
                   & = Vec(w)^top Vec(phi.alt)(Vec(x))
$
$
  "where" quad
  Vec(phi.alt)(Vec(x)) & = mat(
                           1, x_1, dots.c, x_d,
                           dots.c, x_i x_j, dots.c, x_i x_j x_k, dots.c
                         )^top \
                Vec(w) & = mat(
                           w_0, w_1, dots.c, w_d,
                           dots.c, w_(i j), dots.c, w_(i j k), dots.c
                         )^top
$
Suppose the highest order of $f_Vec(w)(Vec(x))$ is $p$,
then the dimension of the feature space is $binom(d+p, d)$.
(The number of distinct monomials in $f_Vec(w)(Vec(x))$,
or the dimension of $Vec(w)$.)

=== Ridge Regression

Also known as $L_2$-regularized least squares regression.

Compared to the ordinary least squares (OLS) regression,
ridge regression additionally penalizes large parameter values:
$
  J(Vec(w)) = norm(obs(Mat(X)) Vec(w) - obs(Vec(y)))_2^2 + lambda norm(Vec(w))_2^2 \
  gradient J(Vec(w)) = 2 obs(Mat(X))^top (obs(Mat(X)) Vec(w) - obs(Vec(y))) + 2 lambda Vec(w)
$
Setting the gradient to zero yields the closed-form solution:
$
  hat(Vec(w))_"ridge" = (obs(Mat(X))^top obs(Mat(X)) + lambda Mat(I)_(d+1))^(-1) obs(Mat(X))^top obs(Vec(y))
$

- For $lambda > 0$, $(obs(Mat(X))^top obs(Mat(X)) + lambda Mat(I))$ is always positive definite (PD) and thus invertible.

- The bias term $w_0$ is usually excluded from the regularization.

==== Probabilistic Interpretation

$L_2$-regularization is equivalent to a Gaussian prior on $Vec(w)$.

In the Bayesian framework, the model parameters are treated as random variables.
(The randomness comes from our uncertainty of the model parameters, not from the observation noise.)
Therefore, we should consider the conditional distribution of $y$ given $Vec(w)$:
$ p(y | Vec(w); Vec(x)) = cal(N)(y; Vec(w)^top Vec(x), sigma^2) $
$Vec(x)$ here is a parameter of the function $p$, not a random variable.

Assuming a Gaussian prior on the model parameters:
$ p(Vec(w)) = cal(N)(Vec(w); Vec(0), tau^2 Mat(I)_(d+1)) $
Since $Vec(w)$ dose not depend on $Vec(x)$, we have $p(Vec(w); Vec(x)) = p(Vec(w))$.
Thus the posterior distribution of $Vec(w)$ after observing the training dataset $D$ is
$
  p(Vec(w) | obs(y); obs(Vec(x))) & = p(obs(y) | Vec(w); obs(Vec(x))) dot p(Vec(w)) / p(obs(y); obs(Vec(x))) \
$

Maximum a posteriori (MAP) estimation then gives
$
  hat(Vec(w))_"MAP" & = argmax_(Vec(w)) space sum_(i=1)^m log p(Vec(w) | obs(y)_i; obs(Vec(x))_i) \
  & = argmax_(Vec(w)) space sum_(i=1)^m lr([ log p(obs(y)_i | Vec(w); obs(Vec(x))_i) + log p(Vec(w)) ], size: #200%) \
  & = argmin_(Vec(w)) space sum_(i=1)^m (Vec(w)^top obs(Vec(x))_i - obs(y)_i)^2 + lambda norm(Vec(w))_2^2
$

=== Lasso Regression

Replace the Gaussian prior with a Laplace prior on the model parameters:
$
  p(Vec(w)) = op("Laplace")(Vec(w); Vec(0), b) = (1 / (2 b))^d exp(- norm(Vec(w))_1 / b)
$

$
  hat(Vec(w))_"MAP" & = argmax_(Vec(w)) space sum_(i=1)^m lr([ log p(obs(y)_i | Vec(w); obs(Vec(x))_i) + log p(Vec(w)) ], size: #200%) \
  & = argmin_(Vec(w)) space sum_(i=1)^m (Vec(w)^top obs(Vec(x))_i - obs(y)_i)^2 + lambda norm(Vec(w))_1 \
  & = argmin_(Vec(w)) space norm(obs(Mat(X)) Vec(w) - obs(Vec(y)))_2^2 + lambda norm(Vec(w))_1
$

It is also called $L_1$-regularization.
It encourages sparse solutions, i.e., many parameters are exactly zero.

=== Robust Linear Regression

When there are a few outliers in the training dataset, which are far from
most other points, then the learned parameters $w_"MLE"$ will be significantly
influenced, leading to a very poor fit.

To alleviate the significant influence of outliers, we replace the $L_2$ loss with some other loss function,
for example:

- The $L_1$ loss (absolute error loss):
  $ J(Vec(w)) = sum_(i=1)^m abs(Vec(w)^top obs(Vec(x))_i - obs(y)_i) $

- The Huber loss:
  $
    J(Vec(w)) = sum_(i=1)^m Lambda(Vec(w)^top obs(Vec(x))_i - obs(y)_i)
    quad quad "where" quad
    Lambda(r) = cases(
      1/2 r^2 & "if" abs(r) <= delta,
      delta (abs(r) - 1/2 delta) quad & "otherwise"
    )
  $

= Linear Classification

== Logistic Regression

==== Probabilistic Model

With $Vec(w)$ as the model parameters,
the relationship between the input $Vec(x) in RR^(d+1)$ and the output $y in {0, 1}$ is modeled as
$
  y | Vec(x) ~ op("Bernoulli")(p)
  quad quad "where" quad
  p := sigma(Vec(w)^top Vec(x)) \
  PP(y | Vec(x); Vec(w)) = p^y (1-p)^(1-y)
  = cases(
    p & "if" y = 1,
    1 - p quad & "if" y = 0
  )
$
where the logistic or sigmoid function is defined as
$
  sigma(r) := 1 / (1 + exp(-r))
$

==== Odds and Logit

For $p = sigma(Vec(w)^top Vec(x))$, we have
$ log p / (1-p) = Vec(w)^top Vec(x) $
- $p slash (1-p)$ is called the _odds (几率)_;
- $log(p slash (1-p))$ is called the _log-odds (对数几率)_, or _logit_.

==== From MLE to Cross-Entropy Loss

For $m$ independent observations:
$
  PP(obs(Vec(y)) | obs(Mat(X)); Vec(w)) = product_(i=1)^m p_i^(obs(y)_i) (1-p_i)^(1-obs(y)_i)
$
Then MLE gives the binary cross-entropy loss:
$
  J(Vec(w)) = - 1/m sum_(i=1)^m [obs(y)_i log p_i + (1-obs(y)_i) log (1-p_i)]
$
where $p_i = sigma(Vec(w)^top obs(Vec(x))_i)$.

==== Gradient Descent

$
  Vec(w) quad <- quad
  Vec(w) - eta gradient J(Vec(w))
$

Since $sigma'(r) = sigma(r)(1 - sigma(r))$, the chain rule gives
$
  gradient J(Vec(w)) & = 1/m sum_(i=1)^m (p_i - obs(y)_i) obs(Vec(x))_i \
                     & = 1/m obs(Mat(X))^top (Vec(p) - obs(Vec(y))) \
          "gradient" & = "feature" times ("prediction" - "target")
$

The Hessian:
$
  gradient^2 J(Vec(w)) = 1/m obs(Mat(X))^top Mat(R) obs(Mat(X))
  quad quad "where" quad
  Mat(R) = diag(p_1 (1-p_1), dots.c, p_m (1-p_m))
$
Since $p_i (1-p_i) > 0$, we have
$
  Mat(R) succ.eq 0
  quad ==> quad
  gradient^2 J(Vec(w)) succ.eq 0
$
Thus $J(Vec(w))$ is convex,
and gradient descent converges to the global minimum.

== Softmax Regression

Logistic regression handles only binary classification problems.
Multi-class classification requires a probability distribution over C classes:
$
  sum_(c=1)^C PP(y = c | Vec(x)) = 1
$

=== One-vs-Rest (OvR) Logistic Regression

Suppose $y in {1, 2, ..., C}$.

Train $C$ independent binary classifiers, each of which distinguishes one class from the rest:
$
  PP(y = c | Vec(x); Vec(w)_c) = sigma(Vec(w)_c^top Vec(x))
$
For a new input $Vec(x)$, the predicted class is
$
  hat(y) = argmax_(c in {1, 2, ..., C}) PP(y = c | Vec(x); Vec(w)_c)
$

Limitation: The predicted probabilities do not sum to 1.

=== Softmax Regression

The predicted class probabilities of sample $obs(Vec(x))_i$:
$
  Vec(p)_i = mat(p_(i 1), p_(i 2), dots.c, p_(i C))^top \
  p_(i c) =
  PP(y = c | obs(Vec(x))_i; Mat(W)) =
  exp(Vec(w)_c^top obs(Vec(x))_i) / (sum_(j=1)^C exp(Vec(w)_j^top obs(Vec(x))_i)) \
  Mat(W) = mat(Vec(w)_1, Vec(w)_2, dots.c, Vec(w)_C)
  in RR^((d+1) times C)
$

One-hot encoding of the true class label $obs(Vec(y))_i$:
$
  obs(Vec(y))_i = mat(obs(y)_(i 1), obs(y)_(i 2), dots.c, obs(y)_(i C))^top
  quad quad "where" quad
  obs(y)_(i c) = cases(
    1 & "if" obs(Vec(x))_i "belongs to class" c,
    0 quad & "otherwise"
  )
$

The negative log-likelihood of a sample of class $c$ is
$
  -log L(Vec(w)_c; obs(Vec(x))_i, obs(Vec(y))_i) =
  -log PP(obs(Vec(y))_i | obs(Vec(x))_i; Vec(w)_c) = -log p_(i c)
$
which is equivalent to the cross-entropy loss:
$
  -log p_(i c) = - sum_(j=1)^C obs(y)_(i j) log p_(i j)
$
Thus minimizing the cross-entropy loss is equivalent to maximizing the likelihood of the observed data.

For the whole training dataset then:
$
  J(Mat(W)) = - 1/m sum_(i=1)^m sum_(j=1)^C obs(y)_(i j) log p_(i j)
$

Gradient descent:
$
  Vec(w)_c quad <- quad
  Vec(w)_c - eta dot (partial J(Mat(W))) / (partial Vec(w)_c)
$
$
  (partial J(Mat(W))) / (partial Vec(w)_c) & = 1/m sum_(i=1)^m (p_(i c) - obs(y)_(i c)) obs(Vec(x))_i \
                                "gradient" & = "feature" times ("prediction" - "target")
$

== Regularization

$L_2$-regularized logistic regression:
$
  J(Vec(w)) = - 1/m sum_(i=1)^m [obs(y)_i log p_i + (1-obs(y)_i) log (1-p_i)] + lambda / (2 m) sum_(j=1)^d w_j^2
$
The bias term $w_0$ is usually excluded from the regularization.

For $j = 1, 2, dots, d$:
$
  w_j quad <- quad
  w_j - eta / m [sum_(i=1)^m (p_i - obs(y)_i) obs(x)_(i j) + lambda w_j]
$

= Generalization and Model Selection

== Bias-Variance Tradeoff

=== Bias-Variance Decomposition

Suppose that

- the training dataset $D = {(obs(Vec(x))_i, obs(y)_i)}_(i=1)^m$ is drawn i.i.d. from some joint distribution $p(Vec(x), y)$;

- the true relationship between the input and output is
  $
    y = f(Vec(x)) + e quad quad e ~ N(0, sigma^2) "is the irreducible noise," \
    PP(y | Vec(x)) = cal(N)(y; f(Vec(x)), sigma^2)
    quad quad EE_(y | Vec(x)) [y] = f(Vec(x))
  $

- the learned hypothesis function is $h_D (Vec(x))$,
  and the expected hypothesis function is
  $ dash(h)(Vec(x)) := EE_D [h_D (Vec(x))] = sum_(D ~ p^(m)) h_D (Vec(x)) PP(D) $.

- $(Vec(x), y)$ is the test sample drawn from the same distribution,
  and then the expected test error is
  $
    EE_(D, (Vec(x), y)) [(h_D (Vec(x)) - y)^2] &= sum_(D ~ p^(m), space (Vec(x), y) ~ p) (h_D (Vec(x)) - y)^2 PP(D, (Vec(x), y)) \
    &= sum_((Vec(x), y) ~ p) sum_(D ~ p^(m)) (h_D (Vec(x)) - y)^2 PP(D) p(Vec(x), y) \
    &= EE_((Vec(x), y)) [EE_D [(h_D (Vec(x)) - y)^2]] \
  $

*Bias-Variance Decomposition* states:

#[
  #let R(content) = text(content, fill: red)
  $
    #R("Expected test error") &= #h(3em) #R("Variance") #h(3.6em) + #h(2em) #R($"Bias"^2$) quad + quad #R("Irreducible noise") \
    limits(EE)_(D, (Vec(x), y)) [(h_D (Vec(x)) - y)^2] &= limits(EE)_(D, (Vec(x), y)) [(h_D (Vec(x)) - dash(h)(Vec(x)))^2] + limits(EE)_((Vec(x), y)) [(dash(h)(Vec(x)) - f(Vec(x)))^2] + sigma^2 \
  $
  where $sigma^2 = EE_((Vec(x), y)) [(f(Vec(x))-y)^2]$.
]

== Model Selection

=== $K$-Fold Cross-Validation

#figure(table(
  align: center + horizon,
  columns: (1fr, 1fr, 1fr, 1.2fr, 1fr, 1.5fr),
  [Fold $1$], [Fold $2$], [Fold $3$], [#sym.dots.c], [Fold $K$], [Test Set],
))

- Each fold is used as the validation set once;
- Each fold is used as the training set $K-1$ times.
