% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarize.R
\name{dplyr-summarize}
\alias{dplyr-summarize}
\alias{summarise.GroupedGInteractions}
\alias{dplyr-summarise}
\alias{summarize.GroupedGInteractions}
\title{Summarize GInteractions per group}
\usage{
\method{summarise}{GroupedGInteractions}(.data, ...)

\method{summarize}{GroupedGInteractions}(.data, ...)
}
\arguments{
\item{.data}{a (grouped) GInteractions object}

\item{...}{\if{html}{\out{<data-masking>}} Name-value pairs of summary functions.
The name will be the name of the variable in the result.}
}
\value{
a \code{S4Vectors::\link[S4Vectors:DataFrame-class]{DataFrame()}}
object:
\itemize{
\item The rows come from the underlying \code{group_keys()}.
\item The columns are a combination of the grouping keys and the summary
expressions that you provide.
\item GInteractions class is \strong{not} preserved, as a call to \code{summarize}
fundamentally creates a new data frame
}
}
\description{
Summarize GInteractions per group
}
\examples{
gi <- read.table(text = "
chr1 11 20 chr1 21 30 + +
chr1 11 20 chr1 51 55 + +
chr1 11 30 chr1 51 55 - -
chr1 11 30 chr2 51 60 - -",
col.names = c(
  "seqnames1", "start1", "end1", 
  "seqnames2", "start2", "end2", "strand1", "strand2")
) |> 
  as_ginteractions() |> 
  mutate(score = runif(4), type = c('cis', 'cis', 'cis', 'trans'))

####################################################################
# 1. Summarize a single column
####################################################################

gi

gi |> group_by(type) |> summarize(m = mean(score))

gi |> group_by(strand1) |> summarize(m = mean(score))

df <- gi |> 
  group_by(strand1) |> 
  summarize(m = mean(score), n = table(seqnames2))
df

df$n

####################################################################
# 2. Summarize by multiple columns
####################################################################

gi |> 
  group_by(strand1, seqnames2) |> 
  summarise(m = mean(score), n = table(type))

}
