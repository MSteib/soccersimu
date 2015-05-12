getWinmatrix <- function(originalscore) {
    ## The input originalscore is a m*12 data file,
    ## with m records of 12 column variables named 'AB' 'BA' 'AC' ... 'DC'
    ## the values are integers from 0 to >10
    ## The returned variable is a dataframe with m*4 dimension, all 0 or 1 values
    ## must be two 0s and two 1s for each row
    ## 2015-05-06
    source("teamscore.R")
    TscoreA = teamscore("A", originalscore)
    TscoreB = teamscore("B", originalscore)
    TscoreC = teamscore("C", originalscore)
    TscoreD = teamscore("D", originalscore)
	
    ABCD = c("A","B","C","D")
    
    selectA = rep(0, nrow(originalscore))
    selectB = rep(0, nrow(originalscore))
    selectC = rep(0, nrow(originalscore))
    selectD = rep(0, nrow(originalscore))
    selectMatrix = data.frame(selectA,selectB,selectC,selectD)
    names(selectMatrix) = ABCD
	
	for (i in 1:nrow(originalscore)) {
	        Asc = TscoreA[i]
		Bsc = TscoreB[i]
	        Csc = TscoreC[i]
		Dsc = TscoreD[i]
		grpscore = c(Asc, Bsc, Csc, Dsc)
		odrscore = sort(grpscore, decreasing = T, index.return = T)$x
		indexod = sort(grpscore, decreasing = T, index.return = T)$ix
		grpoder = ABCD[indexod]
		
		# make strings to use latter results to point to the data in the 'originalscore'
		# Note, from now on, the ranked four teams are fixed into team1, team2, team3 and team4.
		
		str12 = paste(grpoder[1],grpoder[2], sep="")
		str21 = paste(grpoder[2],grpoder[1], sep="")
		str13 = paste(grpoder[1],grpoder[3], sep="")
		str31 = paste(grpoder[3],grpoder[1], sep="")
		str23 = paste(grpoder[2],grpoder[3], sep="")
		str32 = paste(grpoder[3],grpoder[2], sep="")
		
		str14 = paste(grpoder[1],grpoder[4], sep="")
		str41 = paste(grpoder[4],grpoder[1], sep="")
		str24 = paste(grpoder[2],grpoder[4], sep="")
		str42 = paste(grpoder[4],grpoder[2], sep="")
		str34 = paste(grpoder[3],grpoder[4], sep="")
		str43 = paste(grpoder[4],grpoder[3], sep="")			
		
		# calculate the superior goals between any pair of teams
		df12 = originalscore[[str12]][i] - originalscore[[str21]][i]
		df13 = originalscore[[str13]][i] - originalscore[[str31]][i]
		df23 = originalscore[[str23]][i] - originalscore[[str32]][i]
		
		df14 = originalscore[[str14]][i] - originalscore[[str41]][i]
		df24 = originalscore[[str24]][i] - originalscore[[str42]][i]
		df34 = originalscore[[str34]][i] - originalscore[[str43]][i]
		
		df21 = -df12
		df31 = -df13
		df32 = -df23
		
		df41 = -df14
		df42 = -df24
		df43 = -df34	
		
		## The easiest scenario, just pick the team1 and team2 to enter the final games
		if (odrscore[2] > odrscore[3]) {
		    selectMatrix[[grpoder[1]]][i] = 1
			selectMatrix[[grpoder[2]]][i] = 1
		    selectMatrix[[grpoder[3]]][i] = 0
			selectMatrix[[grpoder[4]]][i] = 0
		}
		
		## If the first three teams have same scores
		else if (odrscore[1] == odrscore[2] & odrscore[3] > odrscore[4]) {
		    selectMatrix[[grpoder[4]]][i] = 0

			# Below is the superior goals for team1, team2 and team3, not considering the matches against team4
			df1 = df12 + df13
			df2 = df21 + df23
			df3 = df31 + df32
			
			# first rank based on df
			dfsorted = sort(c(df1,df2,df3), decreasing = T, index.return = T)$x
			dfindex = sort(c(df1,df2,df3), decreasing = T, index.return = T)$ix
			
			
			# Below is the superior goals for team1, team2 and team3, considering the matches against team4
			tdf1 = df12 + df13 + df14
			tdf2 = df21 + df23 + df24
			tdf3 = df31 + df32 + df34
			tdf = c(tdf1,tdf2,tdf3)
			
			tdfsorted = sort(tdf, decreasing = T, index.return = T)$x
			tdfindex = sort(tdf, decreasing = T, index.return = T)$ix
			
			# below is the total goals for team1, team2 and team3, excluding their goals against team4
			ttsc1 = originalscore[[str12]][i] +originalscore[[str13]][i]
			ttsc2 = originalscore[[str21]][i] +originalscore[[str23]][i]
			ttsc3 = originalscore[[str31]][i] +originalscore[[str32]][i]
            # write them into a vector to ease further computation
			ttsc = c(ttsc1,ttsc2,ttsc3)
			
			ttscsorted = sort(ttsc, decreasing = T, index.return = T)$x
			ttscindex = sort(ttsc, decreasing = T, index.return = T)$ix
			
			# below is the total goals for the three teams including their goals against team4
			tt4sc1 = originalscore[[str12]][i] +originalscore[[str13]][i]+originalscore[[str14]][i]
			tt4sc2 = originalscore[[str21]][i] +originalscore[[str23]][i]+originalscore[[str24]][i]
			tt4sc3 = originalscore[[str31]][i] +originalscore[[str32]][i]+originalscore[[str34]][i]
			tt4sc = c(tt4sc1,tt4sc2,tt4sc3)
			
			tt4scsorted = sort(tt4sc, decreasing = T, index.return = T)$x
			tt4scindex = sort(tt4sc, decreasing = T, index.return = T)$ix

			# Note here dfindex will represent the max-min order of df1, df2 and df3, corresponding to the team1, team2 and team3
			# e.g. if dfindex[1] ==2, that means team2 has the max superior goals among the three teams.
			# and if dfindex[2] ==3, that means team3 has the second max superior goals among the three teams.
			# Note that grpoder[3] will return the real group name (A, B, C or D) of team3.
			# and grpoder[dfindex[1]] will return the real group name (A, B, C or D) of the team which ranks first in the superior goals.
			
			
			if (dfsorted[2]>dfsorted[3]) {
			    selectMatrix[[grpoder[dfindex[1]]]][i] = 1
				selectMatrix[[grpoder[dfindex[2]]]][i] = 1
				selectMatrix[[grpoder[dfindex[3]]]][i] = 0
			}
			else if (dfsorted[1]>dfsorted[2]) {   # consider when the df can't separate the second and the third, but can pick the first 
			    selectMatrix[[grpoder[dfindex[1]]]][i] = 1   
				if (ttsc[dfindex[2]] > ttsc[dfindex[3]]) { # use total goals among the three teams to separate the 2nd and 3rd
				    selectMatrix[[grpoder[dfindex[2]]]][i] = 1
					selectMatrix[[grpoder[dfindex[3]]]][i] = 0
				}
				else if (ttsc[dfindex[2]] < ttsc[dfindex[3]]) {
				    selectMatrix[[grpoder[dfindex[2]]]][i] = 0
					selectMatrix[[grpoder[dfindex[3]]]][i] = 1
				}
				else {                #  total goals won't work, so try the superior goals including team4
				    if (tdf[dfindex[2]] > tdf[dfindex[3]]) {
				    selectMatrix[[grpoder[dfindex[2]]]][i] = 1
					selectMatrix[[grpoder[dfindex[3]]]][i] = 0
				    }
					else if (tdf[dfindex[2]] < tdf[dfindex[3]]) {
				    selectMatrix[[grpoder[dfindex[2]]]][i] = 0
					selectMatrix[[grpoder[dfindex[3]]]][i] = 1
				    }
					else {       # superior goals including team4 still won't work, so try total goals including team4
					    if (tt4sc[dfindex[2]] > tt4sc[dfindex[3]]) {
				        selectMatrix[[grpoder[dfindex[2]]]][i] = 1
					    selectMatrix[[grpoder[dfindex[3]]]][i] = 0
				        }
					    else {
				        selectMatrix[[grpoder[dfindex[2]]]][i] = 0
					    selectMatrix[[grpoder[dfindex[3]]]][i] = 1
				        } ## here to save simplicity, we just ignore the case when tt4sc[dfindex[2]] == tt4sc[dfindex[3]]
					}
				}
			}
			else { # this is the case when the first three teams have the same superior goal number, dfsorted[1]==dfsorted[2]==dfsorted[3]
			# remember
			# ttscsorted = sort(ttsc, decreasing = T, index.return = T)$x
			# ttscindex = sort(ttsc, decreasing = T, index.return = T)$ix
			    if (ttsc[ttscindex[2]] > ttsc[ttscindex[3]]) { # use total goals among the three teams to separate them
				    selectMatrix[[grpoder[ttscindex[1]]]][i] = 1
					selectMatrix[[grpoder[ttscindex[2]]]][i] = 1
					selectMatrix[[grpoder[ttscindex[3]]]][i] = 0
				}
				else if (ttsc[ttscindex[1]] > ttsc[ttscindex[2]]) {
				    selectMatrix[[grpoder[ttscindex[1]]]][i] = 1
					# now ttsc can't order ttsc[ttscindex[2]] and ttsc[ttscindex[3]]
					# use tdf to compare them
					if (tdf[ttscindex[2]] > tdf[ttscindex[3]]) {
				        selectMatrix[[grpoder[ttscindex[2]]]][i] = 1
					    selectMatrix[[grpoder[ttscindex[3]]]][i] = 0
				    }
					else if (tdf[ttscindex[2]] < tdf[ttscindex[3]]) {
				        selectMatrix[[grpoder[ttscindex[2]]]][i] = 0
					    selectMatrix[[grpoder[ttscindex[3]]]][i] = 1
				    }
					else { # now tdf can't do the job, use tt4sc
					    if (tt4sc[ttscindex[2]] > tt4sc[ttscindex[3]]) {
				            selectMatrix[[grpoder[ttscindex[2]]]][i] = 1
					        selectMatrix[[grpoder[ttscindex[3]]]][i] = 0
				        }
					    else {
				            selectMatrix[[grpoder[ttscindex[2]]]][i] = 0
					        selectMatrix[[grpoder[ttscindex[3]]]][i] = 1
				        } ## here to save simplicity, we just ignore the case when tt4sc[ttscindex[2]] == tt4sc[ttscindex[3]]
					}
				}
				else { # this is the case when the first three teams have the same superior goal number, 
				       # and the same total goal number among the three teams
					   # so we use tdf, the superior goals including team4
					   # remember tdf = c(tdf1,tdf2,tdf3)
			           # tdfsorted = sort(tdf, decreasing = T, index.return = T)$x
			           # tdfindex = sort(tdf, decreasing = T, index.return = T)$ix
				    if (tdf[tdfindex[2]] > tdf[tdfindex[3]]) {
				        selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
						selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
					    selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				    }
					else if (tdf[tdfindex[1]] > tdf[tdfindex[2]]) {
				        selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
						# Then tdf can't compare tdf[tdfindex[2] and tdf[tdfindex[3]
						# use tt4sc
						if (tt4sc[tdfindex[2]] > tt4sc[tdfindex[3]]) {
				            selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
					        selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				        }
					    else { # still ignore complex things
				            selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
					        selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
				        }
				    }
					else {  # all the three teams have the same tdf, use tt4sc
					    	# tt4sc = c(tt4sc1,tt4sc2,tt4sc3)			
			                # tt4scsorted = sort(tt4sc, decreasing = T, index.return = T)$x
			                # tt4scindex = sort(tt4sc, decreasing = T, index.return = T)$ix
						if (tt4sc[tt4scindex[2]] > tt4sc[tt4scindex[3]]) {
				            selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
							selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
					        selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
				        }
					    else if (tt4sc[tt4scindex[1]] > tt4sc[tt4scindex[2]]) { 
				            selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
							randomn=runif(1,0,2)
							if (randomn<1) {
							    selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
								selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
							}
							else {
							    selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
								selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
							}
					        
				        }
						else {
						    randomn=runif(1,0,3)
							if (randomn<1) {
							    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
								selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
								selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
							}
							if (randomn>=2) {
							    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 0
								selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
								selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
							}
							else {
							    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
								selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
								selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
							}
						}
					}
				}				
			}
		}
		
		
		## If the last three teams have same scores
		else if (odrscore[1] > odrscore[2] & odrscore[3] == odrscore[4]) {
		    # firstly, team1 is guaranteed
		    selectMatrix[[grpoder[1]]][i] = 1

                # Below is the superior goals for team2, team3 and team4, not considering the matches against team1
			
			df2 = df24 + df23
			df3 = df34 + df32
			df4 = df42 + df43
			
			# first rank based on df
			dfsorted = sort(c(df2,df3,df4), decreasing = T, index.return = T)$x
			dfindex = sort(c(df2,df3,df4), decreasing = T, index.return = T)$ix
			dfindex = dfindex + 1
			# Note all the indexes in this part should +1, to reflect the real index of team2, team3 and team4
			
			# Below is the superior goals for team2, team3 and team4, considering the matches against team1
			
			tdf2 = df21 + df23 + df24
			tdf3 = df31 + df32 + df34
			tdf4 = df42 + df43 + df41
			tdf = c(tdf2,tdf3,tdf4)
			
			tdfsorted = sort(tdf, decreasing = T, index.return = T)$x
			tdfindex = sort(tdf, decreasing = T, index.return = T)$ix
			tdfindex = tdfindex + 1
			
			# below is the total goals for team2, team3 and team4, excluding their goals against team1
			
			ttsc2 = originalscore[[str24]][i] +originalscore[[str23]][i]
			ttsc3 = originalscore[[str34]][i] +originalscore[[str32]][i]
			ttsc4 = originalscore[[str42]][i] +originalscore[[str43]][i]
			
                # write them into a vector to ease further computation
			ttsc = c(ttsc2,ttsc3,ttsc4)
			
			ttscsorted = sort(ttsc, decreasing = T, index.return = T)$x
			ttscindex = sort(ttsc, decreasing = T, index.return = T)$ix
			ttscindex = ttscindex + 1
			
			# below is the total goals for the three teams including their goals against team1
			
			tt4sc2 = originalscore[[str21]][i] +originalscore[[str23]][i]+originalscore[[str24]][i]
			tt4sc3 = originalscore[[str31]][i] +originalscore[[str32]][i]+originalscore[[str34]][i]
			tt4sc4 = originalscore[[str42]][i] +originalscore[[str43]][i]+originalscore[[str41]][i]
			tt4sc = c(tt4sc2,tt4sc3,tt4sc4)
			
			tt4scsorted = sort(tt4sc, decreasing = T, index.return = T)$x
			tt4scindex = sort(tt4sc, decreasing = T, index.return = T)$ix
			tt4scindex = tt4scindex + 1
            
			if (dfsorted[1] > dfsorted[2]) { # just pick up the highest one as the second winning team 
			    selectMatrix[[grpoder[dfindex[1]]]][i] = 1
				selectMatrix[[grpoder[dfindex[2]]]][i] = 0
				selectMatrix[[grpoder[dfindex[3]]]][i] = 0
			}
			else if (dfsorted[2] > dfsorted[3]) { # here we have to go on with teams grpoder[dfindex[1]] and grpoder[dfindex[2]]
			    selectMatrix[[grpoder[dfindex[3]]]][i] = 0
			    # use ttsc
				if (ttsc[dfindex[1]-1] > ttsc[dfindex[2]-1]) { 
				#  Note here using ttsc[dfindex[1]-1]. dfindex[1] is the real team number, 
				# while the expression ttsc[dfindex[1]-1] points to its ttsc value
				
			        selectMatrix[[grpoder[dfindex[1]]]][i] = 1
				    selectMatrix[[grpoder[dfindex[2]]]][i] = 0
			    }
			    else if (ttsc[dfindex[1]-1] < ttsc[dfindex[2]-1]) { # 
			    #  
				    selectMatrix[[grpoder[dfindex[1]]]][i] = 0
				    selectMatrix[[grpoder[dfindex[2]]]][i] = 1
			    }
			    else { # use tdf
				    if (tdf[dfindex[1]-1] > tdf[dfindex[2]-1]) { 		
			            selectMatrix[[grpoder[dfindex[1]]]][i] = 1
				        selectMatrix[[grpoder[dfindex[2]]]][i] = 0
			        }
			        else if (tdf[dfindex[1]-1] < tdf[dfindex[2]-1]) { # 
			        #  
				        selectMatrix[[grpoder[dfindex[1]]]][i] = 0
				        selectMatrix[[grpoder[dfindex[2]]]][i] = 1
			        }
					else { # use tt4sc
					    if (tt4sc[dfindex[1]-1] > tt4sc[dfindex[2]-1]) { 			
			                selectMatrix[[grpoder[dfindex[1]]]][i] = 1
				            selectMatrix[[grpoder[dfindex[2]]]][i] = 0
			            }
			            else{
						    selectMatrix[[grpoder[dfindex[1]]]][i] = 0
				            selectMatrix[[grpoder[dfindex[2]]]][i] = 1
						}
					}
				}
			}
			else {  # here all the three teams (2,3,4) have the same superior goal number
			    # use ttsc[ttscindex[]]
				if (ttsc[ttscindex[1]-1] > ttsc[ttscindex[2]-1]) {   # when ttsc can do all the work
			        selectMatrix[[grpoder[ttscindex[1]]]][i] = 1
				    selectMatrix[[grpoder[ttscindex[2]]]][i] = 0
					selectMatrix[[grpoder[ttscindex[3]]]][i] = 0
			    }
			    else if (ttsc[ttscindex[2]-1] > ttsc[ttscindex[3]-1]) { # when ttsc can only tell the last team but not the 2nd and 3rd
			        selectMatrix[[grpoder[ttscindex[3]]]][i] = 0
				    # use tdf to compare ttscindex[1] and ttscindex[2]
					if (tdf[ttscindex[1]-1] > tdf[ttscindex[2]-1]) { 		
			            selectMatrix[[grpoder[ttscindex[1]]]][i] = 1
				        selectMatrix[[grpoder[ttscindex[2]]]][i] = 0
			        }
			        else if (tdf[ttscindex[1]-1] < tdf[ttscindex[2]-1]) { # 
			        #  
				        selectMatrix[[grpoder[ttscindex[1]]]][i] = 0
				        selectMatrix[[grpoder[ttscindex[2]]]][i] = 1
			        }
					else { # use tt4sc to compare ttscindex[1] and ttscindex[2]
					    if (tt4sc[ttscindex[1]-1] > tt4sc[ttscindex[2]-1]) { 			
			                selectMatrix[[grpoder[ttscindex[1]]]][i] = 1
				            selectMatrix[[grpoder[ttscindex[2]]]][i] = 0
			            }
			            else{
						    selectMatrix[[grpoder[ttscindex[1]]]][i] = 0
				            selectMatrix[[grpoder[ttscindex[2]]]][i] = 1
						}
					}
					
			    }
			    else { # when ttsc is the same for all the team2, team3 and team4
				    # use tdf for all
					if (tdf[tdfindex[1]-1] > tdf[tdfindex[2]-1]) { # when tdf can do the work to pick the single highest from team2, team3, team4
				        selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
						selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
					    selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				    }
					else if (tdf[tdfindex[2]-1] > tdf[tdfindex[3]-1]) { # when tdf can tell the last one to be rejected
				        selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
						# Then tdf can't compare tdf[tdfindex[1]] and tdf[tdfindex[2]]
						# use tt4sc
						if (tt4sc[tdfindex[1]-1] > tt4sc[tdfindex[2]-1]) {
				            selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
					        selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
				        }
					    else { # still ignore complex things
				            selectMatrix[[grpoder[tdfindex[1]]]][i] = 0
					        selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
				        }
				    }
					else { # when when tdf is the same for the three teams 2, 3, 4, we will just use tt4sc
					    if (tt4sc[tt4scindex[1]-1] > tt4sc[tt4scindex[2]-1]) {
				            selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
							selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
					        selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
				        }
						else if (tt4sc[tt4scindex[2]-1] > tt4sc[tt4scindex[3]-1]) { # still ignore complex things, but add something not so ignorant
						    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 0
							selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
					        selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
						}
						
					    else { 
				            selectMatrix[[grpoder[tt4scindex[1]]]][i] = 0
							selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
					        selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
				        }
					}
				}
			}
		}
		
		## If all the four teams have same scores
		else if (odrscore[1] == odrscore[2] & odrscore[3] == odrscore[4]) {
		    # we will need all the indexes for all the 4 teams
			# we don't need df and ttsc, we only need tdf and tt4sc
			tdf1 = df14 + df13 + df12
			tdf2 = df24 + df23 + df21
			tdf3 = df34 + df32 + df31
			tdf4 = df42 + df43 + df41
			tdf = c(tdf1, tdf2, tdf3, tdf4)
			# first rank based on df
			tdfsorted = sort(c(tdf1, tdf2, tdf3, tdf4), decreasing = T, index.return = T)$x
			tdfindex = sort(c(tdf1, tdf2, tdf3, tdf4), decreasing = T, index.return = T)$ix
			
			# below is the total goals for the three teams including their goals against team1
			tt4sc1 = originalscore[[str12]][i] + originalscore[[str13]][i] + originalscore[[str14]][i]
			tt4sc2 = originalscore[[str21]][i] + originalscore[[str23]][i] + originalscore[[str24]][i]
			tt4sc3 = originalscore[[str31]][i] + originalscore[[str32]][i] + originalscore[[str34]][i]
			tt4sc4 = originalscore[[str42]][i] + originalscore[[str43]][i] + originalscore[[str41]][i]
			tt4sc = c(tt4sc1,tt4sc2,tt4sc3,tt4sc4)
			
			tt4scsorted = sort(tt4sc, decreasing = T, index.return = T)$x
			tt4scindex = sort(tt4sc, decreasing = T, index.return = T)$ix
            
			# selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
			# use tdf
			if (tdfsorted[2]>tdfsorted[3]){
			    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
				selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
				selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
			}
			else if (tdfsorted[3]>tdfsorted[4] & tdfsorted[1]==tdfsorted[2]) { # the first three teams have the same tdf
			    selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
				# use tt4sc
				# here it's complex, cause we have to reorder the three groups according to tt4sc. 
				# to avoid coding mistake, just use multiple logic conditions
				if ( tt4sc[tdfindex[1]]>tt4sc[tdfindex[3]] & tt4sc[tdfindex[2]]>tt4sc[tdfindex[3]] ) {
				    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
				    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
				    selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				}
				else if (tt4sc[tdfindex[1]]>tt4sc[tdfindex[2]] & tt4sc[tdfindex[3]]>tt4sc[tdfindex[2]]) {
				    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
				    selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
				    selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
				}
				else if (tt4sc[tdfindex[2]]>tt4sc[tdfindex[1]] & tt4sc[tdfindex[3]]>tt4sc[tdfindex[1]]) {
				    selectMatrix[[grpoder[tdfindex[1]]]][i] = 0
				    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
				    selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
				}
				else { # use long but easy code for this section, in this case, there could be one max value but the other two equal
					if (tt4sc[tdfindex[1]]>tt4sc[tdfindex[2]]) {
					    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1	
						randomn = runif(1,0,2)
						if (randomn<1) {
						    selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
							selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
						}
				        else {
						    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
							selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
						}
					}
					else if (tt4sc[tdfindex[2]]>tt4sc[tdfindex[3]]) {
					    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
						randomn = runif(1,0,2)
						if (randomn<1) {
						    selectMatrix[[grpoder[tdfindex[1]]]][i] = 0
							selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
						}
						else {
						    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
							selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
						}
					}
					else if (tt4sc[tdfindex[3]]>tt4sc[tdfindex[1]]) {
					    selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
						randomn = runif(1,0,2)
						if (randomn<1) {
						    selectMatrix[[grpoder[tdfindex[1]]]][i] = 0
							selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
						}
						else {
						    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
							selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
						}
					}
					else {  # now all the three are equal in tt4sc
					    randomn = runif(1,0,3) # generate a random number between 0 and 3
						if (randomn<1) {
						    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1	
						    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
						    selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
						}
						else if (randomn>=2) {
						    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
							selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
							selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
						}
						else {
						    selectMatrix[[grpoder[tdfindex[1]]]][i] = 0
							selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
							selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
						}
					}
				}
			}
			else if (tdfsorted[1]>tdfsorted[2] & tdfsorted[3]==tdfsorted[4]) { # the last three teams hve the same tdf
			    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
				# use tt4sc
				# here it's complex, cause we have to reorder the three groups according to tt4sc. 
				# to avoid coding mistake, just use multiple logic conditions
				if (tt4sc[tdfindex[2]]>tt4sc[tdfindex[3]] & tt4sc[tdfindex[2]]>tt4sc[tdfindex[4]]) {
				    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
				    selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				    selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
				}
				else if (tt4sc[tdfindex[3]]>tt4sc[tdfindex[2]] & tt4sc[tdfindex[3]]>tt4sc[tdfindex[4]]) {
				    selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
				    selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
				    selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
				}
				else if (tt4sc[tdfindex[4]]>tt4sc[tdfindex[2]] & tt4sc[tdfindex[4]]>tt4sc[tdfindex[3]]) {
				    selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
				    selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				    selectMatrix[[grpoder[tdfindex[4]]]][i] = 1
				}
				else { # in this case tt4sc can't do the work, we will just randomly select one to enter and two to lose
				    # the following code in this block is actually wrong, because we don't exclude the worst team using tt4sc
				    randomn = runif(1,0,3) # generate a random number between 0 and 3
					if (randomn<1) {
					    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
				        selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				        selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
					}
					else if (randomn>=2) {
					    selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
						selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
						selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
					}
					else {
					    selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
						selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
						selectMatrix[[grpoder[tdfindex[4]]]][i] = 1
					}
				}
				
			}
			else if (tdfsorted[1]>tdfsorted[2] & tdfsorted[3]>tdfsorted[4]) {
			    selectMatrix[[grpoder[tdfindex[1]]]][i] = 1
				selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
				
				# first, go to the original score to check the winning relationship
				
				str22 = grpoder[tdfindex[2]]
				str33 = grpoder[tdfindex[3]]
				
				str2233 = paste(str22,str33, sep="")
				str3322 = paste(str33,str22, sep="")
				
				dfdf23 = originalscore[[str2233]][i] - originalscore[[str3322]][i]
				
				if (dfdf23>0) {
				    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
					selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				}
				else if (dfdf23<0) {
				    selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
					selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
				}
				else { # the winning relationship doesn't work
				    # use tt4sc
				    if(tt4sc[tdfindex[2]]>tt4sc[tdfindex[3]]) {
					    selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
						selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
					}
					else if (tt4sc[tdfindex[2]]<tt4sc[tdfindex[3]]) {
					    selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
						selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
					}
					else { # tt4sc can't judge
					    randomn = round(runif(1,0,1))
						selectMatrix[[grpoder[tdfindex[2]]]][i] = randomn
						selectMatrix[[grpoder[tdfindex[3]]]][i] = 1 - randomn
					}
				}
			}
			else { # all the four teams have the same tdf
			    # use tt4sc for all the four teams
				if (tt4sc[tt4scindex[2]]>tt4sc[tt4scindex[3]]) {  # when tt4sc just does the work
				    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
					selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
				    selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
				    selectMatrix[[grpoder[tt4scindex[4]]]][i] = 0
				}
				else if (tt4sc[tt4scindex[1]]>tt4sc[tt4scindex[2]]){ # when tt4sc doesn't do, but can give one team to winning
				    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
					if (tt4sc[tt4scindex[3]]==tt4sc[tt4scindex[4]]) { # when the last three are equal
				        randomn = runif(1,0,3) 
					    if (randomn<1) {
					        selectMatrix[[grpoder[tdfindex[2]]]][i] = 1
				            selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
				            selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
					    }
					    else if (randomn>=2) {
					        selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
					    	selectMatrix[[grpoder[tdfindex[3]]]][i] = 1
					    	selectMatrix[[grpoder[tdfindex[4]]]][i] = 0
					    }
					    else {
					        selectMatrix[[grpoder[tdfindex[2]]]][i] = 0
					    	selectMatrix[[grpoder[tdfindex[3]]]][i] = 0
					    	selectMatrix[[grpoder[tdfindex[4]]]][i] = 1
					    }
					}
					else {   # when the last one is determined
					    selectMatrix[[grpoder[tt4scindex[4]]]][i] = 0
						randomn = runif(1,0,2) # generate a random numb
						if (randomn<1) {
						    selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
						    selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
						}
						else{
						    selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
							selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
						}
					}
				}
				else if (tt4sc[tt4scindex[3]]>tt4sc[tt4scindex[4]]) { # when one team should lose
				    selectMatrix[[grpoder[tt4scindex[4]]]][i] = 0

					randomn = runif(1,0,3) # generate a random number between 0 and 3
					if (randomn<1) {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
				        selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
				        selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
					}
					else if (randomn>=2) {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
					}
					else {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
					}
				}
				else { # when all is up to chance
				    randomn = runif(1,0,6) # generate a random number between 0 and 3
					if (randomn<1) {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
				        selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
				        selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[4]]]][i] = 0
					}
					else if (randomn>=1 & randomn<2) {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[4]]]][i] = 0
					}
					else if (randomn>=2 & randomn<3) {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[4]]]][i] = 0
					}
					else if (randomn>=3 & randomn<4) {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[3]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[4]]]][i] = 1
					}
					else if (randomn>=4 & randomn<5) {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[2]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[4]]]][i] = 1
					}
					else {
					    selectMatrix[[grpoder[tt4scindex[1]]]][i] = 1
						selectMatrix[[grpoder[tt4scindex[2]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[3]]]][i] = 0
						selectMatrix[[grpoder[tt4scindex[4]]]][i] = 1
					}
				}
			}			
		}
		
		## If only the middle two teams have same scores
		else {
		    # team1 and team4 are no problem
			selectMatrix[[grpoder[1]]][i] = 1
			selectMatrix[[grpoder[4]]][i] = 0
			
			# first, see who wins the game against each other 
			if (df23 > 0) { # team2 wins
			    selectMatrix[[grpoder[2]]][i] = 1
				selectMatrix[[grpoder[3]]][i] = 0
			}
			else if (df23 < 0) { # team3 wins
			    selectMatrix[[grpoder[2]]][i] = 0
				selectMatrix[[grpoder[3]]][i] = 1
			}
			else { # when team2 and team3 had a draw
			    # use tdf and then tt4sc
				# tdf
				tdf2 = df21 + df23 + df24
			    tdf3 = df31 + df32 + df34
			    if (tdf2 > tdf3) {
				    selectMatrix[[grpoder[2]]][i] = 1
				    selectMatrix[[grpoder[3]]][i] = 0
				}
				else if (tdf2 < tdf3) {
				    selectMatrix[[grpoder[2]]][i] = 0
				    selectMatrix[[grpoder[3]]][i] = 1
				}
				else { # tt4sc
				    tt4sc2 = originalscore[[str21]][i] +originalscore[[str23]][i]+originalscore[[str24]][i]
					tt4sc3 = originalscore[[str31]][i] +originalscore[[str32]][i]+originalscore[[str34]][i]
					
					if (tt4sc2 > tt4sc3) {
					    selectMatrix[[grpoder[2]]][i] = 1
					    selectMatrix[[grpoder[3]]][i] = 0
					}
					else if (tt4sc2 < tt4sc3) {
					    selectMatrix[[grpoder[2]]][i] = 0
					    selectMatrix[[grpoder[3]]][i] = 1
					}
					else { # can only draw a ticket
					    randomn = runif(1,0,2)
						if (randomn > 1) {
						    selectMatrix[[grpoder[2]]][i] = 1
						    selectMatrix[[grpoder[3]]][i] = 0
						}
						else {
						    selectMatrix[[grpoder[2]]][i] = 0
						    selectMatrix[[grpoder[3]]][i] = 1
						}
					}
				}
			}
		}    
	}
    return(selectMatrix)
}
