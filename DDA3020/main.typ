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

#let Var = $op("Var")$

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
  hat(Vec(w)) = arg min_Vec(w) 1/m sum_(i=1)^m (f_Vec(w)(Vec(x)_i) - y_i)^2
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
given the training dataset $D = {(Vec(x)_i, y_i)}_(i=1)^m$:

$
  hat(Vec(w)) = arg max_Vec(w) space log cal(L)(Vec(w); D)
$
$
  "where" quad
  cal(L)(Vec(w); D) & = product_((Vec(x), y) in D) p(y; Vec(x), Vec(w)) \
                    & = product_(i=1)^m cal(N)(y_i; Vec(w)^top Vec(x)_i, sigma^2) \
                    & = product_(i=1)^m 1 / (sqrt(2 pi) sigma) exp(- (y_i - Vec(w)^top Vec(x)_i)^2 / (2 sigma^2))
$
which yields exactly the same solution as the deterministic perspective.

== Learning Algorithm

=== Least Squares

$
  hat(Vec(y)) = Mat(X) Vec(w)
  quad quad "where" quad
  Mat(X) = mat(
    bar.h, Vec(x)_1^top, bar.h;
    bar.h, Vec(x)_2^top, bar.h;
    , dots.v, ;
    bar.h, Vec(x)_m^top, bar.h
  ) in RR^(m times (d+1)),
  quad
  Vec(w) = vec(w_0, dots.v, w_d) in RR^(d+1).
$
$
  hat(Vec(w)) = arg min_Vec(w) norm(Mat(X) Vec(w) - Vec(y))_2^2
$
The least-squares objective is
$
        J(Vec(w)) & = ||Mat(X) Vec(w) - Vec(y)||_2^2 \
                  & = (Mat(X) Vec(w) - Vec(y))^top (Mat(X) Vec(w) - Vec(y)) \
                  & = Vec(w)^top Mat(X)^top Mat(X) Vec(w) - 2 Vec(y)^top Mat(X) Vec(w) + Vec(y)^top Vec(y) \
  nabla J(Vec(w)) & = 2 Mat(X)^top Mat(X) Vec(w) - 2 Mat(X)^top Vec(y) \
$
The Hessian, $nabla^2 J(Vec(w)) &= 2 Mat(X)^top Mat(X)$,
is positive semi-definite (SPD), so $J(Vec(w))$ is convex.
To find the optimal solution, we set the gradient to zero:
$
  nabla J(Vec(w)) = 0
  quad ==> quad
  Mat(X)^top Mat(X) Vec(w) = Mat(X)^top Vec(y)
$

If $Mat(X)^top Mat(X)$ is invertible, then
$
  hat(Vec(w)) = (Mat(X)^top Mat(X))^(-1) Mat(X)^top Vec(y)
$

If $Mat(X)^top Mat(X)$ is not invertible,
it indicates that the columns of $Mat(X)$ are linearly dependent,
and the solution is not unique.
The dimension of the feature space can be reduced by removing redundant features.

==== Distributional Properties

The probabilistic assumption

$
  Vec(y) = Mat(X) Vec(w) + Vec(e),
  quad quad "where" quad
  Vec(e) ~ cal(N)(Vec(0), sigma^2 Mat(I)_m)
$

Then the estimator $hat(Vec(w)) := (Mat(X)^top Mat(X))^(-1) Mat(X)^top Vec(y)$:

$
  hat(Vec(w)) space ~ space
  cal(N)(Vec(w), sigma^2 (Mat(X)^top Mat(X))^(-1))
$

/ Unbiasedness: $EE[hat(Vec(w))] = Vec(w)$.

/ Estimation of noise variance $sigma^2$:

  - $ hat(sigma)^2 = norm(Mat(X) hat(Vec(w)) - Vec(y))_2^2 / (m-d-1) $

  - The _degrees of freedom_, $(m - d - 1)$, is the number of observations minus the number of estimated parameters.

/ Gauss-Markov Theorem:

  - For any *linear unbiased estimator* $tilde(Vec(w))$, $Var(tilde(Vec(w))) succ.eq Var(hat(Vec(w)))$.\
    In other words, $Var(tilde(Vec(w))) - Var(hat(Vec(w)))$ is a positive semi-definite matrix.

  - An implication: $tr(Var(tilde(Vec(w)))) >= tr(Var(hat(Vec(w)))) = sigma^2 tr((Mat(X)^top Mat(X))^(-1))$,
    i.e., total variance of $hat(Vec(w))$ is minimized among all linear unbiased estimators.

=== Gradient Descent

