
#' use sklearn PCA procedure
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @param \dots additional parameters passed to sklearn.decomposition.PCA, for additional information use \code{py_help(SklearnEls()$sk$PCA)}
#' @note If no additional arguments are passed, all defaults are used.
#' @return matrix with rotation
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' irismat = SklearnEls()$np$genfromtxt(irloc, delimiter=',')
#' skpi = skPCA2(irismat)
#' getTransformed(skpi)[1:5,]
#' @export
skPCA2 = function(mat, ...) {
 ans = basiliskRun(fun=function(...)
    {   
    skd = import("sklearn.decomposition", delay_load=TRUE)
    skpc = skd$PCA(...)
    tx = skpc$fit_transform(mat)
    list(skpc=skpc, tx=tx)
    }, envname="bsklenv", pkgname="BiocSklearn")
 new("SkDecomp", method = "PCA", transform = ans$tx,
        object = ans$skpc)
}

#' create a file connection to HDF5 matrix
#' @param file a pathname to an HDF5 file
#' @param dsname internal name of HDF5 matrix to use 
#' @return instance of (S3) h5py._hl.files.File
#' @examples
#' fn = system.file("ban_6_17/assays.h5", package="BiocSklearn")
#' h5mat2(fn)
#' @export
h5mat2 = function( file, dsname="assay001" ) {
  basiliskRun(fun=function(...)
    {   
    h5 = reticulate::import("h5py", delay_load=TRUE)
    h5$File(file)
    }, envname="bsklenv", pkgname="BiocSklearn")
  SklearnEls()$h5py$File( file )
}

#' obtain an HDF5 dataset reference suitable for handling as numpy matrix 
#' @param filename a pathname to an HDF5 file
#' @param dsname internal name of HDF5 matrix to use, defaults to 'assay001'
#' @return instance of (S3) "h5py._hl.dataset.Dataset"
#' @examples
#' fn = system.file("ban_6_17/assays.h5", package="BiocSklearn")
#' ban = H5matref2(fn)
#' ban
#' @export
H5matref2 = function(filename, dsname="assay001") {
  basiliskRun(fun=function(...) {
    reticulate::py_run_string("import h5py")
    reticulate::py_run_string(paste0("f = h5py.File('", filename, "')"))
    mref = reticulate::py_run_string(paste0("g = f['", dsname, "']"))
    mref$g
    }, envname="bsklenv", pkgname="BiocSklearn")
}

