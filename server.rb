require "sinatra"
require 'pry'

set :bind, '0.0.0.0'  # bind to all interfaces

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

# create index page(GET)
# user submits rock,paper,or scissors to a form (POST)
# each round-- params[:players choice] << session
# =>  computer choice not in params << session
# keeps track of score using session
# winner of game has best of 3.. after user chooses to restart game
#create a reset route (GET) to clear the game and start over

def winner_of_3

  if session[:player_score] >= 3 || session[:computer_score] >= 3
    session.clear
  end
end

def game(computer, players_choice)
  if computer == "paper" && players_choice == "rock"
    session[:winner] = "computer"
    session[:computer_score] += 1

  elsif computer == "scissors" && players_choice == "paper"
    session[:winner] = "computer"
    session[:computer_score] += 1

  elsif computer == "rock" && players_choice == "scissors"
    session[:winner] = "computer"
    session[:computer_score] += 1

  elsif computer == "rock" && players_choice == "paper"
    session[:winner] = "player"
    session[:player_score] += 1

  elsif computer == "scissors" && players_choice == "rock"
    session[:winner] = "player"
    session[:player_score] += 1

  elsif computer == "paper" && players_choice == "scissors"
    session[:winner] = "player"
    session[:player_score] += 1

  elsif computer == "rock" && players_choice == "rock"
     session[:winner] = "It is a tie"

  elsif computer == "scissors" && players_choice == "scissors"
     session[:winner] = "It is a tie"

  elsif computer == "paper" && players_choice == "paper"
      session[:winner] = "It is a tie"
  end

end

get "/" do
  #redirect "/index"
  erb :index
end

 get "/index" do
   session[:computer_score] ||= 0
   session[:player_score] ||= 0
   @winner = session[:winner]
   @score = {player: session[:player_score], computer: session[:computer_score]}
  if session[:visit_count].nil?
     session[:visit_count] = 1
  else
    session[:visit_count] += 1
  end
  erb :index

end

post "/choice" do

  computer = ["rock", "paper", "scissors"][rand(3)]
  players_choice = params[:choice]
  session[:computer_score] ||= 0
  session[:player_score] ||= 0
  game(computer, players_choice)
  winner_of_3
  redirect '/index'

end
