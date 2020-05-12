//
//  GlobalFunctions.swift
//  FavouriteActors
//
//  Created by Sujata on 12/05/20.
//  Copyright © 2020 Sujata. All rights reserved.
//

import UIKit
import SQLite3

var urlMainString = "https://reqres.in/api/users?page=1"

var activityIndicator = UIActivityIndicatorView()

var db: OpaquePointer? //For SQLite

var arrData = [actorData]()
var arrFavActor = [actorData]()

/* Below: function to start Activity Indicator */
func startActivityIndicator(vc: UIViewController) {
    activityIndicator.center = vc.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.gray
    vc.view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
}

/* Below: function to stop Activity Indicator */
func stopActivityIndicator(vc: UIViewController) {
    activityIndicator.stopAnimating()
    UIApplication.shared.endIgnoringInteractionEvents()
}


func displayAlert(vc: UIViewController, title: String, message: String) {
    let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler:nil ))
    vc.present(alert, animated: true)
}

//Create Database
func openDatabase(){
    do {
        //the database file
        let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ActorsDatabase.sqlite")
        
        //opening the database
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database")
            createTable()
        }
        else {
            print("Unable to open database.")
        }
    }
    catch {
        print(error)
    }
}

//Create Table
func createTable() {
    let createTableString = """
                CREATE TABLE IF NOT EXISTS FavouriteActors(
                Id INTEGER PRIMARY KEY NOT NULL,
                FirstName TEXT,
                SecondName TEXT,
                Email TEXT,
                ImageURL TEXT);
                """
    
    if sqlite3_exec(db, createTableString, nil, nil, nil) != SQLITE_OK {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error creating table: \(errmsg)")
    }
}

//Insert Data
func insertData(id:Int, firstName:String, secondName:String, email:String, imageurl:String) {
    //creating a statement
    var insertStatement: OpaquePointer?
    
    //the insert query
    let queryString = "INSERT INTO FavouriteActors(Id, FirstName, SecondName, Email, ImageURL) VALUES (?,?,?,?,?)"
    
    //preparing the query
    if sqlite3_prepare(db, queryString, -1, &insertStatement, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error preparing insert: \(errmsg)")
        return
    }
    
    //binding the parameters
    
    if sqlite3_bind_int(insertStatement, 1, Int32(id)) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure binding id: \(errmsg)")
        return
    }
    
    if sqlite3_bind_text(insertStatement, 2, firstName, -1, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure binding name: \(errmsg)")
        return
    }
    
    if sqlite3_bind_text(insertStatement, 3, secondName, -1, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure binding name: \(errmsg)")
        return
    }
    
    if sqlite3_bind_text(insertStatement, 4, email, -1, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure binding email: \(errmsg)")
        return
    }
    
    if sqlite3_bind_text(insertStatement, 5, imageurl, -1, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure binding imageurl: \(errmsg)")
        return
    }
    
    //executing the query to insert values
    if sqlite3_step(insertStatement) != SQLITE_DONE {
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("failure saving Actor: \(errmsg)")
        return
    }
    
    //readValues()
    
    //displaying a success message
    print("Favourite Actor saved successfully")
}




func deleteData(id:Int) {
    let deleteStatementString = "DELETE FROM FavouriteActors WHERE Id = \(id);"
    var deleteStatement: OpaquePointer?
    if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) ==
        SQLITE_OK {
        if sqlite3_step(deleteStatement) == SQLITE_DONE {
            print("\nSuccessfully deleted row.")
        } else {
            print("\nCould not delete row.")
        }
    } else {
        print("\nDELETE statement could not be prepared")
    }
    
    sqlite3_finalize(deleteStatement)
    
    //readValues()
    
    //displaying a success message
    print("Favourite Actor deleted successfully")
}

func readValues(){
    
    //first empty the list of heroes
    arrFavActor.removeAll()
    
    //this is our select query
    let queryString = "SELECT * FROM FavouriteActors"
    
    //statement pointer
    var stmt:OpaquePointer?
    
    //preparing the query
    if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
        let errmsg = String(cString: sqlite3_errmsg(db)!)
        print("error preparing insert: \(errmsg)")
        return
    }
    
    //traversing through all the records
    while(sqlite3_step(stmt) == SQLITE_ROW){
        let id = sqlite3_column_int(stmt, 0)
        let firstName = String(cString: sqlite3_column_text(stmt, 1))
        let secondName = String(cString: sqlite3_column_text(stmt, 2))
        let email = String(cString: sqlite3_column_text(stmt, 3))
        let imageurl = String(cString: sqlite3_column_text(stmt, 4))
        
        //adding values to list
        arrFavActor.append(actorData( id: Int(id), email: String(describing: email), first_name: String(describing: firstName), last_name: String(describing: secondName), avatar: String(describing: imageurl), isFav:true))
        
    }
    
}

