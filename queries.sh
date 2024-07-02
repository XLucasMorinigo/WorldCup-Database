#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
if [[ $YEAR != year ]]
then
WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
if [[ -z $WTEAM_ID ]]
then
INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
WTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi
OTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
if [[ -z $OTEAM_ID ]]
then
INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
OTEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi
GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR AND winner_id=$WTEAM_ID AND opponent_id=$OTEAM_ID")
if [[ -z $GAME_ID ]]
then
INSERT_YEAR_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WTEAM_ID,$OTEAM_ID,$WINNERGOALS,$OPPONENTGOALS)")
if [[ $INSERT_YEAR_RESULT == "INSERT 0 1" ]]
then
echo "Inserted into games, $YEAR,'$ROUND',$WTEAM_ID,$OTEAM_ID,$WINNERGOALS,$OPPONENTGOALS"
fi
fi
fi
done