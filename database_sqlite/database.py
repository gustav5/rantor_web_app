import sqlite3
import json
#import database_file
#import database. name of database is current time
#database_name = database_file.new_database_name

#for testing we are using this databasename:
global database_name 
database_name = "database1.db"

def create_database():
    #database name is time when created.
    con = sqlite3.connect(database_name)
    cur=con.cursor()

    cur.execute("CREATE TABLE IF NOT EXISTS rantor (id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, mongo_id TEXT, name TEXT, date TEXT, ranta DECIMAL(3,3))")
    con.commit()
    con.close()

def insert_into_rantor(mongo_id,name, date, ranta):
    con = sqlite3.connect(database_name)
    cur = con.cursor()
    cur.execute("INSERT INTO rantor VALUES (NULL,?,?,?,?)",(mongo_id, name, date, ranta))
    con.commit()
    con.close()

if __name__ == "__main__":
    create_database()

    with open("../scrape/sql_data/latest", "r") as f:
        filename = f.read()

    with open("../scrape/sql_data/" + filename, "r") as f:
        file_contents = f.read()

    data = json.loads(file_contents)

    create_database()
    
    for x in data:
        insert_into_rantor(x["id"],x["name"], x["date"], x["ranta"])
