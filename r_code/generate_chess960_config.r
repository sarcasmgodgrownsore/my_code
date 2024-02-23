# Initial Setup
as <- 1:8
ds <- c(1,3,5,7)
ls <- c(2,4,6,8)
config <- c("-","-","-","-","-","-","-","-")

# First Rook
fr <- which.max(runif(6))
as <- as[as!=fr]
ds <- ds[ds!=fr]
ls <- ls[ls!=fr]
config[fr] <- "r"

# Second Rook
asr <- as[as>fr+1]
sr <- asr[which.max(runif(length(asr)))]
as <- as[as!=sr]
ds <- ds[ds!=sr]
ls <- ls[ls!=sr]
config[sr] <- "r"

# King
ak <- as[as>1*fr & as<1*sr]
k <- ak[which.max(runif(length(ak)))]
as <- as[as!=k]
ds <- ds[ds!=k]
ls <- ls[ls!=k]
config[k] <- "k"

# Light Square Bishop
lsb <- ls[which.max(runif(length(ls)))]
as <- as[as!=lsb]
ls <- ls[ls!=lsb]
config[lsb] <- "b"

# Dark Square Bishop
dsb <- ds[which.max(runif(length(ds)))]
as <- as[as!=dsb]
ds <- ds[ds!=dsb]
config[dsb] <- "b"

# First Knight
fn <- as[which.max(runif(3))]
as <- as[as!=fn]
ds <- ds[ds!=fn]
ls <- ls[ls!=fn]
config[fn] <- "n"

# Second Knight
sn <- as[which.max(runif(2))]
as <- as[as!=sn]
ds <- ds[ds!=sn]
ls <- ls[ls!=sn]
config[ls] <- "n"

# Queen
q <- 1*as
config[q] <- "q"

piece_configuration <- cat(config)

