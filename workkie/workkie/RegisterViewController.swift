//
//  Register.swift
//  workkie
//
//  Created by Cheng Li on 11/9/24.
//

import Foundation
import UIKit
import MongoKitten

class RegisterViewController: UIViewController {
    private var database: MongoDatabase?
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let dbManager = MongoTest()
    
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
        registerButton.layer.cornerRadius = 8
        let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
        
        connectToDatabase(uri: uri)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, let username = usernameTextField.text, let password = passwordTextField.text else {
            print("Please fill in all fields.")
            return
        }
        
        registerUser(email: email, username: username, password: password)
    }
    
    func registerUser(email: String, username: String, password: String) {
        Task {
            do {
                guard let database = database else {
                    print("Database is not connected.")
                    return
                }
                
                let collection = database["users"]
                
                // Check if a user with the same email already exists
                let existingUser = try await collection.findOne(["email": email])
                if existingUser != nil {
                    print("Email is already registered.")
                    return
                }
                
                let newUser = User(username: username, password: password)
                
                try await dbManager.connect(uri: "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users")
                try await dbManager.insertUser(user: newUser)
                print("User registered successfully.")
                
                // e.g., self.performSegue(withIdentifier: "showLogin", sender: self)
            } catch {
                print("Registration failed: \(error)")
            }
        }
    }

}
