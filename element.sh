#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
  # if input is numeric look for atomic_number
  if [[ $1 =~ [0-9]+ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  # if input is string look for symbol or name
  elif [[ $1 =~ [a-zA-Z]+ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi

  # if nothing found echo a mmesage for user
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  # if element is found get joined data for element properties
  else
    PROPERTIES=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM properties AS p JOIN elements AS e USING(atomic_number) JOIN types AS t USING(type_id) WHERE atomic_number=$ELEMENT")
    
    echo $PROPERTIES | while read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELTINGT BAR BOILINGT
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTINGT celsius and a boiling point of $BOILINGT celsius."
    done

  fi

else
  echo "Please provide an element as an argument."
fi

