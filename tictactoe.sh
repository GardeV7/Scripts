#!/bin/bash
IFS=''
RE='^[0-9]+$'

BOARD=(" " " " " " " " " " " " " " " " " ")
SYMBOLS=("X" "O")

# 0 - vs player, 1 - vs ai
MODE="1"
TURN=$(($RANDOM % 2))
NUMBEROFTURNS="0"
END="0"

function menu {
   GAMEREADY="0"
   while [ $GAMEREADY -eq "0" ]
   do
      if [[ -e "./save.txt" ]];
      then
         echo "Save file found. Press 0 if you want to start new game. Press 1 to load saved game."
      else
         echo "Save file not found. Press 0 to start new game."
      fi


      read INPUT
      if [[ $INPUT -eq "0" ]];
      then
         echo "Press 0 if you want to play against other player. Press other key if you want to play against AI."
         read INPUT
         if [[ $INPUT -eq "0" ]];
         then
            MODE="0"
         else
            MODE="1"
         fi
         GAMEREADY="1"
      elif [[ $INPUT -eq "1" && -e "./save.txt" ]]
      then
         load_game
         GAMEREADY="1"
      else
         echo "Wrong button pressed. Please try again."
      fi
   done

   echo "Game is starting soon. You are player 1."
   echo "To select square insert number from 0 to 8."
   echo "To save game type SAVE instead."
   sleep 3
}

function save_game {
   printf "${BOARD[*]}\n" > save.txt
   printf "$MODE\n" >> save.txt
   printf "$TURN\n" >> save.txt
   printf "$NUMBEROFTURNS\n" >> save.txt
}

function load_game {
   I=0
   while read line; 
   do   
      # load board
      if [[ $I -eq "0" ]];
      then
         for INDEX in {0..9}
         do
            BOARD[$INDEX]=${line:$INDEX:1}
         done
      # load mode
      elif [[ $I -eq "1" ]];
      then
         MODE=${line}
      # load turn
      elif [[ $I -eq "2" ]];
      then
         TURN=${line}
      #load number of turns
      elif [[ $I -eq "3" ]]
      then
         NUMBEROFTURNS=${line}
      fi 
   I=$((I + 1)) 
   done < save.txt
}

function is_number() {
   if [[ $1 =~ $RE ]]
   then
      echo "1"
   else
      echo "0"
   fi
}

function show_board {
	echo " ${BOARD[0]} | ${BOARD[1]} | ${BOARD[2]}"
	echo "---+---+---"
	echo " ${BOARD[3]} | ${BOARD[4]} | ${BOARD[5]}"
	echo "---+---+---"
	echo " ${BOARD[6]} | ${BOARD[7]} | ${BOARD[8]}"	
}

function next_turn {
   NUMBEROFTURNS=$((NUMBEROFTURNS + 1)) 

   if [[ $NUMBEROFTURNS -eq "9" && $END -eq "0" ]];
   then
      END="1"
      echo "Game ended in a draw"
   else
      if [[ $TURN -eq "0" ]];
      then 
         TURN="1"
      else
         TURN="0"
      fi
   fi
}

function check_win {
   if [[ ${BOARD[0]} == ${SYMBOLS[$TURN]} && ${BOARD[1]} == ${SYMBOLS[$TURN]} && ${BOARD[2]} == ${SYMBOLS[$TURN]} || 
	 ${BOARD[3]} == ${SYMBOLS[$TURN]} && ${BOARD[4]} == ${SYMBOLS[$TURN]} && ${BOARD[5]} == ${SYMBOLS[$TURN]} ||
         ${BOARD[6]} == ${SYMBOLS[$TURN]} && ${BOARD[7]} == ${SYMBOLS[$TURN]} && ${BOARD[8]} == ${SYMBOLS[$TURN]} ||   
         ${BOARD[0]} == ${SYMBOLS[$TURN]} && ${BOARD[3]} == ${SYMBOLS[$TURN]} && ${BOARD[6]} == ${SYMBOLS[$TURN]} || 
         ${BOARD[1]} == ${SYMBOLS[$TURN]} && ${BOARD[4]} == ${SYMBOLS[$TURN]} && ${BOARD[7]} == ${SYMBOLS[$TURN]} || 
	 ${BOARD[2]} == ${SYMBOLS[$TURN]} && ${BOARD[5]} == ${SYMBOLS[$TURN]} && ${BOARD[8]} == ${SYMBOLS[$TURN]} ||
         ${BOARD[0]} == ${SYMBOLS[$TURN]} && ${BOARD[4]} == ${SYMBOLS[$TURN]} && ${BOARD[8]} == ${SYMBOLS[$TURN]} ||   
         ${BOARD[2]} == ${SYMBOLS[$TURN]} && ${BOARD[4]} == ${SYMBOLS[$TURN]} && ${BOARD[6]} == ${SYMBOLS[$TURN]} ]];
   then
      END="1"
      echo "Player $(($TURN + 1)) (${SYMBOLS[$TURN]}) wins!"
   fi 
}

function read_input {
   read INPUT

   ISNUMBER=$(is_number $INPUT) 

   if [[ $ISNUMBER -eq "1" && $INPUT -ge "0" && $INPUT -le "8" && ${BOARD[$INPUT]} == " " ]];
   then
      BOARD[$INPUT]=${SYMBOLS[$TURN]}
      check_win
      next_turn
   else
      if [[ $INPUT == "SAVE" ]];
      then
         save_game
      else
         echo "Bad square selected, please try again"
      fi
   fi	
}

function generate_input {
   sleep 1   

   GOODPOSITION="0"

   while [ $GOODPOSITION -eq "0" ]
   do
      NUMBER=$(($RANDOM % 9))
      if [[ ${BOARD[$NUMBER]} == " " ]];
      then
	 BOARD[$NUMBER]=${SYMBOLS[$TURN]}
         GOODPOSITION="1"
      fi
   done
   check_win
   next_turn
}


######################################

menu
show_board
while [ $END -eq "0" ]
do
   echo "Player $(($TURN + 1)) (${SYMBOLS[$TURN]}) turn."
   if [[ $MODE -eq "1" && $TURN -eq "1" ]];
   then
      generate_input
   else
      read_input   
   fi
   show_board
done

