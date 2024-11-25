//
//  LoginViewController.swift
//  workkie
//
//  Created by Cheng Li on 11/9/24.
//

import Foundation
import UIKit
import MongoKitten

class LoginViewController: UIViewController {
    private var database: MongoDatabase?
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 8
        let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
        
        connectToDatabase(uri: uri)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            print("Please enter email and password.")
            return
        }
        
        authenticateUser(username: username, password: password)
    }
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
    func authenticateUser(username: String, password: String) {
        Task {
            // Ensure the database is connected
            guard let database = database else {
                print("Database is not connected.")
                return
            }
            
            let collection = database["users"]
            
            let filter: Document = ["username": username, "password": password]
            
            do {
                if let userDocument = try await collection.findOne(filter) {
                    print("User logged in successfully.")
                    
                    if let userID = userDocument["_id"] as? ObjectId {
                        UserDefaults.standard.set(userID.hexString, forKey: "loggedInUserID")
                        UserDefaults.standard.set(username, forKey: "loggedInUsername")
                        // self.performSegue(withIdentifier: "showProfile", sender: self)
                    } else {
                        print("User ID not found in document.")
                    }
                } else {
                    print("Incorrect email or password.")
                }
            } catch {
                print("Authentication failed: \(error)")
            }
        }
    }

}
