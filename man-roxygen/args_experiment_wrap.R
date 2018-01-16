#'@param object 
#'    Recommended are mlr WrappedModel and caret train object. \code{object} can also be 
#'    a function that predicts the outcome given features or anything with an S3 predict function,
#'    like an object from class lm.
#'@param X
#'    data.frame with the data for the prediction model
#'@param class In case of classification, class specifies the class for which to predict the probability. 
#' By default the first class in the prediction (first column) is chosen. 