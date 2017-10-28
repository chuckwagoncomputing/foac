# Keep track of who has three pseudonyms, forgetting one in order to remember a better one
class Strategy
 def qualitativeThreeCouchCallerKeepFriend(name, team, position, pseudonym, calledName, calledTeam, calledPosition, calledPseudonym, callerName)
  selection = $players.reject { |a| a == pseudonym or a == calledPseudonym }.sample
  # if someone called a number being remembered
  if @memory.value?(calledPseudonym)
   # delete the now obsolete memory
   @memory.delete_if {|key, value| value == calledPseudonym}
  end
  # if someone called me and I got their number
  if @memory.value?(pseudonym)
   # delete the now obsolete memory
   @memory.delete_if {|key, value| value == pseudonym}
  end
  # loop through remembered numbers
  evil = 5
  (0..@memory.length - 1).each do |i|
   # if I can call someone to the couch and the remembered number is on my team
   if position > 1 and position < 6 and $teams[@memory.keys[i]] == team
    if evil > 0
     # lets stick them on
     selection = @memory.values[i]
     evil = 0
    end
   # if the remembered number is not on my team and they are on the couch
   elsif $teams[@memory.keys[i]] != team and $positions[@memory.keys[i]] < 5
    if evil > 1
     # lets pull them off
     selection = @memory.values[i]
     evil = 1
    end
   # if they are not on the couch and are not being called to the couch we can't hurt much
   elsif $positions[@memory.keys[i]] > 4 and position.between?(2,5) != true
    if evil > 2
     # call them but don't break loop yet in case the next number is better
     selection = @memory.values[i]
     evil = 2
    end
   # if I can call someone to the couch but the remembered number is not on my team, better a random number, with theirs rejected.
   elsif position > 1 and position < 6 and $teams[@memory.keys[i]] != team
    if evil > 3
     selection = $players.reject { |a| a == pseudonym or a == calledPseudonym or a == @memory.values[i]}.sample
     evil = 3
    end
   # if they are on my team and they are on the couch, better a random number, with theirs rejected. If I am able to call to the couch, this will have already been caught.
   elsif $teams[@memory.keys[i]] == team and $positions[@memory.keys[i]] < 5
    if evil > 4
     selection = $players.reject { |a| a == pseudonym or a == calledPseudonym or a == @memory.values[i]}.sample
     evil = 4
    end
   else
    # this is for debugging purposes
    puts "else called in strategy qualitativeThree.rb"
    puts team
    puts $teams[@memory.keys[i]]
    puts position
    puts $positions[@memory.keys[i]]
   end
  end
  # if my memory is full and I was not it
  if @memory.length == 3 and callerName != name
   # determine usefulness of the new one
   uselessness = 5
   # if they are on the couch and not on my team
   if $positions[callerName] < 5 and $teams[callerName] != team
    uselessness = 0
   # if they are in the position which the first person on the couch calls to,
   #  we can call them away and then get a known identity for the first person on the couch
   elsif $positions[callerName] == $playerCount + 1
    uselessness = 1
   # if they are on my team I might be able to call them to the couch
   elsif $teams[callerName] == team
    uselessness = 2
   # if they are on the couch and on my team we don't want to call them off
   elsif $positions[callerName] < 5 and $teams[callerName] == team
    uselessness = 3
   end
   # loop through players and find if any are worth losing to store the new one
   inutility = 0
   inutilePlayer = nil
   (0..@memory.length - 1).each do |i|
    # if the player is on the couch and they are not on my team
    if $positions[@memory.keys[i]] < 5 and $teams[@memory.keys[i]] != team
     if inutility == 0
      inutility = 0
      inutilePlayer = @memory.keys[i]
     end
    # if they are in the position which the first person on the couch calls to,
    #  we can call them away and then get a known identity for the first person on the couch
    elsif $positions[@memory.keys[i]] == $playerCount + 1
     if inutility < 1
      inutility = 1
      inutilePlayer = @memory.keys[i]
     end
    # if they are on my team I might be able to call them to the couch
    elsif $teams[@memory.keys[i]] == team
     if inutility < 2
      inutility = 2
      inutilePlayer = @memory.keys[i]
     end
    # if they are on the couch and on my team we don't want to call them off
    elsif $positions[@memory.keys[i]] < 5 and $teams[@memory.keys[i]] == team
     if inutility < 3
      inutility = 3
      inutilePlayer = @memory.keys[i]
     end
    elsif inutility < 4
     inutility = 4
     inutilePlayer = @memory.keys[i]
    end
   end
   # if the new one is more useful than the old one
   if uselessness < inutility and inutilePlayer
    # delete the inutile player
    @memory.delete(inutilePlayer)
   end
  end
  # if there are less than three items in my memory and I was not it
  if @memory.length < 3 and callerName != name
   # remember the it has the number that was just called because they traded
   @memory[callerName] = calledPseudonym
  end
  selection
 end
end
