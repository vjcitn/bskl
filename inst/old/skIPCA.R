#' use sklearn IncrementalPCA procedure
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @param n_components number of PCA to retrieve
#' @param batch_size number of records to use at each iteration
#' @return matrix with rotation
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' irismat = SklearnEls()$np$genfromtxt(irloc, delimiter=',')
#' ski = skIncrPCA(irismat)
#' ski25 = skIncrPCA(irismat, batch_size=25L) # non-default
#' getTransformed(ski)[1:3,]
#' getTransformed(ski25)[1:3,]
#' @export
skIncrPCA = function(mat, n_components, batch_size) {
 if (is(mat, "matrix")) {
    nr = nrow(mat)
    nc = ncol(mat)
    }
 else if (is(mat, "numpy.ndarray")) {
    d = py_to_r(mat$shape)
    nr = d[[1]]
    nc = d[[2]]
    }
 if (missing(n_components)) n_components = as.integer(
     min(c(nc,nr)))
 if (missing(batch_size)) 
     batch_size = as.integer(min(c(nr, 5*nc)))
 skpc = SklearnEls()$skd$IncrementalPCA(n_components=n_components, 
     batch_size=batch_size)
 new("SkDecomp", transform=skpc$fit_transform(mat), object=skpc,
       method="IncrementalPCA")
}
