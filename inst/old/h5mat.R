#' create a file connection to HDF5 matrix
#' @param file a pathname to an HDF5 file
#' @param dsname internal name of HDF5 matrix to use
#' @return instance of (S3) h5py._hl.files.File
#' @examples
#' fn = system.file("ban_6_17/assays.h5", package="BiocSklearn")
#' h5mat(fn)
#' @export
h5mat = function( file, dsname="assay001" )
  SklearnEls()$h5py$File( file )

#' obtain an HDF5 dataset reference suitable for handling as numpy matrix 
#' @param filename a pathname to an HDF5 file
#' @param dsname internal name of HDF5 matrix to use, defaults to 'assay001'
#' @return instance of (S3) "h5py._hl.dataset.Dataset"
#' @examples
#' fn = system.file("ban_6_17/assays.h5", package="BiocSklearn")
#' ban = H5matref(fn)
#' ban
#' np = import("numpy", convert=FALSE) # ensure
#' ban$shape
#' np$take(ban, 0:3, 0L)
#' fullpca = skPCA(ban)
#' dim(getTransformed(fullpca))
#' ta = np$take
#' # project samples
#' \dontrun{  # on celaya2 this code throws errors, and
#' #  I have seen
#' # .../lib/python2.7/site-packages/sklearn/decomposition/incremental_pca.py:271: RuntimeWarning: Mean of empty slice.
#' #   explained_variance[self.n_components_:].mean()
#' # .../lib/python2.7/site-packages/numpy/core/_methods.py:85: RuntimeWarning: invalid value encountered in double_scalars
#' #   ret = ret.dtype.type(ret / rcount)
#' ta(ban, 0:20, 0L)$shape
#' st = skPartialPCA_step(ta(ban, 0:20, 0L))
#' st = skPartialPCA_step(ta(ban, 21:40, 0L), obj=st)
#' st = skPartialPCA_step(ta(ban, 41:63, 0L), obj=st)
#' oo = st$transform(ban)
#' dim(oo)
#' cor(oo[,1:4], getTransformed(fullpca)[,1:4])
#' } # so blocking this part of example for now
#' @export 
H5matref = function(filename, dsname="assay001") {
  py_run_string("import h5py")
  py_run_string(paste0("f = h5py.File('", filename, "')"))
  mref = py_run_string(paste0("g = f['", dsname, "']"))
  mref$g
}
