#' Replace anchors of a GInteractions
#'
#' @param .data,x a (Grouped)GInteractions object
#' @param anchors Anchors to pin on ("first" or "second")
#' 
#' @return a PinnedGInteractions object.
#'
#' @rdname replace_anchors
#' 
#' @examples
#' gi <- read.table(text = "
#' chr1 11 20 chr1 21 30
#' chr1 11 20 chr1 51 55
#' chr1 11 30 chr1 51 55
#' chr1 11 30 chr2 51 60",
#' col.names = c("seqnames1", "start1", "end1", "seqnames2", "start2", "end2")) |> 
#'   as_ginteractions() |> 
#'   mutate(type = c('cis', 'cis', 'cis', 'trans'), score = runif(4))
#' 
#' ####################################################################
#' # 1. Replace anchors of a GInteractions object
#' ####################################################################
#' 
#' gi |> replace_anchors(2, value = anchors1(gi))
#' 
#' gi |> replace_anchors(1, value = anchors2(gi))
#' 
#' gi |> replace_anchors(1, value = GRanges(c(
#'   "chr1:1-2", "chr1:2-3", "chr1:3-4", "chr1:4-5"
#' )))
#' 
#' ####################################################################
#' # 2. Replace anchors of a pinned GInteractions object
#' ####################################################################
#' 
#' gi |> pin_by(1) |> replace_anchors(value = anchors1(gi))
#' 
#' gi |> replace_anchors(1, value = anchors2(gi))
#' 
#' gi |> 
#'   pin_by(1) |> 
#'   replace_anchors(value = GRanges(c(
#'     "chr1:1-2", "chr1:2-3", "chr1:3-4", "chr1:4-5"
#'   ))) |> 
#'   pin_by(2) |> 
#'   replace_anchors(value = GRanges(c(
#'     "chr2:1-2", "chr2:2-3", "chr2:3-4", "chr2:4-5"
#'   ))) 
#' 
#' @export
setGeneric("replace_anchors", function(x, id, value) standardGeneric("replace_anchors"))

#' @rdname replace_anchors
#' @export
setMethod(
    "replace_anchors", 
    signature(x = "GInteractions", id = "character", value = "GenomicRanges"), 
    function(x, id, value) {
        id <- switch(id, 
            "anchors1" = 1L, 
            "first" = 1L, 
            "1" = 1L, 
            "anchors2" = 2L, 
            "second" = 2L, 
            "2" = 2L
        )
        if (id == 1L) {
            first(x) <- value
        } else {
            second(x) <- value
        }
        return(x)
    }
)

#' @rdname replace_anchors
#' @export
setMethod(
    "replace_anchors", 
    signature(x = "GInteractions", id = "numeric", value = "GenomicRanges"), 
    function(x, id, value) {
        if (!id %in% c(1, 2)) stop("`id` can only be set to `1` or `2`")
        replace_anchors(x, as.character(id), value)
    }
)

#' @rdname replace_anchors
#' @export
setMethod(
    "replace_anchors", 
    signature(x = "PinnedGInteractions", value = "GenomicRanges", id = "missing"), 
    function(x, value) {
        x@delegate <- replace_anchors(x@delegate, id = pin(x), value = value)
        x
    }
)

#' @rdname replace_anchors
#' @export
setMethod(
    "replace_anchors", 
    signature(x = "AnchoredPinnedGInteractions", value = "GRanges", id = "missing"), 
    function(x, value) {
        x@delegate@delegate <- replace_anchors(
            x@delegate@delegate, id = pin(x), value = value
        )
        x
    }
)