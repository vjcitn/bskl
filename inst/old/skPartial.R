#' take a step in sklearn IncrementalPCA partial fit procedure
#' @importFrom methods is
#' @importFrom methods new
#' @param mat a matrix -- can be R matrix or numpy.ndarray
#' @param n_components number of PCA to retrieve
#' @param obj sklearn.decomposition.IncrementalPCA instance
#' @note if obj is missing, the process is initialized with the matrix provided
#' @return trained IncrementalPCA reference, to which 'transform' method can be applied to obtain projection for any compliant input
#' @examples
#' irloc = system.file("csv/iris.csv", package="BiocSklearn")
#' irismat = SklearnEls()$np$genfromtxt(irloc, delimiter=',')
#' ta = SklearnEls()$np$take
#' ipc = skPartialPCA_step(ta(irismat,0:49,0L))
#' ipc = skPartialPCA_step(ta(irismat,50:99,0L), obj=ipc)
#' ipc = skPartialPCA_step(ta(irismat,100:149,0L), obj=ipc)
#' head(names(ipc))
#' ipc$transform(ta(irismat,0:5,0L))
#' fullproj = ipc$transform(irismat)
#' fullpc = prcomp(data.matrix(iris[,1:4]))$x
#' round(cor(fullpc,fullproj),3)
#' @export
skPartialPCA_step = function(mat, n_components, obj) {
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
 if (missing(obj)) 
    obj = SklearnEls()$skd$IncrementalPCA(n_components=n_components)
 obj$partial_fit(mat)
}

#h5gen = function(rows, cols) {
#  HDF5_FILE = system.file("hdf5/tenx10kmat.h5", package="BiocSklearn")
#  t( h5read(HDF5_FILE, DSNAME, list(rows, cols)) )
#}
#
#tgm =
#  TENxMatrix("~/Research/TENEX/1M_neurons_filtered_gene_bc_matrices_h5.h5")
#
#mmgen = function(rows, cols) {
#  t(as.matrix(tgm[rows, cols]))
#}
#
submatGenerator = function(srcfun, rows, cols) {
  srcfun(rows=rows, cols=cols)
  }
#
#
#ch = chunk(SAMP_INDS, chunk.size=CHUNK_SIZE)
#
#date()

#' optionally fault tolerant incremental partial PCA for projection of samples from SummarizedExperiment
#' @param se instance of SummarizedExperiment
#' @param chunksize integer number of samples per step
#' @param n_components integer number of PCs to compute
#' @param assayind not used, assumed set to 1
#' @param picklePath if non-null, incremental results saved here via sklearn.externals.joblib.dump, for each chunk.  If NULL, no saving of incremental results.
#' @param matTx a function defaulting to force() that accepts a matrix and returns a matrix with identical dimensions, e.g., \code{function(x) log(x+1)}
#' @param \dots not used
#' @importFrom BBmisc chunk
#' @import SummarizedExperiment
#' @return python instance of \code{sklearn.decomposition.incremental_pca.IncrementalPCA}
#' @aliases skIncrPPCA,SummarizedExperiment-method
#' @note Will treat samples as records and all features (rows) 
#' as attributes, projecting.  
#' to an \code{n_components}-dimensional space.  Method will 
#' acquire chunk of assay data
#' and transpose before computing PCA contributions.
#' In case of crash, restore from \code{picklePath} using
#' \code{SklearnEls()$joblib$load} after loading reticulate.  You can
#' use the \code{n_samples_seen_} component of the restored
#' python reference to determine where to restart.
#' You can manage resumption using \code{skPartialPCA_step}.
#' @examples
#' # demo SE made with TENxGenomics:
#' # mm = matrixSummarizedExperiment(h5path, 1:27998, 1:750)
#' # saveHDF5SummarizedExperiment(mm, "tenx_750")
#' #
#' if (requireNamespace("HDF5Array")) {
#'   se750 = HDF5Array::loadHDF5SummarizedExperiment(
#'      system.file("hdf5/tenx_750", package="BiocSklearn"))
#'   lit = skIncrPPCA(se750[, 1:50], chunksize=5, n_components=4)
#'   round(cor(pypc <- lit$transform(dat <- t(as.matrix(assay(se750[,1:50]))))),3)
#'   rpc = prcomp(dat)
#'   round(cor(rpc$x[,1:4], pypc), 3)
#' }
#' @exportMethod skIncrPPCA
setGeneric("skIncrPPCA", function(se, chunksize, n_components, assayind=1, picklePath="./skIdump.pkl", matTx = force, ...) 
    standardGeneric("skIncrPPCA"))
setMethod("skIncrPPCA", "SummarizedExperiment", 
   function(se, chunksize, n_components, assayind=1, ...) {
   stopifnot(assayind==1)
   n_components = as.integer(n_components)
   chunksize = as.integer(chunksize)
   rowvec = seq_len(nrow(se))
   colvec = seq_len(ncol(se))
   chs = chunk(colvec, chunk.size=chunksize)
   matgen = function(rows, cols) t(matTx(as.matrix(assay(se[rows, cols])))) # assayind handling?
   cur = skPartialPCA_step(
      submatGenerator( matgen, rowvec, chs[[1]] ), n_components )
   if (!is.null(picklePath)) {
      message(paste("Will save pickled interim per-chunk results in", picklePath))
      SklearnEls()$joblib$dump(cur, filename=picklePath)
      }
   for (i in 2:length(chs)) { 
      cat(i)
      cur = skPartialPCA_step(
        submatGenerator( matgen, rowvec, chs[[i]]), n_components, cur)
      if (!is.null(picklePath)) SklearnEls()$joblib$dump(cur, filename=picklePath)
      }
   cur
})
