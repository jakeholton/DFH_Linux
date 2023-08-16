## first, coding 3+3 in base R using escalation, trialr packages

library(trialr)
library(escalation)
library(dplyr)

## Dose Levels defined by user;
num_d <- 7 # this will be defined by user with a slider
# creating a vector dose_levels which contains all dose levels.
dose_levels <- seq(1,num_d)
# maybe start at 0? -> num_doses = num_d + 1

## using the escalation package, we call the object to fit the 3+3 model;

model_tpt <- get_three_plus_three(num_doses = num_d)

## honestly, not much to really output here, right? I'm going to do some simulations to show the user the expected outcome of the trial, I suppose.
# sample dose levels from curve, creating multiple scenarios, each of which will have the TTL (1/3 for 3+3)

sim_tox_prob = matrix(,num_d,num_d)
curve_alpha <- 1
TTL <- 1/3

for (i in 1:num_d){
sim_tox_prob[i,i] <- TTL

j = i
while (j < num_d){
sim_tox_prob[i,j+1] <- ((j-i+1)/num_d)*(1-TTL)+TTL
j=j+1
}

k = num_d-i
while (k < num_d){
sim_tox_prob[i,i-num_d+k] <- TTL-(((num_d-k)/num_d)*TTL)
k=k+1
}
}

## new theory...
# if, say, TTL = 0.3 at dose level 1
# we can input (1/num_d,0.3) into our equation
# the slope alpha can be found using alpha = ln(y) / x , therefore here alpha = ln(0.3)/0.2
# but wait... we don't know where on the slope we are, and max dose level dose not = 100% of tox, obviously
# i've come full circle here and i am no closer to the answer :D 



# and a little messing around with the paths to check that everything is working correctly;

paths_tpt <- model_tpt %>% get_dose_paths(cohort_sizes = c(3,3,3))

ob_1 <- as_tibble(paths_tpt)

ob_2 <- spread_paths(ob_1)

ob_3 <- subset(ob_2, select = c(next_dose0, outcomes1, next_dose1, outcomes2, next_dose2, outcomes3, next_dose3))

## keep this safe for me will ya

TTL + (1-TTL) * (1 - (2 * (1 - (1 / (1 + exp(curve_alpha*(-j)))))))