$
  Vec(w)^* = arg min_Vec(w) J(Vec(w)),
  quad quad
  J(Vec(w))       & = 1/2 norm(Mat(X) Vec(w) - Vec(y))^2 \
  nabla J(Vec(w)) & = Mat(X)^top (Mat(X) Vec(w) - Vec(y))
$
Iteratively updates the model parameters in the opposite direction of the gradient:
$
  Vec(w) quad <- quad
  Vec(w) - eta nabla J(Vec(w))
$

#figure(
  table(
    columns: (1fr, 1fr),
    [Closed-form solution], [Gradient descent],
    [
      $
        hat(Vec(w)) quad = quad
        (Mat(X)^top Mat(X))^(-1) Mat(X)^top Vec(y)
      $
    ],
    [
      $
        Vec(w) quad <- quad
        Vec(w) - eta Mat(X)^top (Mat(X) Vec(w) - Vec(y))
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
  J(Vec(w)) = norm(Mat(X) Vec(w) - Vec(y))_2^2 + lambda norm(Vec(w))_2^2 \
  nabla J(Vec(w)) = 2 Mat(X)^top (Mat(X) Vec(w) - Vec(y)) + 2 lambda Vec(w)
$
Setting the gradient to zero yields the closed-form solution:
$
  hat(Vec(w))_"ridge" = (Mat(X)^top Mat(X) + lambda Mat(I)_(d+1))^(-1) Mat(X)^top Vec(y)
$

- For $lambda > 0$, $(Mat(X)^top Mat(X) + lambda Mat(I))$ is always positive definite (PD) and thus invertible.

- The bias term $w_0$ is usually excluded from the regularization.

==== Probabilistic Interpretation

$L_2$-regularization is equivalent to a Gaussian prior on $Vec(w)$.

In the Bayesian framework, the model parameters are treated as random variables.
(The randomness comes from our uncertainty of the model parameters, not from the observation noise.)
Therefore, we should consider the conditional distribution of $y$ given $Vec(w)$:
$ p(y | Vec(w); Vec(x)) = cal(N)(y_i; Vec(w)^top Vec(x)_i, sigma^2) $
$Vec(x)$ here is a parameter of the function $p$, not a random variable.

Assuming a Gaussian prior on the model parameters:
$ p(Vec(w)) = cal(N)(Vec(w); Vec(0), tau^2 Mat(I)_(d+1)) $
Since $Vec(w)$ dose not depend on $Vec(x)$, we have $p(Vec(w); Vec(x)) = p(Vec(w))$.
Thus the posterior distribution of $Vec(w)$ after observing the training dataset $D$ is
$
  p(Vec(w) | y; Vec(x)) & = p(y | Vec(w); Vec(x)) dot p(Vec(w)) / p(y; Vec(x)) \
$

Maximum a posteriori (MAP) estimation then gives
$
  hat(Vec(w))_"MAP" & = arg max_(Vec(w)) space sum_(i=1)^m log p(Vec(w) | y_i; Vec(x_i)) \
                    & = arg max_(Vec(w)) space sum_(i=1)^m lr([ log p(y | Vec(w); Vec(x)) + log p(Vec(w)) ], size: #200%) \
                    & = arg min_(Vec(w)) space sum_(i=1)^m (Vec(w)^top Vec(x_i) - y_i)^2 + lambda norm(Vec(w))_2^2
$

=== Lasso Regression

Replace the Gaussian prior with a Laplace prior on the model parameters:
$
  p(Vec(w)) = op("Laplace")(Vec(w); Vec(0), b) = (1 / (2 b))^d exp(- norm(Vec(w))_1 / b)
$

$
  hat(Vec(w))_"MAP" & = arg max_(Vec(w)) space sum_(i=1)^m lr([ log p(y | Vec(w); Vec(x)) + log p(Vec(w)) ], size: #200%) \
                    & = arg min_(Vec(w)) space sum_(i=1)^m (Vec(w)^top Vec(x_i) - y_i)^2 + lambda norm(Vec(w))_1 \
                    & = arg min_(Vec(w)) space norm(Mat(X) Vec(w) - Vec(y))_2^2 + lambda norm(Vec(w))_1
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
  $ J(Vec(w)) = sum_(i=1)^m abs(Vec(w)^top Vec(x_i) - y_i) $

- The Huber loss:
  $
    J(Vec(w)) = sum_(i=1)^m Lambda(Vec(w)^top Vec(x_i) - y_i)
    quad quad "where" quad
    Lambda(r) = cases(
      1/2 r^2 & "if" abs(r) <= delta,
      delta (abs(r) - 1/2 delta) quad & "otherwise"
    )
  $
