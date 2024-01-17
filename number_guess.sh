#!/bin/bash

PSQL="psql -U freecodecamp -d number_guess -t -A -c"

echo -e "\nEnter your username:"
read USERNAME

CHECK_USERNAME=$($PSQL "SELECT guesses FROM games WHERE username='$USERNAME'")

if [[ -z $CHECK_USERNAME ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE username = '$USERNAME'")
  MIN_GUESSES=$($PSQL "SELECT MIN(guesses) FROM games")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $MIN_GUESSES guesses."
fi

RANDOM_NUMBER=$(($RANDOM%1000 + 1))

CHECK_INPUT() {
  
  read NUMBER_GUESSED

  while [[ ! $NUMBER_GUESSED =~ ^[0-9]+$ ]]
   do
      echo "That is not an integer, guess again:"
      read NUMBER_GUESSED
  done  

}


GUESSES=1
echo "Guess the secret number between 1 and 1000:"
CHECK_INPUT


  while [[ $NUMBER_GUESSED -ne $RANDOM_NUMBER ]]
  do
    if [[ $NUMBER_GUESSED -le $RANDOM_NUMBER ]]
    then
      echo "It's higher than that, guess again:"
      CHECK_INPUT
      GUESSES=$((GUESSES + 1)) 
    elif [[ $NUMBER_GUESSED -ge $RANDOM_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
      CHECK_INPUT
      GUESSES=$((GUESSES + 1))    
    fi   
  done

  
  INSERT_RESULT=$($PSQL "INSERT INTO games(username, guesses) VALUES('$USERNAME',$GUESSES)")

  echo "You guessed it in $GUESSES tries. The secret number was $RANDOM_NUMBER. Nice job!"