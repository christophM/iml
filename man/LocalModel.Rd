% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LocalModel.R
\name{LocalModel}
\alias{LocalModel}
\title{LocalModel}
\format{\code{\link{R6Class}} object.}
\description{
\code{LocalModel} fits locally weighted linear regression models (logistic regression for classification) to explain single predictions of a prediction model.
}
\section{Usage}{

\preformatted{
lime = LocalModel$new(predictor, x.interest = NULL, k = 3 run = TRUE)

plot(lime)
predict(lime, newdata)
lime$results
lime$explain(x.interest)
print(lime)
}
}

\section{Arguments}{


For LocalModel$new():
\describe{
\item{predictor}{Object of type \code{Predictor}. See \link{Predictor}.}
\item{x.interest}{data.frame with a single row for the instance to be explained.}
\item{k}{the (maximum) number of features to be used for the surrogate model.}
\item{run}{logical. Should the Interpretation method be run?}
}
}

\section{Details}{
 
A weighted glm is fitted with the machine learning model prediction as target. 
Data points are weighted by their proximity to the instance to be explained, using the gower proximity measure. 
L1-regularisation is used to make the results sparse. 
The resulting model can be seen as a surrogate for the machine learning model, which is only valid for that one point.
Categorical features are binarized, depending on the category of the instance to be explained: 1 if the category is the same, 0 otherwise.
To learn more about local models, read the Interpretable Machine Learning book: https://christophm.github.io/interpretable-ml-book/lime.html

The approach is similar to LIME, but has the following differences:
\itemize{
\item Distance measure: Uses gower proximity (= 1 - gower distance) instead of a kernel based on the Euclidean distance. Has the advantage to have a meaningful neighbourhood and no kernel width to tune.
\item Sampling: Uses the original data instead of sampling from normal distributions. 
Has the advantage to follow the original data distribution. 
\item Visualisation: Plots effects instead of betas. Both are the same for binary features, but ared different for numerical features. 
For numerical features, plotting the betas makes no sense, 
because a negative beta might still increase the prediction when the feature value is also negative.
}
}

\section{Fields}{

\describe{
\item{best.fit.index}{The index of the best glmnet fit.}
\item{k}{The number of features as set by the user.}
\item{model}{The glmnet object.}
\item{predictor}{The prediction model that was analysed.}
\item{results}{data.frame with the feature names (\code{feature}) and contributions to the prediction}
\item{x.interest}{The data.frame with the instance to be explained. See Examples for usage.}
}
}

\section{Methods}{

\describe{
\item{explain(x.interest)}{method to set a new data point which to explain.}
\item{plot()}{method to plot the LocalModel feature effects. See \link{plot.LocalModel}}
\item{predict()}{method to predict new data with the local model See also \link{predict.LocalModel}}
\item{\code{run()}}{[internal] method to run the interpretability method. Use \code{obj$run(force = TRUE)} to force a rerun.}
\item{\code{clone()}}{[internal] method to clone the R6 object.}
\item{\code{initialize()}}{[internal] method to initialize the R6 object.}
}
}

\examples{
if (require("randomForest")) {
# First we fit a machine learning model on the Boston housing data
data("Boston", package  = "MASS")
X = Boston[-which(names(Boston) == "medv")]
rf = randomForest(medv ~ ., data = Boston, ntree = 50)
mod = Predictor$new(rf, data = X)

# Explain the first instance of the dataset with the LocalModel method:
x.interest = X[1,]
lemon = LocalModel$new(mod, x.interest = x.interest, k = 2)
lemon

# Look at the results in a table
lemon$results
# Or as a plot
plot(lemon)

# Reuse the object with a new instance to explain
lemon$x.interest
lemon$explain(X[2,])
lemon$x.interest
plot(lemon)
  
# LocalModel also works with multiclass classification
rf = randomForest(Species ~ ., data= iris, ntree=50)
X = iris[-which(names(iris) == 'Species')]
predict.fun = function(object, newdata) predict(object, newdata, type = "prob")
mod = Predictor$new(rf, data = X, predict.fun = predict.fun, class = "setosa")

# Then we explain the first instance of the dataset with the LocalModel method:
lemon = LocalModel$new(mod, x.interest = X[1,], k = 2)
lemon$results
plot(lemon) 
}
}
\references{
Ribeiro, M. T., Singh, S., & Guestrin, C. (2016). "Why Should I Trust You?": Explaining the Predictions of Any Classifier. Retrieved from http://arxiv.org/abs/1602.04938

Gower, J. C. (1971), "A general coefficient of similarity and some of its properties". Biometrics, 27, 623--637.
}
\seealso{
\code{\link{plot.LocalModel}} and \code{\link{predict.LocalModel}}

\code{\link{Shapley}} can also be used to explain single predictions

\code{\link[lime]{lime}}, the original implementation
}