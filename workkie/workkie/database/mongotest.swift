//
//  MongoTest.swift
//  workkie
//
//  Created by Carl on 11/5/24.
//

import Foundation
import MongoKitten

class MongoTest {
    private var database: MongoDatabase?

    // establish connection
    func connect(uri: String) async throws {
        database = try await MongoDatabase.connect(to: uri)
        //print("all collections: \(database.listCollections())")
        print("Connected to database: \(uri)")
        print("database: \(database)")
        let db = try await database?.listCollections()
        print("all collections: \(db)")
    }
    
    // create
    // accepts the collection to be inserted, and a codable item (users/posts)
    func insertUser(user: User) async {
        guard let database = database else {
            print("Database is not connected.")
            return
        }
        

        let collection = database["users"]
        let insUser: Document  = ["username": user.username, "password": user.password]
        
        do{
            // list all collections
            let allCollections = try await database.listCollections()
            print("all collections: \(allCollections)")
            
            print("inserting user: \(user.username) password: \(user.password)")
            try await collection.insert(insUser)
            print("insert user: \(user.username) ok")
        }
        catch{
            print("failed to insert: \(error)")
        }
    }
}
