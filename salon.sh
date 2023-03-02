#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

# Connect to the database and create customers, appointments and services tables
echo -e "Welcome to My Salon, how can I help you?\n"

AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services;")
echo "$AVAILABLE_SERVICES" | while IFS="|" read SERVICE NAME
do
  echo "$SERVICE) $NAME"
done

# Enter service id
read SERVICE_ID_SELECTED
AVAILABILITY=$($PSQL "SELECT name from services WHERE service_id = '$SERVICE_ID_SELECTED'")
# check if service id is number and corresponds to service we offer

  # if [[ -z $AVAILABILITY && $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  # then
while [[ -z $AVAILABILITY && $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
do
echo -e "\nI could not find that service. What would you like today?"
echo "$AVAILABLE_SERVICES" | while IFS="|" read SERVICE NAME
do
    echo "$SERVICE) $NAME"
done
read SERVICE_ID_SELECTED
AVAILABILITY=$($PSQL "SELECT name from services WHERE service_id = '$SERVICE_ID_SELECTED'")
done

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

PHONE=$($PSQL "SELECT name from customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $PHONE ]]
then
echo -e "\nI don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME

INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
else
CUSTOMER_NAME=$($PSQL "SELECT name from customers WHERE phone = '$CUSTOMER_PHONE'")
fi

echo -e "\nWhat time would you like your $AVAILABILITY, $CUSTOMER_NAME?"
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")

# Insert data into the appointments table
INSERT_APP=$($PSQL "INSERT INTO appointments (time, customer_id, service_id) VALUES('$SERVICE_TIME', '$CUSTOMER_ID', '$SERVICE_ID_SELECTED')")

echo -e "\nI have put you down for a $AVAILABILITY at $SERVICE_TIME, $CUSTOMER_NAME.\n" 
