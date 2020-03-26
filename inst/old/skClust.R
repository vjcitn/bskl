#' interface to sklearn.cluster.KMeans with attention to direct work with HDF5
#' @param mat a matrix-like datum or reference to such
#' @param \dots arguments to sklearn.cluster.KMeans
#' @note You can use `py_help(SklearnEls()$skcl$KMeans)` to
#' get python documentation on parameters and return structure.
#'
#' @examples
#' # start with numpy array reference as data
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' skels = SklearnEls()
#' irismat = skels$np$genfromtxt(irloc, delimiter=',')
#' ans = skKMeans(irismat, n_clusters=2L)
#' names(ans) # names of available result components
#' table(iris$Species, ans$labels_)
#' # now use an HDF5 reference
#' irh5 = system.file("hdf5/irmat.h5", package="BiocSklearn")
#' fref = skels$h5py$File(irh5)
#' ds = fref$`__getitem__`("quants") # thanks Samuela Pollack!
#' ans2 = skKMeans(skels$np$array(ds)$T, n_clusters=2L) # HDF5 matrix is transposed relative to python array layout!  Is the np$array conversion unduly costly?
#' table(ans$labels_, ans2$labels_)
#' ans3 = skKMeans(skels$np$array(ds)$T, 
#'    n_clusters=8L, max_iter=200L, 
#'    algorithm="full", random_state=20L)
#' @export
skKMeans = function(mat, ...) {
 SklearnEls()$skcl$KMeans(...)$fit(mat)
}

