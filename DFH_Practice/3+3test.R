## first, coding 3+3 in base R using escalation, trialr packages

library(trialr)
library(escalation)
library(dplyr)

## Dose Levels defined by user;
num_d <- 5 # this will be defined by user with a slider
# creating a vector dose_levels which contains all dose levels.
dose_levels <- seq(1,num_d)
# maybe start at 0? -> num_doses = num_d + 1

## using the escalation package, we call the object to fit the 3+3 model;

model_tpt <- get_three_plus_three(num_doses = num_d)

## honestly, not much to really output here, right? I'm going to do some simulations to show the user the expected outcome of the trial, I suppose.
# sample dose levels from curve, creating multiple scenarios, each of which will have the TTL (1/3 for 3+3)

sim_tox_prob = matrix(,num_d,num_d)
curve_alpha <- 1
TTL <- 0.3

for (i in 1:num_d){
sim_tox_prob[i,i] <- TTL

j = i
while (j < num_d){
sim_tox_prob[i,j+1] <- TTL + (TTL * (2 * (1 - ( 1 / (1 + exp (curve_alpha*(-j)))))))
j=j+1
}

k = num_d-i
while (k < num_d){
sim_tox_prob[i,i-num_d+k] <- TTL * (2 * (1 - ( 1 / (1 + exp (curve_alpha*(-num_d + k))))))
k=k+1
}
}

# and a little messing around with the paths to check that everything is working correctly;

paths_tpt <- model_tpt %>% get_dose_paths(cohort_sizes = c(3,3,3))

ob_1 <- as_tibble(paths_tpt)

ob_2 <- spread_paths(ob_1)

ob_3 <- subset(ob_2, select = c(next_dose0, outcomes1, next_dose1, outcomes2, next_dose2, outcomes3, next_dose3))