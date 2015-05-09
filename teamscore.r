teamscore <- function(teamname, originalscore) {
    # The input teamname is a single character string like "A" or "B"
    # The input originalscore is a dataframe with 12 columns and any number of rows, 
    # the column names of which have to be c("AB","BA","AC", ...)
    # The output is a matrix with 4 columns and the same number of rows,
    # each column corresponding to each team's accumulated points after the group matches.
    
    tscore=rep(0,nrow(originalscore))
    xxlist=list(A=c("B","C","D"), B=c("A","C","D"),
        C=c("A","B","D"), D=c("A","B","C"))
   
    name11=paste(teamname,xxlist[[teamname]][1], sep="")
    name12=paste(xxlist[[teamname]][1],teamname, sep="")
    name21=paste(teamname,xxlist[[teamname]][2], sep="")
    name22=paste(xxlist[[teamname]][2],teamname, sep="")
    name31=paste(teamname,xxlist[[teamname]][3], sep="")
    name32=paste(xxlist[[teamname]][3],teamname, sep="")
    
    for (i in 1:nrow(originalscore)) {
        score1=0
        score2=0
        score3=0
        if (originalscore[[name11]][i] > originalscore[[name12]][i])
            score1=3
        else if (originalscore[[name11]][i] == originalscore[[name12]][i])
            score1=1
        else
            score1=0

        if (originalscore[[name21]][i] > originalscore[[name22]][i])
            score2=3
        else if (originalscore[[name21]][i] == originalscore[[name22]][i])
            score2=1
        else
            score2=0

        if (originalscore[[name31]][i]> originalscore[[name32]][i])
            score3=3
        else if (originalscore[[name31]][i] == originalscore[[name32]][i])
            score3=1
        else
            score3=0
        tscore[i]=score1+score2+score3
    }
        return(tscore)  
}
