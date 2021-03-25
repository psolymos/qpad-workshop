#' local file management to avoid overriding user changes
qpad_local <- function(day) {
  day <- match.arg(as.character(day), as.character(1:4))
  lf <- list.files()
  fin <- lf[startsWith(lf, paste0("day", day)) & endsWith(lf, ".Rmd")]
  fout <- paste0("LOCAL-", fin)
  file.copy(from=fin, to=fout, overwrite=FALSE)
  cat("\nFiles copied: work in your LOCAL copies\n\n")
  invisible(NULL)
}

#' Simulation based confidence nad prediction intervals for LM/GLM
predict_sim <-
function(object, newdata=NULL,
interval = c("none", "confidence", "prediction"),
type=c("asymp", "pboot", "npboot"),
level=0.95, B=99, ...) {
    interval <- match.arg(interval)
    type <- match.arg(type)
    if (is.null(newdata)) {
        x <- model.frame(object)
        X <- model.matrix(object)
    } else {
        x <- model.frame(delete.response(terms(object)), newdata)
        X <- model.matrix(attr(x, "terms"), x)
    }
    n <- nrow(x)
    fun <- switch(family(object)$family,
        "gaussian"=function(x) rnorm(length(x), x, summary(object)$sigma),
        "poisson"= function(x) rpois(length(x), x),
        "binomial"=function(x) rbinom(length(x), 1, x),
        stop("model family not recognized"))
    if (interval=="none")
        return(predict(object, newdata, ...))
    if (B < 2)
        stop("Are you kidding? B must be > 1")
    if (type == "asymp") {
        cm <- rbind(coef(object),
            MASS::mvrnorm(B, coef(object), vcov(object)))
        #fm <- apply(cm, 1, function(z) X %*% z)
    }
    if (type == "boot") {
        cm <- matrix(0, B+1, length(coef(object)))
        cm[1,] <- coef(object)
        xx <- model.frame(object)
        for (i in 2:B) {
            j <- sample.int(n, n, replace=TRUE)
            cm[i,] <- coef(update(object, data=xx[j,]))
        }
        #fm <- apply(cm, 1, function(z) X %*% z)
    }
    if (type == "npboot") {
        cm <- matrix(0, B+1, length(coef(object)))
        cm[1,] <- coef(object)
        xx <- model.frame(object)
        j <- attr(attr(xx, "terms"), "response")
        f <- fitted(object)
        for (i in 2:B) {
            xx[,j] <- fun(f)
            cm[i,] <- coef(update(object, data=xx))
        }
        #fm <- apply(cm, 1, function(z) X %*% z)
    }
    fm <- X %*% t(cm)
    fm <- family(object)$linkinv(fm)
    y <- if (interval == "prediction")
        matrix(fun(fm), n, B+1) else fm
    rownames(y) <- rownames(x)
    p <- c(0.5, (1-level) / 2, 1 - (1-level) / 2)
    stat_fun <- function(x)
        c(mean(x), sd(x), quantile(x, p))
    out <- cbind(fm[,1], t(apply(y, 1, stat_fun)))
    colnames(out) <- c("fit", "mean", "se", "median", "lwr", "upr")
    data.frame(out[,c("fit", "lwr", "upr", "mean", "median", "se")])
}
#'
#' Internal function
.r2_fun <-
function(observed, fitted, distr=c("binomial", "poisson"),
size=1, null=NULL, p=0)
{
    distr <- match.arg(distr)
    if (distr == "poisson") {
        if (is.null(null))
            null <- mean(observed)
        ll0 <- sum(dpois(observed, null, log=TRUE))
        lls <- sum(dpois(observed, observed, log=TRUE))
        llf <- sum(dpois(observed, fitted, log=TRUE))
    } else {
        if (is.null(null))
            null <- mean(observed/size)
        ll0 <- sum(dbinom(observed, size, null, log=TRUE))
        lls <- sum(dbinom(observed, size, observed/size, log=TRUE))
        llf <- sum(dbinom(observed, size, fitted, log=TRUE))
    }
    n <- length(observed)
    R2 <- 1 - (lls - llf) / (lls - ll0)
    R2adj <- 1 - (1 - R2) * ((n-1) / (n-(p+1)))
    D0 <- -2 * (ll0 - lls)
    DR <- -2 * (llf - lls)
    #p_value <- 1 - pchisq(D0 - DR, p)
    p_value <- 1 - pchisq(DR, length(observed)-(p+1))
    c(R2=R2, R2adj=R2adj, Deviance=D0 - DR, Dev0=D0, DevR=DR,
        #df=p,
        df0=length(observed)-1, dfR=length(observed)-(p+1),
        p_value=p_value)
}
#' Deviance based R^2 from a model
.getR2dev <-
function(object, ...) {
    y <- model.response(model.frame(object), "numeric")
    f <- fitted(object)
    .r2_fun(y, fitted(object),
        distr=family(object)$family, size=1, null=NULL,
        p=length(coef(object))-1)
}
#' This function makes a nice table
R2dev <-
function(x, ...)
{
    obj <- list(x, ...)
    rval <- as.data.frame(t(sapply(obj, .getR2dev)))
    rownames(rval) <- as.character(match.call()[-1])
    class(rval) <- c("R2dev", class(rval))
    rval
}
#' This prints the table
print.R2dev <-
function (x, digits = max(3, getOption("digits") - 3), ...)
{
    printCoefmat(x, digits=digits, has.Pvalue=TRUE,
        tst.ind=1:7, ...)
    invisible(x)
}
#' Taken from plotrix
draw_ellipse <-
function (x, y, a = 1, b = 1, angle = 0, segment = NULL, arc.only = TRUE,
    deg = TRUE, nv = 100, border = NULL, col = NA, lty = 1, lwd = 1,
    ...)
{
    if (is.null(segment)) {
        if (deg) {
            segment <- c(0, 360)
        } else {
            segment <- c(0, 2 * pi)
        }
    }
    draw1ellipse <- function(x, y, a = 1, b = 1, angle = 0, segment = NULL,
        arc.only = TRUE, nv = 100, deg = TRUE, border = NULL,
        col = NA, lty = 1, lwd = 1, ...) {
        if (deg) {
            angle <- angle * pi/180
            segment <- segment * pi/180
        }
        z <- seq(segment[1], segment[2], length = nv + 1)
        xx <- a * cos(z)
        yy <- b * sin(z)
        alpha <- xyangle(xx, yy, directed = TRUE, deg = FALSE)
        rad <- sqrt(xx^2 + yy^2)
        xp <- rad * cos(alpha + angle) + x
        yp <- rad * sin(alpha + angle) + y
        if (!arc.only) {
            xp <- c(x, xp, x)
            yp <- c(y, yp, y)
        }
        polygon(xp, yp, border = border, col = col, lty = lty,
            lwd = lwd, ...)
        invisible(NULL)
    }
    xyangle <- function(x, y, directed = FALSE, deg = TRUE) {
        if (missing(y)) {
            y <- x[, 2]
            x <- x[, 1]
        }
        out <- atan2(y, x)
        if (!directed)
            out <- out%%pi
        if (deg)
            out <- out * 180/pi
        out
    }
    if (missing(y)) {
        y <- x[, 2]
        x <- x[, 1]
    }
    n <- length(x)
    if (length(a) < n)
        a <- rep(a, n)[1:n]
    if (length(b) < n)
        b <- rep(b, n)[1:n]
    if (length(angle) < n)
        angle <- rep(angle, n)[1:n]
    if (length(col) < n)
        col <- rep(col, n)[1:n]
    if (length(border) < n)
        border <- rep(border, n)[1:n]
    if (length(nv) < n)
        nv <- rep(nv, n)[1:n]
    if (n == 1) {
        draw1ellipse(x, y, a, b, angle = angle, segment = segment,
            arc.only = arc.only, deg = deg, nv = nv, col = col,
            border = border, lty = lty, lwd = lwd, ...)
    } else {
        if (length(segment) < 2 * n)
            segment <- matrix(rep(segment, n), n, 2, byrow = TRUE)
        lapply(1:n, function(i) draw1ellipse(x[i], y[i], a[i],
            b[i], angle = angle[i], segment = segment[i, ], arc.only = arc.only,
            deg = deg, nv = nv[i], col = col[i], border = border[i],
            lty = lty, lwd = lwd, ...))
    }
    invisible(NULL)
}

#' Simple and fast ROC and AUC
simple_roc <- function(labels, scores){
    Labels <- labels[order(scores, decreasing=TRUE)]
    data.frame(
        TPR=cumsum(Labels)/sum(Labels),
        FPR=cumsum(!Labels)/sum(!Labels),
        Labels=Labels)
}
simple_auc <- function(ROC) {
    ROC$inv_spec <- 1-ROC$FPR
    dx <- diff(ROC$inv_spec)
    sum(dx * ROC$TPR[-1]) / sum(dx)
}
