# **International Music Festival of Pulse University Database**

A comprehensive database system for managing Pulse University's annual international music festival.

## **Table of Contents**
- Features
- Database Schema
- Installation
- Usage
- Contributing
- License
## **Directory Features**
 - Database Managememnt:
        MariaDB-powered: Scalable and robust storage for contest data.
        Automated workflows: Triggers and stored procedures for seamless operations.

 - Data Generation: 
        *Dummy Data was generated with the help of LLMs*
 
  Core Modules:
        Events: Track the Stages, Performances, Bands and Staff of the Event
        Visitors: Store visitors profiles
        Artists: Store artist profiles
        Staff and Equipment Managment: Store required staff and equipment info 
        Rating Systems: Automate score calculations and leaderboard
        Reselling ticket application: Automate the reselling of tickets for the event

 (Write something about the project)

## **Database Scema**
### Entity Related Diagram

 (Add ER Diagram Here)

### Relational Schema

 (Add Relational Diagram Here)
 (Add a link to PNG directory)

## **Installation**  
Steps to install the project:  
1. Clone the repo:  
    git clone https://github.com/VasilisIoannou/DatabaseNTUA
    cd DatabaseNTUA

2. Set up MariaDB
    mysql -u root -p < Database.sql

3. Generate dummy data:
    mysql -u root -p festivalDB < InsertsTsakalos.sql

## **Usage Examples**

### Query Artist By Age:
    
    SELECT * FROM artist WHERE artist_age < 35;

### Add a New festival:
    
    INSERT INTO festival (festival_year, festival_month, festival_day, duration, location_id) VALUES (2030, 10, 20, 5, 10);

        
    The above will create an instance of the festival starting 20/10/2030 (DD/MM/YYYY) until 25/10/2030
    Note: For the Instance of the Festival to be created the instance of location/coordinates must already exist

## **Acknowledgements** 
Participants: 
        Vasilis Ioannou, 
        Dimitris Markidis,
        Theodoros Tsakalos,
