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
    
    
    // defined database manager
    let dbManager = MongoTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 8
        let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
        
        // I removed the methods you defined to connect to the database and replaced it with these instead, so its easier to work with.
        
        // connect to database
        Task{
            do{
                database = try await dbManager.connect(uri: uri) // still kept your original structure
            }
            catch {
                print("Failed to connect to MongoDB: \(error)")
            }
        }
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
            do{
                
                // i kept your checking for duplicate users
                guard let database = database else {
                    print("Database is not connected.")
                    return
                }
                
                let collection = database["users"]
                
                // check user with same email already exists
                let existingUser = try await collection.findOne(["email": email])
                if existingUser != nil {
                    print("Email is already registered.")
                    return
                }
                
                // rewrote your original insert user function to use the User class and the method in MongoTest
                // insert new user
                let newUser = User(username: username, password: password, email: email)
                try await dbManager.insertUser(user: newUser)
                
            }
            catch{
                print(error)
            }
        }
    }

}
