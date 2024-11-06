//
//  MongoTest.swift
//  workkie
//
//  Created by Carl on 11/5/24.
//

import Foundation
import MongoCore
import MongoKitten

class MongoTest {
    private var database: MongoDatabase?
    
    // establish connection
    func connect(uri: String) async throws -> MongoDatabase {
        database = try await MongoDatabase.connect(to: uri)
        return database!
    }
    
    // create
    func insertUser(user: User) async -> Bool{
        guard let database = database else {
            print("Database is not connected.")
            return false
        }
        
        let collection = database["users"]
        let insUser: Document  = ["username": user.username, "password": user.password] // make document
        
        do{
            // TODO: add a error message when user tries to add duplicate username
            // current state: mongo does stop adding the user because of unique index, but on swift it shows ok
            print("inserting user: \(user.username) password: \(user.password)")
            try await collection.insert(insUser)
            print("insert user: \(user.username) ok")
            return true
        }
        catch{
            print("failed to insert: \(error)")
            return false
        }
    }
    
    // get all users
    func getUsers() async -> [User]? {
        guard let database = database else {
            print("Database is not connected.")
            return nil
        }
        
        let collection = database["users"]
        
        do {
            // get all user cursor
            let usersCursor = try await collection.find()
            
            var users: [User] = []
            let decoder = BSONDecoder()
            
            // go over every user
            for try await document in usersCursor {
                // Decode the document into a User instance
                if let user = try? decoder.decode(User.self, from: document) {
                    users.append(user)
                } else {
                    print("Failed to decode document: \(document)")
                }
            }
            
            // debug
//            print("Retrieved Users:")
//            for user in users {
//                print("Username: \(user.username), Password: \(user.password)")
//            }
            
            return users
        } catch {
            print("Failed to retrieve users: \(error)")
            return nil
        }
    }
    
    // delete user
    func deleteUser(userId: ObjectId) async throws -> Bool {
        guard let database = database else {
            print("Database is not connected.")
            return false
        }
        
        let collection = database["users"]
        
        do {
            let deleteResult = try await collection.deleteOne(where: "_id" == userId) // delete user on condition
            //TODO: if item doesn't exist it will still say ok, but has been removed already
            print("Delete user \(userId) ok")
            return true
        } catch {
            print("Delete user \(userId) fail")
            return false
        }
    }
    
    // login user
    func loginUser(username: String, password: String) async throws -> Bool {
        guard let database = database else {
            print("Database is not connected.")
            return false
        }
        
        let collection = database["users"]
        let filter: Document = ["username": username]
        
        do {
            if let userDoc = try await collection.findOne(filter) {
                let decoder = BSONDecoder()
                let gotUser = try decoder.decode(User.self, from: userDoc)
                
                // compare both passwords, not the hash ones right now because it is just testing
                if gotUser.password == password {
                    print("log in user \(username) ok")
                    return true
                }
                else{
                    print("log in user \(username) fail")
                    return false
                }
            }
            else{
                print("log in user \(username) not found ")
                return false
            }
        }
        catch {
            print("log in user \(username) fail, \(error)")
            return false
        }
    }
}

