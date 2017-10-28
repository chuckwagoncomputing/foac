# Keep track of who has three pseudonyms
class StrategyenemyFromCouch
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
  selection = $players.reject { |a| a == @player.pseudonym or a == @strategy.lastPseudonym}.sample
  # loop through remembered numbers
  @memory.reject{|key, value| value == @strategy.lastPseudonym }.each do |mem|
   # if the remembered number is not on my team and they are on the couch
   if $teams[mem.first] != @player.team and $positions[mem.first] < 5
    # lets pull them off
    selection = mem.last
   end
  end
  return selection
 end

end
