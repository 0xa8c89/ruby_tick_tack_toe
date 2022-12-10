class Player
  attr_reader :name, :symbol

  @@players = []

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @@players << self
  end

  def self.players
    @@players
  end
end

class Board
  WINNING_COMBOS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],
    [0, 3, 6], [1, 4, 7], [2, 5, 8],
    [0, 4, 8], [2, 4, 6]
  ].freeze

  def initialize
    @@cells = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  end

  def draw
    puts
    puts "\t#{@@cells[0]} | #{@@cells[1]} | #{@@cells[2]}"
    puts "\t--+---+--"
    puts "\t#{@@cells[3]} | #{@@cells[4]} | #{@@cells[5]}"
    puts "\t--+---+--"
    puts "\t#{@@cells[6]} | #{@@cells[7]} | #{@@cells[8]}"
    puts
  end

  def valid?(num)
    @@cells[num - 1] == num
  end

  def pick(num, symbol)
    until valid?(num)
      puts 'Place already taken. Try another cell.'
      num = gets.chomp.to_i
    end
    @@cells[num - 1] = symbol
  end

  def win?(symbol)
    WINNING_COMBOS.each do |combo|
      count = 0
      combo.each do |i|
        count += 1 if @@cells[i] == symbol
        return true if count == 3
      end
    end
  end

  def all_picked?
    count = 0
    9.times do |i|
      count += 1 if @@cells[i] == i + 1
      return true if i == 8 && count.zero?
    end
  end
end

def init_players
  2.times do |i|
    puts "Enter a name for a player ##{i + 1}"
    name = gets.chomp
    puts "Enter a symbol for a player ##{i + 1} (non-numeral)"
    symbol = gets.chomp
    Player.new(name, symbol)
  end
end

def play
  board = Board.new

  go_on = true

  while go_on
    Player.players.each do |player|
      break if go_on == false

      board.draw
      puts "#{player.name}, enter a cell you want to mark: "
      cell = gets.chomp.to_i
      board.pick(cell, player.symbol)
      if board.win?(player.symbol) == true
        board.draw
        puts "#{player.name} won!"
        go_on = false
      end
      if board.all_picked? == true
        board.draw
        puts 'Draw'
        go_on = false
      end
    end
  end
end

init_players
further_play = true

while further_play
  play
  puts 'Do you want to play again?'
  further_play = false unless gets.chomp.downcase == 'y'
end
