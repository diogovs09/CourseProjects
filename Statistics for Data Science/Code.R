#Developed+Adult.Mortality+infant.deaths+Alcohol+percentage.expenditure+Hepatitis.B 
## +Measles+BMI+under.five.deaths+Polio+Total.expenditure+Diphtheria + HIV.AIDS+GDP+
## Population+thinness..1.19.years+thinness.5.9.years+Income.composition.of.resources+Schooling


# Load necessary packages
library(plm)
library(dplyr)
library(lmtest)
library(car)


# Import the data from the csv file 
data <- read.csv("life_expectancy_data.csv")

# Check the data
str(data)
head(data)
summary(data)

data <- na.omit(data)

# Dummify Status column and rename it
data <- data %>%
  mutate(Developed = as.integer(Status == "Developed")) %>%
  select(-Status)

# Plot histograms --------- 
columns_to_plot <- data[, 4:ncol(data)] 

# Identify integer columns
integer_cols <- sapply(columns_to_plot, is.integer)

# Convert integer columns to numeric
columns_to_plot[, integer_cols] <- lapply(columns_to_plot[, integer_cols], as.numeric)

par(mfrow = c(4, 5))
for (i in 1:ncol(columns_to_plot)) {
  hist(columns_to_plot[, i], main = colnames(columns_to_plot)[i], xlab = "", col = "skyblue", border = "black")
}
# Reset the layout to default
par(mfrow = c(1, 1))

#Correlation PLot
library(corrplot)
a <- print(cor(data[, 4:ncol(data)]))
dev.off()
corrplot(a, method = 'color', addCoef.col = 'black', 
         number.cex = 0.45, tl.cex = 0.5, tl.col="black")

## Adult.Mortality+infant.deaths+Alcohol+BMI+Total.expenditure+GDP+Schooling+Developed

#Pooled OLS
reg1 = plm(Life.expectancy ~ Adult.Mortality+infant.deaths+Alcohol+BMI+
             Total.expenditure+GDP+Schooling+Developed ,
           data = data, index = c("Country","Year"), model="pooling")

summary(reg1)

reg2 = plm(Life.expectancy ~ Adult.Mortality+Alcohol+BMI+GDP+Schooling+Developed ,
             data = data, index = c("Country","Year"), model="pooling")
summary(reg2)

#Random Effects
re1 <- plm(Life.expectancy ~ Adult.Mortality+infant.deaths+Alcohol+BMI+
             Total.expenditure+GDP+Schooling+Developed,
           data = data, index = c("Country","Year"), model='random')
summary(re1)

re2 <- plm(Life.expectancy ~ Adult.Mortality+Alcohol+BMI+GDP+Schooling+Developed,
          data = data, index = c("Country","Year"), model='random')
summary(re2)

#Fixed Effects
fe1 = plm(Life.expectancy ~ Adult.Mortality+infant.deaths+Alcohol+BMI+
            Total.expenditure+GDP+Schooling+Developed,
           data = data, index = c("Country","Year"), model='within')
summary(fe1)

fe2 = plm(Life.expectancy ~ Adult.Mortality+infant.deaths+Alcohol+
            GDP+Schooling+Developed,
          data = data, index = c("Country","Year"), model='within')
summary(fe2)

phtest(fe2, re2) #based on the Hausman test, there is no significant difference between FE and RE
bptest(fe2)
bptest(re2)

#No Perfect Collinearity
vif(re2) #check
vif(reg2) #check
vif(fe2)

#Heteroskedasticity
bptest(Life.expectancy ~ Adult.Mortality+infant.deaths+Alcohol+HIV.AIDS+GDP+Schooling + factor(Country),
       data = data) #Fail

#Robust 
phtest(fe2, re2, vcov = function(x) vcovHC(x, method="white2", type="HC3")) #p-value = 0.9212 SLAAAY
