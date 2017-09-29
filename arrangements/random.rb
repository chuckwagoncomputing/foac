def arrangementrandom()
 teams = Hash.new
 teamOneCouchCount = 0
 teamTwoCouchCount = 0
 teamOneCount = 0
 teamTwoCount = 0
 $players.each do |player|
  team = rand(2) + 1

  if team == 1 and ( ( teamOneCouchCount == 2 and player <= 4 ) or teamOneCount == $playerCount / 2 )
   team = 2
  elsif team == 2 and ( ( teamTwoCouchCount == 2 and player <= 4 ) or teamTwoCount == $playerCount / 2 )
   team = 1
  end

  if team == 1
   if player <= 4
    teamOneCouchCount += 1
   end
   teamOneCount += 1
  else
   if player <= 4
    teamTwoCouchCount += 1
   end
   teamTwoCount += 1
  end
  teams[player] = team
 end
 return teams
end
