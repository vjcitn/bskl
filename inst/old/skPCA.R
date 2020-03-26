#' container for sklearn objects and transforms
#' @slot transform stored as R matrix
#' @slot method string identifying method
#' @slot object reference to the python object with decomposition components
#' @return the getTransformed method returns a matrix
#' @exportClass SkDecomp
#' @export getTransformed
#' @export pyobj
setClass("SkDecomp", representation(transform="ANY", object="ANY",
   method="character"))
setMethod("show", "SkDecomp", function(object) {
  cat("SkDecomp instance, method: ", object@method, "\n")
  cat("retrieve transformed data with getTransformed(),\n python reference with pyobj()\n")
})
setGeneric("getTransformed", function(x) standardGeneric("getTransformed"))
#' @rdname SkDecomp-class
#' @aliases getTransformed
#' @param x instance of SkDecomp
#' @exportMethod getTransformed
setMethod("getTransformed", "SkDecomp", function(x) x@transform)
setGeneric("pyobj", function(x) standardGeneric("pyobj"))
#' @rdname SkDecomp-class
#' @aliases pyobj
#' @exportMethod pyobj
setMethod("pyobj", "SkDecomp", function(x) x@object)

#' use sklearn PCA procedure
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @param \dots additional parameters passed to sklearn.decomposition.PCA, for additional information use \code{py_help(SklearnEls()$sk$PCA)}
#' @note If no additional arguments are passed, all defaults are used.
#' @return matrix with rotation
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' irismat = SklearnEls()$np$genfromtxt(irloc, delimiter=',')
#' skpi = skPCA(irismat)
#' getTransformed(skpi)[1:5,]
#' @export
skPCA = function(mat, ...) {
 skpc = SklearnEls()$skd$PCA(...)
 new("SkDecomp", method="PCA", transform=skpc$fit_transform(mat),
    object=skpc)
}
