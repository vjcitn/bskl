#' experimental basilisk approach to PCA
#' @import basilisk
#' @param mat R matrix
#' @param \dots pass python-specific args to sklearn.decomposition.PCA
#' @examples
#' irismat = data.matrix(iris[,1:4])
#' bpca(irismat)
#' @export
bpca = function(mat, ...) {
   proc = basilisk::basiliskStart(bsklenv)
   on.exit(basilisk::basiliskStop(proc))
   do_pca = basilisk::basiliskRun(proc, function(mat, ...) {
     sk = reticulate::import("sklearn") 
     op = sk$decomposition$PCA(...)
     op$fit_transform(mat)
   }, mat=mat, ...)
}

