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
    @IBOutlet weak var jumpToRegisterButton: UIButton!
    
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
    
    
    @IBAction func jumpToRegisterButtonTapped(_ sender: Any) {
        if let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") {
            present(registerVC, animated: true, completion: nil)
        }
    }
    
    func authenticateUser(username: String, password: String) {
        
        Task {
            do{
                let loginResponse = try await self.dbManager.loginUser(username: username, password: password)
                
                if(loginResponse){
                    print("User is logged in!")
                    dismiss(animated: true, completion: nil)
                }
                else{
                    print("User is not logged in")
                }
            }
            catch {
                print(error)
            }
        }
    }
    
}
