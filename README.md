<h1>statistical-learning-and-econometrics-r</h1>
<p>Advanced statistical machine learning and econometric diagnostics suite in R: classification benchmarks, subset selection, shrinkage (Ridge, Lasso), dimension reduction (PCR, PLS), clustering, and residual hypothesis testing</p>

<h2>Project description</h2>
<p>This repository provides a modular, reproducible statistical computing suite implemented in R based on classical benchmarks from statistical learning and modern econometrics:</p>
<ol>
  <li>
    <dl>
      <dt><b>Supervised Classification Benchmarks:</b></dt>
      <dd>Evaluates Logistic GLM, Linear Discriminant Analysis (LDA), Quadratic Discriminant Analysis (QDA), and K-Nearest Neighbors (KNN).</dd>
      <dd>Benchmarks predictive accuracy across spatial crime rates (<code>Boston</code>) and financial market trend trajectories (<code>Weekly</code>).</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Model Selection &amp; Resampling Validation:</b></dt>
      <dd>Conducts Exhaustive, Forward Stepwise, and Backward Elimination subset selections via <code>leaps::regsubsets</code> across Mallows' $C_p$, BIC, and Adjusted $R^2$.</dd>
      <dd>Implements k-fold polynomial Cross-Validation via <code>boot::cv.glm</code> and stability checks on credit default predictions across randomized train/test seeds (<code>Default</code>).</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Regularized Shrinkage &amp; Latent Dimensions:</b></dt>
      <dd>Optimizes penalization hyperparameter $\lambda$ for Ridge ($\alpha = 0$) and Lasso ($\alpha = 1$) estimators using cross-validated <code>glmnet</code> paths.</dd>
      <dd>Applies Principal Components Regression (PCR) and Partial Least Squares (PLS) via <code>pls</code> to resolve collinear feature spaces on higher education enrollment (<code>College</code>).</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Unsupervised Clustering &amp; Silhouette Validation:</b></dt>
      <dd>Compares centroid-based K-Means against agglomerative hierarchical clustering with Ward's minimum variance criterion (<code>ward.D2</code>).</dd>
      <dd>Validates cluster partitioning and cohesion using Silhouette width metrics.</dd>
    </dl>
  </li>
  <li>
    <dl>
      <dt><b>Econometric Residual Diagnostics:</b></dt>
      <dd>Tests for 1st-order serial residual autocorrelation using the Durbin-Watson statistic (<code>lmtest::dwtest</code>).</dd>
      <dd>Evaluates error variance homoscedasticity across split sample subsets using the Goldfeld-Quandt test (<code>lmtest::gqtest</code>).</dd>
    </dl>
  </li>
</ol>

<h2>Project files</h2>
<table>
  <tr>
    <th colspan="2">statistical-learning-and-econometrics-r</th>
  </tr>
  <tr>
    <td>main.R</td>
    <td>Automated orchestrator installing dependencies and executing all 5 analytical pipelines</td>
  </tr>
  <tr>
    <td>scripts/01_classification_benchmarks.R</td>
    <td>Supervised classification benchmarks (GLM, LDA, QDA, KNN) on Boston and Weekly</td>
  </tr>
  <tr>
    <td>scripts/02_model_selection_validation.R</td>
    <td>Subset selection (exhaustive, forward, backward), cross-validation, and seed resampling</td>
  </tr>
  <tr>
    <td>scripts/03_shrinkage_dimension_reduction.R</td>
    <td>Penalized shrinkage (Ridge, Lasso) and latent factor models (PCR, PLS) on College</td>
  </tr>
  <tr>
    <td>scripts/04_unsupervised_clustering.R</td>
    <td>K-Means, Ward's hierarchical dendrograms, and Silhouette width validation</td>
  </tr>
  <tr>
    <td>scripts/05_econometric_diagnostics.R</td>
    <td>Durbin-Watson serial correlation and Goldfeld-Quandt heteroscedasticity testing</td>
  </tr>
  <tr>
    <td>README.md</td>
    <td>Architectural documentation and mathematical overview</td>
  </tr>
  <tr>
    <td>.gitignore</td>
    <td>Exclusion rules for R session artifacts, workspace files, and local logs</td>
  </tr>
</table>

<h2>Methodological Overview</h2>
<table>
  <tr>
    <th>Domain</th>
    <th>Algorithm / Test</th>
    <th>Statistical Criterion / Objective</th>
  </tr>
  <tr>
    <td><b>Classification</b></td>
    <td>Logistic GLM, LDA, QDA, KNN[span_73]</td>
    <td>Decision boundary threshold $P(Y=1|X) > 0.5$ and discriminant functions</td>
  </tr>
  <tr>
    <td><b>Selection</b></td>
    <td>Exhaustive &amp; Stepwise Subsets[span_79]</td>
    <td>$\min C_p = \frac{1}{n}(\text{RSS} + 2d\hat{\sigma}^2), \quad \min \text{BIC} = \frac{1}{n}(\text{RSS} + \log(n)d\hat{\sigma}^2)$</td>
  </tr>
  <tr>
    <td><b>Regularization</b></td>
    <td>Ridge &amp; Lasso (Elastic Net)</td>
    <td>$\min \left[ \text{RSS} + \lambda \sum \beta_j^2 \right]$ (Ridge) vs. $\min \left[ \text{RSS} + \lambda \sum |\beta_j| \right]$ (Lasso)</td>
  </tr>
  <tr>
    <td><b>Dimension Reduction</b></td>
    <td>PCR &amp; PLS</td>
    <td>Unsupervised principal directions (PCA) vs. supervised response-covariance directions</td>
  </tr>
  <tr>
    <td><b>Clustering</b></td>
    <td>Ward.D2 &amp; Silhouette</td>
    <td>$\min \Delta \text{ESS}$ linkage variance and cohesion-separation width $s(i) = \frac{b(i)-a(i)}{\max(a(i), b(i))}$</td>
  </tr>
  <tr>
    <td><b>Diagnostics</b></td>
    <td>Durbin-Watson &amp; Goldfeld-Quandt</td>
    <td>$d = \frac{\sum (e_t - e_{t-1})^2}{\sum e_t^2}$ (Autocorrelation) vs. $F = \frac{\text{RSS}_2 / df}{\text{RSS}_1 / df}$ (Heteroscedasticity)</td>
  </tr>
</table>

<h2>Installation and launch</h2>
<ol>
  <b>
    <li>
      <dl>
        <dt>Clone repository</dt>
        <dd><code>git clone https://github.com/Kyoryuu-lab/statistical-learning-and-econometrics-r.git</code></dd>
        <dd><code>cd statistical-learning-and-econometrics-r</code></dd>
      </dl>
    </li>
  </b>
  <b>
    <li>
      <dl>
        <dt>Execute unified pipeline</dt>
        <dd>Runs entirely via Rscript:</dd>
        <dd><code>Rscript main.R</code></dd>
      </dl>
    </li>
  </b>
</ol>
