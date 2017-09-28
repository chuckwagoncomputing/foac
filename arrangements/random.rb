def arrangementrandom()
 teams = Hash.new
 teamOneCount = 0
 teamTwoCount = 0
 $players.each do |player|
  team = rand(2) + 1
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
  teams[player] = team
 end
 return teams
end
