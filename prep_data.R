### read and prep in data

#packages
r <- getOption("repos")
r["CRAN"] <-"https://cloud.r-project.org/"
options(repos=r)

if (!require(haven)) {
  install.packages("haven")
  require(haven)
}


#read in data 
df <- haven::read_sav("data/sample.sav")

#here you can prep data

df$Agegroup <- df$age
df$Agegroup[df$age <= 28] <- "19-28"
df$Agegroup[df$age  >= 29 & df$age <= 38] <- "29-38"
df$Agegroup[df$age >= 39 & df$age <= 48] <- "39-48"
df$Agegroup[df$age >= 49] <- "49-58"
df$Agegroup <- as.factor(df$Agegroup)

df <- df[complete.cases(df$age, df$gen, df$men_warm, df$men_comp),]

# save data as R format
save(df, file = "data/sample.Rdata")
