##' mediate access to python modules from sklearn.decomposition
##' @import reticulate
##' @import knitr
##' @importFrom basilisk basiliskStart basiliskRun basiliskStop
##' @note Returns a list with elements np (numpy), pd (pandas), h5py (h5py),
##' skd (sklearn.decomposition), joblib (sklearn.externals.joblib), each
##' referring to python modules.
##' @examples
##' els = SklearnEls()
##' names(els$skd) # slow at first
##' # try py_help(els$skd$PCA) # etc.
##' @return list of (S3) "python.builtin.module"
##' @export
#SklearnEls = function() {
#  proc <- basiliskStart(my_env)
#  on.exit(basiliskStop(proc))
#  basiliskRun(proc=proc, function() {
#  np <- reticulate::import("numpy", delay_load=TRUE, convert=FALSE)
#  pd <- reticulate::import("pandas", delay_load=TRUE)
#  h5py <- reticulate::import("h5py", delay_load=TRUE)
#  skd <- reticulate::import("sklearn.decomposition", delay_load=TRUE)
#  skcl <- reticulate::import("sklearn.cluster", delay_load=TRUE)
#  joblib <- reticulate::import("sklearn.externals.joblib", delay_load=TRUE)
#  ans = list(np=np, pd=pd, h5py=h5py, skd=skd, skcl=skcl, joblib=joblib)
#  assign("SklearnEls", function() ans, envir=parent.frame())
#  }())
#}
#
##my_example_function <- function(ARG_VALUE_1, ARG_VALUE_2) {
##    proc <- basiliskStart(my_env)
##    on.exit(basiliskStop(proc))
##
##    some_useful_thing <- basiliskRun(proc, function(arg1, arg2) {
##        mod <- reticulate::import("scikit-learn")
##        output <- mod$some_calculation(arg1, arg2)
##
##        # The return value MUST be a pure R object, i.e., no reticulate
##        # Python objects, no pointers to shared memory.
##        output
##    }, arg1=ARG_VALUE_1, arg2=ARG_VALUE_2)
##
##    some_useful_thing
##}
#
