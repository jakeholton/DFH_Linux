library(dfcrm)
library(escalation)
library(trialr)
library(ggplot2)



#DEFINING PARAMETERS
sample.size = 21 #Used
cohort.size = 3 #No need to be used; default
no.doses = 7 #No need to be used; infered from priors
dose.levels = c(1:7)  #No need to be used; infered from priors
start.dose.level = 3 #No need to be used; default
TTL = 0.2 #Used
prior.DLT = c(0.03, 0.07, 0.12, 0.20, 0.30, 0.40, 0.52) #Used
prior.var = 0.75 #Used
dont.skip.dose.esc = TRUE #Used
dont.skip.dose.deesc = FALSE #Used
global.DLT.default.esc = TRUE #No need to use?
x = 0.1 #Used
confidence.factor = 0.72 #Used
n.mtd = 12
first_dose = 3



#DEFINING CRM MODEL
CRM = get_trialr_crm(parent_selector_factory=NULL, skeleton=prior.DLT, target=TTL, model="empiric", beta_sd = sqrt(prior.var))
CRM = dont_skip_doses(CRM, when_escalating=dont.skip.dose.esc, when_deescalating=dont.skip.dose.deesc)
CRM = stop_when_too_toxic(CRM, dose=1, tox_threshold=TTL+x, confidence=confidence.factor)
CRM = stop_when_n_at_dose(CRM, n=n.mtd, dose="recommended")
CRM = stop_at_n(CRM, n=sample.size)



#RUNNING SIMULATIONS
num.sims = 10
set.seed(1000)
#
sim1tox = c(0.03, 0.05, 0.07, 0.20, 0.36, 0.45, 0.55)
sim1 = CRM %>% simulate_trials(num_sims=num.sims, true_prob_tox=sim1tox, next_dose = first_dose, set.seed(1000))
sim1
#
sim2tox = c(0.005, 0.01, 0.03, 0.05, 0.07, 0.20, 0.36)
sim2 = CRM %>% simulate_trials(num_sims=num.sims, true_prob_tox=sim2tox, next_dose = first_dose, set.seed(1000))
sim2
#
sim3tox = c(0.45, 0.55, 0.65, 0.7, 0.75, 0.80, 0.85)
sim3 = CRM %>% simulate_trials(num_sims=num.sims, true_prob_tox=sim3tox, next_dose = first_dose, set.seed(1000))
sim3
#
sim_table = rbind(
    "S1 True Toxicity" = c("X", sim1$true_prob_tox),
    "S1 Prob Select" = (sim1%>%prob_recommend),
    "S2 True Toxicity" = c("X", sim2$true_prob_tox),
    "S2 Prob Select" = (sim2%>%prob_recommend),
    "S3 True Toxicity" = c("X", sim3$true_prob_tox),
    "S3 Prob Select" = (sim3%>%prob_recommend)
)
View(sim_table)
prob.n.mtd.sim1 = (sum((n_at_recommended_dose(sim1))==n.mtd))/num.sims
prob.n.mtd.sim2 = (sum((n_at_recommended_dose(sim2))==n.mtd))/num.sims
prob.n.mtd.sim3 = (sum(((n_at_recommended_dose(sim3))[!is.na((n_at_recommended_dose(sim3)))])==n.mtd))/num.sims
#Number of patients at each dose?????
#Probability of stopping due to toxicity?????
#Bind everything together?????



#DTP FOR FIRST 3 COHORTS
DTP = get_dose_paths(CRM, cohort_sizes=c(3, 3), next_dose = first_dose)
graph_paths(DTP)
#DTP.tibble = as_tibble.dose_paths(DTP)


#TRIAL CONDUCT WITH DTP
#No DLTs were observed in the first 2 cohorts who were dose at dose levels 3 and 4
outcome.cohort.1 = "3NNN"
outcomes.cohort.2 = "3NNN 4NNN"
#
#CRM.fit.1 = CRM %>% fit(outcome.cohort.1)
#CRM.fit.2 = CRM %>% fit(outcomes.cohort.2)
#print(CRM.fit.1)
#print(CRM.fit.2)
#Potential line: DTP.fit = subset(spread_paths(CRM.fit), select = c(next_dose0, outcomes1, next_dose1, outcomes2, next_dose2, outcomes3, next_dose3))
#Potential function: prob_tox_samples function
#
#Doing as per Xiaoran's suggestion:
CRM.other <- get_dfcrm(skeleton = prior.DLT, target = TTL, scale = sqrt(prior.var))
CRM.other <- CRM.other %>% dont_skip_doses(when_escalating = TRUE, when_deescalating = FALSE)
CRM.other <- CRM.other %>% stop_when_too_toxic(dose = 1, x + TTL, confidence = 0.72)
CRM.other <- CRM.other %>% stop_when_n_at_dose(n = 12, dose = "recommended")
CRM.other <- CRM.other %>% stop_at_n(n = 21)
CRM.other.fit.1 <- CRM.other %>% fit(outcome.cohort.1)
CRM.other.fit.2 <- CRM.other %>% fit(outcomes.cohort.2)
#
plot(x=dose.levels, y=prior.DLT, type = "b", ylim = c(0,0.55))
points(x=dose.levels, y=c(mean_prob_tox(CRM.other.fit.1)), type = "b", col = "red")
lines(x=dose.levels, y=c(mean_prob_tox(CRM.other.fit.1)), type = "b", col = "red")
points(x=dose.levels, y=c(mean_prob_tox(CRM.other.fit.2)), type = "b", col = "green")
lines(x=dose.levels, y=c(mean_prob_tox(CRM.other.fit.2)), type = "b", col = "green")
abline(h=TTL)