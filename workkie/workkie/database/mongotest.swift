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
        print("database is connected")
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
    
    // function to get all posts
    func getAllPosts() async throws -> [Post]? {
        guard let database = database else {
            print("Database is not connected.")
            return nil
        }
        
        let collection = database["posts"]
        
        do {
            // get all post cursor
            let postsCursor = try await collection.find()
            
            var posts: [Post] = []
            let decoder = BSONDecoder()
            
            // go over every post
            for try await document in postsCursor {
                // decode to post interface
                if let post = try? decoder.decode(Post.self, from: document) {
                    posts.append(post)
                } else {
                    print("Failed to decode document: \(document)")
                }
            }
            
            // debug
            print("Retrieved Posts:")
            for post in posts {
                print("Post _id: \(post._id) Post author: \(post.author) Post title: \(post.title) Post content: \(post.content) Post date: \(post.date)")
            }
            
            return posts
        } catch {
            print("Failed to retrieve posts: \(error)")
            return nil
        }
    }
    
    // function to get specific post
    func getPost(id: ObjectId) async throws -> Post? {
        guard let database = database else {
            print("Database is not connected.")
            return nil
        }
        
        print("id need to find: \(id)")
        
        let collection = database["posts"]
        
        do {
            if let postDoc = try await collection.findOne(["_id": id]) {
                let decoder = BSONDecoder()
                let gotPost = try decoder.decode(Post.self, from: postDoc)
                
                // debug
                print("got post with id \(gotPost._id) title: \(gotPost.title) author: \(gotPost.author) content: \(gotPost.content) date: \(gotPost.date)")
                
                // return result
                return gotPost
            }
            else{
                print("post with id \(id) not found")
                return nil
            }
        }
        catch {
            print("find post with id \(id) failed. \(error)")
            return nil
        }
    }
    
    // function to insert post
    func insertPost(post: Post) async throws -> Bool {
        guard let database = database else {
            print("Database is not connected.")
            return false
        }
        
        let collection = database["posts"]
        let insPost: Document  = ["author": post.author, "content": post.content, "date": post.date, "title": post.title, "comments": post.comments] // make document of new post
        
        do{
            print("inserting post")
            try await collection.insert(insPost)
            print("insert post of author: \(post.author) title: \(post.title) ok")
            return true
        }
        catch{
            print("failed to insert post: \(error)")
            return false
        }
    }
    
    // function to delete post
    func deletePost(postId: ObjectId) async throws -> Bool {
        guard let database = database else {
            print("Database is not connected.")
            return false
        }
        
        let collection = database["posts"]
        
        do {
            let deleteResult = try await collection.deleteOne(where: "_id" == postId) // delete post on condition
            //TODO: if item doesn't exist it will still say ok, but has been removed already
            print("Delete post \(postId) ok")
            return true
        } catch {
            print("Delete post \(postId) fail")
            return false
        }
    }
    
    // function to edit post
    //TODO: 
}
