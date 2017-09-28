def arrangementrandom()
 teams = Hash.new
 teamOneCouchCount = 0
 teamTwoCouchCount = 0
 teamOneCount = 0
 teamTwoCount = 0
 $players.each do |player|
  team = rand(2) + 1
  if player < 4
   if team == 1
    if teamOneCouchCount == 2
     team = 2
    else
     teamOneCouchCount += 1
     teamOneCount += 1
    end
   else
    if teamTwoCouchCount == 2
     team = 1
    else
     teamTwoCouchCount += 1
     teamTwoCount += 1
    end
   end
  else
   if team == 1
    if teamOneCount == $playerCount / 2
     team = 2
    else
     teamOneCount += 1
    end
   end
   if team == 2
    if teamTwoCount == $playerCount / 2
     team = 1
    else
     teamTwoCount += 1
    end
   end
  end
  teams[player] = team
 end
 return teams
end
