# International Music Festival of Pulse University Database

## Description  
A brief description of your project, what problem it solves, and its main features.

## Table of Contents  

## Directory Features
 - Database Managememnt:
        MariaDB-powered: Scalable and robust storage for contest data.
        Automated workflows: Triggers and stored procedures for seamless operations.

 - Data Generation: 
        Dummy Data was generated with the help of LLMs
 
  Core Modules:
        Events: Track the Stages, Performances, Bands and Staff of the Event
        Visitors: Store visitors profiles
        Artists: Store artist profiles
        Staff and Equipment Managment: Store required staff and equipment info 
        Rating Systems: Automate score calculations and leaderboard
        Reselling ticket application: Automate the reselling of tickets for the event

 (Write something about the project)

## Database Features

 (Write here a list of things the Database stores )

## Database Scema
### Entity Related Diagram

 (Add ER Diagram Here)

### Relational Schema

 (Add Relational Diagram Here)
 (Add a link to PNG directory)

## Installation  
Steps to install the project:  
1. Clone the repo:  
    git clone https://github.com/VasilisIoannou/DatabaseNTUA
    cd DatabaseNTUA

2. Set up MariaDB
    mysql -u root -p < Database.sql

3. Generate dummy data:
    mysql -u root -p festivalDB < InsertsTsakalos.sql

## Acknowledgements 
    Participants: 
        Vasilis Ioannou 
        Dimitris Markidis
        Theodoros Tsakalos
