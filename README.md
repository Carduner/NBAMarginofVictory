# NBAMarginofVictory
Group Project for Advanced Data Analysis Class at DePaul. This repository contains the data wrangling to get 2017-2018 box score stats into a trailing 6 game average of box score stats in order to predict the margin of victory for a team.

### Description of Files:
- 2017-18_teamBoxScore.csv is the dataset originally from https://www.kaggle.com/pablote/nba-enhanced-stats#2017-18_teamBoxScore.csv with a few deleted columns and the addition of the primkey and the opptkey
- 2017-18_trailing6TeamBoxScore.csv is the modified dataset which contains the team's and the oppenents' trailing box score average of the previous 6 games along with a few additional columns:
   - "Home" = coded as 1 for Home Game, 0 for Away
   - columns denoted with _x represent the team's trailing stats
   - columns denoted with _y represent the opponent's trailing stats
   - "MarginOfVictory" will be the dependent variable for the analysis yet to come
   - "teamDayOff" is not a trailing average as it is the number of days a team has had off in between games and something that is predetermined before the game starts so we can use to predict the dependent variable
  - Also note that the first 6 games for each team will be denoted as NA as a minimum window of 6 was set to calculate the trailing average data
- NBA_BoxScore_RollingAverages.ipynb is the script that transforms the original data into the modified trailing average data


   
