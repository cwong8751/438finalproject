//
//  Profile.swift
//  workkie
//
//  Created by Cheng Li on 11/6/24.
//

//"mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"

import Foundation
import BSON
import MongoCore
import MongoKitten
import UIKit

class ProfileViewController: UIViewController {
    private var database: MongoDatabase?
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var education: UILabel!
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var educationButton: UIButton!
    @IBOutlet weak var degreeButton: UIButton!
    
    
    func connect(uri: String) async throws -> MongoDatabase {
        database = try await MongoDatabase.connect(to: uri)
        return database!
    }
    private func connectToDatabase(uri: String) {
        Task {
            do {
                // Connect using the existing connect function
                try await connect(uri: uri)
                print("Connected to MongoDB successfully.")
            } catch {
                print("Failed to connect to MongoDB: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
        
        connectToDatabase(uri: uri)
    }
    func getUsers() async -> [User]? {
        guard let database = database else {
            print("Database is not connected.")
            return nil
        }
        
        let collection = database["users"]
        
        do {
            let usersCursor = try await collection.find()
            
            var users: [User] = []
            let decoder = BSONDecoder()
            
            for try await document in usersCursor {
                // Decode the document into a User instance
                if let user = try? decoder.decode(User.self, from: document) {
                    users.append(user)
                } else {
                    print("Failed to decode document: \(document)")
                }
            }
            
            return users
        } catch {
            print("Failed to retrieve users: \(error)")
            return nil
        }
    }
    @IBAction func editUsername(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit Username", message: "Enter new username", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.username.text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let newUsername = alert.textFields?.first?.text {
                self?.username.text = newUsername
                self?.updateUserInfo(field: "username", value: newUsername)
            }
        }))
        present(alert, animated: true)
    }
    
    @IBAction func editEducation(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit Education", message: "Enter new education", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.education.text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let newEducation = alert.textFields?.first?.text {
                self?.education.text = newEducation
                self?.updateUserInfo(field: "education", value: newEducation)
            }
        }))
        present(alert, animated: true)
    }

    @IBAction func editDegree(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit Degree", message: "Enter new degree", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.degree.text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let newDegree = alert.textFields?.first?.text {
                self?.degree.text = newDegree
                self?.updateUserInfo(field: "degree", value: newDegree)
            }
        }))
        present(alert, animated: true)
    }

    
    func updateUserInfo(field: String, value: String) {
        guard let database = database, let userID = getUserID() else {
            print("Database not connected or user not logged in.")
            return
        }
        
        let collection = database["users"]
        guard let objectId = try? ObjectId(userID) else {
            print("Invalid user ID format.")
            return
        }
        
        let filter: Document = ["_id": objectId]
        let update: Document = ["$set": [field: value]]
        
        Task {
            do {
                try await collection.updateOne(where: filter, to: update)
                print("\(field) updated successfully in the database.")
            } catch {
                print("Failed to update \(field): \(error)")
            }
        }
    }

    func getUserID() -> String? {
        return UserDefaults.standard.string(forKey: "loggedInUserID")
    }
    
}

