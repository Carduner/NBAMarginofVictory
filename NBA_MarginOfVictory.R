setwd("C:/Users/User/Jupyter Notebooks/AdvancedDataAnalysis")

#read data and examine
nba = read.csv('2017-18_trailing6TeamBoxScore.csv')
nba = as.data.frame(nba)
head(nba)
str(nba)

#examine correlations and remove variables that are too closely correlated 
#likely because they are based on same box score stat calculated in different ways
nba.num = nba[,c(4:93,95)]
str(nba.num)
library(corrplot)
nba.cor = round(cor(nba.num),2)
nba.cor

#too much data so going to filter correlations above a specific threshold like .6
library(dplyr)
cor_df = as.data.frame(as.table(nba.cor))
head(cor_df)
cor_df %>% arrange(desc(Freq)) %>% filter(Freq>0.6&Freq<1.0)

#subset data, favor calculated statistics over regular, if both calculated, choose higher correlated with Margin of Victory
nba.num1 = subset(nba.num, select = -c(MarginOfVictory,teamBLK_T6_x, teamBLK_T6_y, teamFIC_T6_x, teamFIC_T6_y,
                                       teamSTL_T6_x, teamSTL_T6_y, teamTO_T6_x, teamTO_T6_y, 
                                       teamEFG._T6_x, teamEFG._T6_y, teamTO_T6_x, teamTO_T6_y,
                                       teamTS._T6_x, teamTS._T6_y, teamFTA_T6_x, teamFTA_T6_y,
                                       pace_T6_x, pace_T6_y, teamBLK._T6_x, teamBLK._T6_y,
                                       teamAST_T6_x, teamAST_T6_y, teamORB_T6_x, teamORB_T6_y,
                                       teamFG._T6_x, teamFG._T6_y, teamOrtg_T6_x, teamOrtg_T6_y,
                                       teamPTS_T6_x, teamPTS_T6_y, teamASST._T6_x, teamASST._T6_y,
                                       team3PA_T6_x, team3PA_T6_y, teamTRB_T6_x, teamTRB_T6_y,
                                       teamORB_T6_x, teamORB_T6_y, teamDRB_T6_x, teamDRB_T6_y,
                                       teamFGM_T6_x, teamFGM_T6_y, teamPlay._T6_x, teamPlay._T6_y
                                       ))

#re run and see what is left
nba.cor = round(cor(nba.num1),2)
cor_df = as.data.frame(as.table(nba.cor))
cor_df %>% arrange(desc(Freq)) %>% filter(Freq>0.6&Freq<1.0)

#took out all variables that correlated greater than .8, need some correlation for CFA

#run bartlett test of spherecity and KMO for sample adequacy
library(REdaS)
bart_spher(nba.num1) #signficantly different than identity matrix

KMOS(nba.num1) #unnacceptable, need to reduce more variables

nba.num2 = subset(nba.num1, select = -c(team2PA_T6_x, team2PA_T6_y, teamSTL._T6_x, teamSTL._T6_y, 
                                        teamFIC40_T6_x, teamFIC40_T6_y, team2P._T6_x, team2P._T6_y,
                                        team3PM_T6_x, team3PM_T6_y, team2PM_T6_x, team2PM_T6_y, 
                                        teamFGA_T6_x, teamFGA_T6_y, teamOREB._T6_x, teamOREB._T6_y,
                                        teamDREB._T6_x, teamDREB._T6_y, teamFTM_T6_x, teamFTM_T6_y,
                                        teamDrtg_T6_x, teamDrtg_T6_y, teamAR_T6_x, teamAR_T6_y,
                                        teamTO._T6_x, teamTO._T6_y
                                        ))

bart_spher(nba.num2) #signficantly different than identity matrix

KMOS(nba.num2) #above 0.5, acceptable!
str(nba.num2)
#Determine number of components
p = prcomp(nba.num2, center=T, scale=T) #only use to determine number of components use principal for everthing else
plot(p, npcs=20)
abline(1, 0)
summary(p)

#10 components for Factor Analysis using eigen value method
nba_scaled = scale(nba.num2, center = TRUE, scale = TRUE)
fit = factanal(nba_scaled, factors = 10, rotation = 'promax')
print(fit$loadings, cutoff=.4, sort=T)
summary(fit)

#2 components for Factor Analysis (knee method)
fit = factanal(nba_scaled, factors = 2, rotation = 'promax')
print(fit$loadings, cutoff=.4, sort=T)
summary(fit)


#PCA
library(psych)
p2 = psych::principal(nba_scaled, rotate="promax", nfactors=10, scores=TRUE)
print(p2$loadings, cutoff=.4, sort=T)

#export data set to python for ridge regression
MoV = as.data.frame(nba$MarginOfVictory)
primkey = as.data.frame(nba$PrimKey)
home = as.data.frame(nba$Home)
nba_final = cbind.data.frame(primkey, MoV, home, nba.num2, deparse.level = 1)
str(nba_final)
colnames(nba_final)[1] = 'PrimKey'
colnames(nba_final)[2] = 'MoV'
colnames(nba_final)[3] = 'Home'
str(nba_final)
write.csv(nba_final, file = 'nba_subset_ridge.csv')

