##output approximate slice times for MB data
##From Tae Kim email dated 2/26:
##Each slice took 83 ms, and 12 slices for each TR acquired with interleaved order, 9, 5, 1, 10, 6, 2, 11, 7, 3, 12, 8, 4.
##Used 5x acceleration, so need to replicate this for every 12 slices
##asked Tae about this Dec2013, he says look at slice times in dicom header
##these indicate by time: 2, 4, 6, 7, 10, 12, 1, 3, 5, 7, 9, 11
##bandit slice order: 5, 1, 6, 2, 7, 3, 8, 4
##NFB order I think... 7,1,8,2,9,3,10,4,11,5,12,6


#tr <- 1.0
tr <- .75
#baseTiming <- c(9, 5, 1, 10, 6, 2, 11, 7, 3, 12, 8, 4) #shift to zero-based timing
#baseTiming <- c(2, 4, 6, 8, 10, 12, 1, 3, 5, 7, 9, 11) #interleaved ascending, even first
#baseTiming <- c(5, 1, 6, 2, 7, 3, 8, 4)
baseTiming <- c(7, 1, 8, 2, 9, 3, 10, 4, 11, 5, 12, 6)
#but apparently times are not exactly even (appear to be rounded to 2.5ms resolution)
#fromHeaderTimes <- c(500, 0, 585, 82.5, 667.5, 167.5, 752.5, 250, 835, 335, 920, 417.5)/1000 #bottom to top, in seconds
#fromHeaderTimes <- c(282.5, 657.5, 187.5, 562.5, 92.5, 470, 0, 375)/1000 #bottom to top, in seconds
#fromHeaderTimes <- c(375,0,470,92.5,562.5,187.5,657.5,282.5)/1000 #I think it needed reversed based on the order Tae provided (see above)
fromHeaderTimes <- c(490.0, 0, 572.5, 82.5, 652.5, 162.5, 735.0, 245.0, 817.5, 327.5, 897.5, 407.5 )/1000 
nsimultaneous <- 5 #number of slices excited at once
##sliceMult <- 0:(nsimultaneous-1)
##sliceMult <- 1:nsimultaneous
nslices <- nsimultaneous*length(baseTiming)
## timing <- tr/length(baseTiming) * (replicate(nsimultaneous, baseTiming) + matrix(sliceMult, nrow=length(baseTiming), ncol=nsimultaneous, byrow=TRUE)*length(baseTiming))
## timing <- tr/length(baseTiming) * (replicate(nsimultaneous, 0:(length(baseTiming) - 1)))
## timing <- timing[order(baseTiming),] #order timings by slice number
timing <- tcrossprod(fromHeaderTimes, rep(1, nsimultaneous)) #replicate timings vector 5x

#sink("speccMBTimings.1D")
#sink("banditMBTimings.1D")
sink("nfbMBTimings.1D")
cat(paste(as.vector(timing), collapse=","), "\n")
sink()

