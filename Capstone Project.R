batting <- read.csv('Batting.csv')
batting$BA <- batting$H / batting$AB
batting$OBP <- (batting$H + batting$BB + batting$HBP)/(batting$AB + batting$BB + batting$H + batting$HBP + batting$SF)
batting$SLG <- (batting$H + batting$X2B + (2*batting$X3B)+ (3*batting$HR))/(batting$AB)
sal <- read.csv('Salaries.csv')
batting <- subset(batting,subset=(yearID >= 1985))
combo <- merge(x=batting,y=sal,by=c('playerID','yearID'))
lost_players <- subset(combo,subset=(playerID %in% c('giambja01','damonjo01','saenzol01')))
lost_players <- subset(lost_players,subset=(yearID==2001))
lost_players <- lost_players[,c('playerID','H','X2B','X3B','HR','OBP','SLG','BA','AB')]

combo.replacement.players <- subset(combo,subset=((yearID == 2001) & (AB > 489) & (OBP > .29) & (salary < 10000000)))
combo.replacement.players <- combo.replacement.players[,c('playerID','H','X2B','X3B','HR','OBP','SLG','BA','AB','salary')]
combo.replacement.players <- combo.replacement.players[order(combo.replacement.players$BA,decreasing=TRUE),]