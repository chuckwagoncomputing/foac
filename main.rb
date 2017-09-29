#!/usr/bin/env ruby

require "./strategies/qualitativeThreeCouchCaller.rb"
require "./strategies/qualitativeThree.rb"
require "./strategies/threePseudonymsMaybe.rb"
require "./strategies/threePseudonyms.rb"

require "./arrangements/random.rb"

class Player
 attr_accessor :name, :team, :position, :pseudonym

 def initialize(name, team, pseudonym, strategy)
  @name = name
  @team = team
  @position = name
  @pseudonym = pseudonym
  @selection = $players.reject { |a| a == @pseudonym }.sample
  @strategy = Strategy.new(self, strategy)
 end

 def update
  @position = $positions[@name]
  @pseudonym = $pseudonyms[@name]
 end

 def think
  return @strategy.think
 end

 def remember(calledName, calledTeam, calledPosition, calledPseudonym, callerName)
  @strategy.remember(calledName, calledTeam, calledPosition, calledPseudonym, callerName)
 end
end

class Strategy
 attr_accessor :player, :memory, :lastPseudonym

 def initialize(parent, strategy)
  @player = parent
  @memory = Hash.new
  @playerStrategy = eval("Strategy#{strategy}.new(self)")
 end

 def think
  return @playerStrategy.think
 end

 def remember(calledName, calledTeam, calledPosition, calledPseudonym, callerName)
  @lastPseudonym = calledPseudonym
  @playerStrategy.remember(calledName, calledTeam, calledPosition, calledPseudonym, callerName)
 end

 class Strategyrandom
  def initialize(parent)
   @strategy = parent
   @player = @strategy.player
  end
  def think
   # random player besides me or the last it 'cause that's against the rules
   return $players.reject { |a| a == @player.pseudonym or a == @strategy.lastPseudonym }.sample
  end
  def remember(calledName, calledTeam, calledPosition, calledPseudonym, callerName)
  end
 end
end

def arrange(arrangement)
 return eval("arrangement#{arrangement}()")
end

def arrangementalternating()
 # make an array of players
 teams = Hash.new

 $players.each do |player|
  if player.even?
   team = 2
  else
   team = 1
  end
  teams[player] = team
 end
 return teams
end

def runGame(verbose)
 # make an empty chair
 $emptyChair = $playerCount + 1

 $players = (1..$playerCount).to_a
 $pseudonyms = Hash[$players.zip($players.shuffle)]
 $positions = Hash[$players.zip($players)]
 $teams = arrange($arrangement)
 $players.each do |player|
  team = $teams[player]
  if team == 1
   strategy = $strategyOne
  elsif team == 2
   strategy = $strategyTwo
  end
  eval("$player#{player} = Player.new(player, team, $pseudonyms[player], strategy)")
 end

 lastPseudonym = nil

 loop do
  # if the empty chair is the last before the couch, the first on the couch (position 1) is it.
  if $emptyChair == $playerCount + 1
   callerPosition = 1
  # otherwise we can just add one to get the its position
  else
   callerPosition = $emptyChair + 1
  end
  # get the name of the caller from their position
  callerName = $positions.key(callerPosition)
  # let them select
  calledPseudonym = eval("$player#{callerName}.think")
  # ensure the name isn't the same as was called last time
  if calledPseudonym == lastPseudonym
   puts "Error: Cannot call the same name as the last round"
   break
  else
   lastPseudonym = calledPseudonym
  end
  # get the selection's real name
  calledName = $pseudonyms.key(calledPseudonym)
  # make sure they didn't call themselves
  if callerName == calledName
   puts "Error: Cannot call yourself"
   break
  end
  # retrieve the team they are on
  calledTeam = $teams[calledName]
  # and their position
  calledPosition = $positions[calledName]
  # move them to the empty chair
  $positions[calledName] = $emptyChair
  puts "Player #{callerName} called player #{calledName} from #{calledPosition} to #{$emptyChair} and is now #{calledPseudonym}" if verbose
  # check if someone won
  if $teams[$positions.key(1)] == $teams[$positions.key(2)]
   if $teams[$positions.key(2)] == $teams[$positions.key(3)]
    if $teams[$positions.key(3)] == $teams[$positions.key(4)]
     return $teams[$positions.key(1)]
    end
   end
  end
  # make the chair they were in the new empty chair
  $emptyChair = calledPosition
  # trade pseudonyms
  $pseudonyms[calledName] = $pseudonyms[callerName]
  $pseudonyms[callerName] = calledPseudonym
  # let them both figure out what we did to them
  eval("$player#{callerName}.update") 
  eval("$player#{calledName}.update")
  # let all the players take note of what happened
  $players.each do |player|
   eval("$player#{player}.remember(calledName, calledTeam, calledPosition, calledPseudonym, callerName)")
  end
 end
end

if ARGV.include?("-h") or ARGV.include?("--help")
 puts "Usage: [-h|--help] [-c <player count>] [-a <arrangement>] [-1 <team 1 strategy>] [-2 <team 2 strategy>] [-b <number of times to run>] [-v]"
 puts "e.g. main.rb -c 20 -1 random -2 threePseudonyms"
 puts "If options are not provided, the defaults are 16 players, all with the 'random' strategy"
 puts "The number of players will be rounded down to the nearest even number."
 exit 1
end

if ARGV.include?("-v")
 verbose = true
end

if cindex = ARGV.index('-c')
 $playerCount = ARGV[cindex + 1].to_i
else
 $playerCount = 16 
end

if aindex = ARGV.index('-a')
 $arrangement = ARGV[aindex + 1]
else
 $arrangement = "alternating"
end

if sindex = ARGV.index('-1')
 $strategyOne = ARGV[sindex + 1]
else
 $strategyOne = "random"
end

if sindex = ARGV.index('-2')
 $strategyTwo = ARGV[sindex + 1]
else
 $strategyTwo = "random"
end

if bindex = ARGV.index('-b')
 benchmarkRuns = ARGV[bindex + 1].to_i
else
 benchmarkRuns = 0
end

if benchmarkRuns > 0
 teamOneCount = 0
 teamTwoCount = 0
 benchmarkRuns.times do
  winningTeam = runGame(verbose)
  if winningTeam == 1
   teamOneCount += 1
  else
   teamTwoCount += 1
  end
 end
 puts "Team 1 won #{teamOneCount} times, Team 2 won #{teamTwoCount} times"
else
 winningTeam = runGame(verbose)
 puts "Team #{winningTeam} has won!"
end
