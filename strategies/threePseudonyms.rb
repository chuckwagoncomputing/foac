# Keep track of who has three pseudonyms
class StrategythreePseudonyms
 def initialize(parent)
  @strategy = parent
  @player = @strategy.player
  @memory = @strategy.memory
 end

 def remember(calledName, calledTeam, calledPosition, calledPseudonym, callerName)
  # if someone called a number being remembered
  if @memory.value?(calledPseudonym)
   # delete the now obsolete memory
   @memory.delete_if {|key, value| value == calledPseudonym}
  end
  # if someone called me and I got their number
  if @memory.value?(@player.pseudonym)
   # delete the now obsolete memory
   @memory.delete_if {|key, value| value == @player.pseudonym}
  end
  # if there are less than three items in my memory and I was not it
  if @memory.length < 3 and callerName != @player.name
   # remember the it has the number that was just called because they traded
   @memory[callerName] = calledPseudonym
  end
 end

 def think
  # get a default player by random
  selection = $players.reject { |a| a == @player.pseudonym or a == @strategy.lastPseudonym }.sample
  # loop through remembered numbers
  evil = 5
  @memory.reject{|key, value| value == @strategy.lastPseudonym }.each do |mem|
   # if I can call someone to the couch and the remembered number is on my team
   if @player.position > 1 and @player.position < 6 and $teams[mem.first] == @player.team
    if evil > 0
     # lets stick them on
     selection = mem.last
     evil = 0
    end
   # if the remembered number is not on my team and they are on the couch
   elsif $teams[mem.first] != @player.team and $positions[mem.first] < 5
    if evil > 1
     # lets pull them off
     selection = mem.last
     evil = 1
    end
   # if they are not on the couch and are not being called to the couch we can't hurt much
   elsif $positions[mem.first] > 4 and @player.position.between?(2,5) != true
    if evil > 2
     # call them but don't break loop yet in case the next number is better
     selection = mem.last
     evil = 2
    end
   # if I can call someone to the couch but the remembered number is not on my team, better a random number, with theirs rejected.
   elsif @player.position > 1 and @player.position < 6 and $teams[mem.first] != @player.team
    if evil > 3
     selection = $players.reject { |a| a == @player.pseudonym or a == @strategy.lastPseudonym or a == mem.last}.sample
     evil = 3
    end
   # if they are on my team and they are on the couch, better a random number, with theirs rejected. If I am able to call to the couch, this will have already been caught.
   elsif $teams[mem.first] == @player.team and $positions[mem.first] < 5
    if evil > 4
     selection = $players.reject { |a| a == @player.pseudonym or a == @strategy.lastPseudonym or a == mem.last}.sample
     evil = 4
    end
   else
    # this is for debugging purposes
    puts "else called in strategy threePseudonyms.rb"
    puts @player.team
    puts $teams[mem.first]
    puts @player.position
    puts $positions[mem.first]
   end
  end
  return selection
 end
end
