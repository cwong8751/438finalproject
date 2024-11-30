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
    @IBOutlet weak var degreeTextField: UITextField!
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var jumpToLoginButton: UIButton!
    
    // defined database manager
    let dbManager = MongoTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 8
        let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
        
        // connect to database
        Task{
            do{
                database = try await dbManager.connect(uri: uri)
            }
            catch {
                print("Failed to connect to MongoDB: \(error)")
            }
        }
    }
    
    
    @IBAction func jumpToLoginButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let degree = degreeTextField.text, !degree.isEmpty,
              let education = educationTextField.text, !education.isEmpty else {
            let alertController = UIAlertController(title: "Missing Information", message: "Please fill in all fields", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        registerUser(email: email, username: username, password: password, education: education, degree: degree)
    }
    
    func registerUser(email: String, username: String, password: String, education: String, degree: String) {
        
        Task {
            do{
                
                // i kept your checking for duplicate users
                guard let database = self.database else {
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
                
                // insert new user
                let newUser = User(username: username, password: password, avatar: nil, email: email, latitude: nil, longitude: nil, education: education, degree: degree, connections: [], connectionRequests: [])
                try await dbManager.insertUser(user: newUser)
                
                
                // after user registered show success alert
                let alert = UIAlertController(title: "Registration Successful", message: "You have registered!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.dismiss(animated: true, completion: nil)}))
                self.present(alert, animated: true)
            }
            catch{
                print(error)
            }
        }
    }
    
}
