library(manipulate)

# Plot a distribution
plotdist <- function(xseq, xdens, col, xlim, type, lty, lwd, segments=NULL, qlty, qcol, polyfill=NULL) {
  if (type == "plot") {
    plot(xseq, xdens, type="l", lwd=0, col=col, frame=FALSE, xlim=xlim, lty=lty, ylab='', xlab='')
  }
  
  if (!is.null(polyfill)) {
    polygon(polyfill[,1], polyfill[,2], col=qcol, border=qcol)
  }
  
  # draw quantile lines
  if (!is.null(segments)) {
    segments(x0=segments[,1], x1=segments[,1], y0=0, y1=segments[,2], lwd=lwd, col=qcol, lty=qlty)
  }
  
  lines(xseq, xdens, type="l", lwd=lwd, col=col, lty=lty)
}

# Plot the t distribution
plott <- function(lwd=2, ncp=0, df=300, col=rgb(0.30,0.50,0.75), xlim=c(-3,3), type="plot", lty="solid", quants=NULL, qlty="solid", qcol=rgb(0.30,0.50,0.75, 0.5), fill_quants=NULL) {
  xseq = seq(ncp-6, ncp+6, length=1000)
  xdens = dt(xseq, ncp=ncp, df=df)
  if (length(xlim) == 0) {
    xlim = c(ncp-3.5, ncp+3.5)
  }
  
  segments <- NULL
  polyfill <- NULL
  
  if (!is.null(quants)) {
    xquants = qt(quants, ncp=ncp, df=df)
    dquants = dt(xquants, ncp=ncp, df=df)
    segments = cbind(xquants, dquants)
  }

  if(!is.null(fill_quants)) {
    polyq = qt(fill_quants, ncp=ncp, df=df)
    polyfill.x = seq(polyq[1], polyq[2], by=0.001)
    polyfill.y = dt(polyfill.x, ncp=ncp, df=df)
    polyfill.x = c(polyfill.x[1], polyfill.x, tail(polyfill.x,1))
    polyfill.y = c(0, polyfill.y, 0)
    polyfill <- cbind(polyfill.x, polyfill.y)
  }
  
  plotdist(xseq, xdens, col, xlim, type, lty, lwd, segments, qlty, qcol, polyfill)
}

t_null_plot <- function(df, alpha) {
  plott(df=df, col=rgb(0.75, 0.1, 0.1), qcol=rgb(1, 0.5, 0.5), xlim=c(-6, 6), fill_quants=c(1-alpha, 0.999))
}

t_alt_lines <- function(df, ncp=0, alpha) {
  blue <- rgb(0.1, 0.1, 0.75)
  lightblue <- rgb(0.4, 0.4, 1, 0.3)
  quants <- c(0.5)
  power_quant <- pt(qt(1-alpha, df=df), df=df, ncp=ncp)
  plott(df=df, ncp=ncp, type='lines', lty="dashed", col=blue, quants=quants, qcol=lightblue, xlim=c(-6, 6), fill_quants=c(power_quant, 0.999))
}

t_test_plot <- function(diff, sd, n, alpha) {
  df=n-1
  t = diff/(sd/sqrt(n))
  t_null_plot(df, alpha)
  t_alt_lines(df,t, alpha)
}

manipulate(
  t_test_plot(diff, sd, n, alpha),
  diff  = slider(0, 4, step = 0.1, initial = 0.5),
  sd    = slider(1, 5, step = 0.1, initial = 4),
  n     = slider(2, 500, step = 1, initial = 100),
  alpha = slider(0.01, 0.1, step = 0.01, initial = 0.05)
)

