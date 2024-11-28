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
    
    let dbManager = MongoTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 8
        let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
        
        // connect to db
        // I did the same things as register, removed your connect functions and replaced it with this.
        Task{
            do{
                database = try await dbManager.connect(uri: uri)
            }
            catch {
                print(error)
            }
        }
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            print("Please enter email and password.")
            return
        }
        
        authenticateUser(username: username, password: password)
    }
    
    func authenticateUser(username: String, password: String) {
        
        // i removed the previous code body of your authenticateUser function and replaced it with this one.
        Task {
            do{
                let loginResponse = try await dbManager.loginUser(username: username, password: password)
                
                if(loginResponse){
                    print("User is logged in!")
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
                            //                    Next 2 lines are from https://www.hackingwithswift.com/read/12/2/reading-and-writing-basics-userdefaults
                            let defaults = UserDefaults.standard
                            defaults.set(username, forKey: "username")
                            
                            if let userID = userDocument["_id"] as? ObjectId {
                                UserDefaults.standard.set(userID.hexString, forKey: "loggedInUserID")
                                // self.performSegue(withIdentifier: "showProfile", sender: self)
                            } else {
                                print("User ID not found in document.")
                            }
                        } else {
                            print("Incorrect email or password.")
                        }
                    }
                    catch {
                        print(error)
                    }
                }
            }
            
        }
    }
}
