//
//  SecondViewController.swift
//  workkie
//
//  Created by Sang Won Bae on 11/26/24.
//

import UIKit
import BSON
import Foundation
import MongoKitten
import MongoCore

class SecondViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var titleOpening: UITextField!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var contentOpening: UITextView!
    
    let dbManager = MongoTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CITATION: https://stackoverflow.com/questions/2647164/bordered-uitextview
        self.contentOpening.layer.cornerRadius = 4
        self.contentOpening.layer.borderColor = UIColor.lightGray.cgColor
        self.contentOpening.layer.borderWidth = 1.0
        // END CITATION
    }
    
    func isLoggedIn() -> Bool {
        
        if let user = UserDefaults.standard.string(forKey: "loggedInUserID"),
           !user.isEmpty,
           let username = UserDefaults.standard.string(forKey: "loggedInUsername"),
           !username.isEmpty {
            
            return true
        }
        dismiss(animated: true, completion: nil)
        return false
        if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
            present(loginVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func postButton(_ sender: Any) {
        
        Task {
            // Collect data from UI
            let defaults = UserDefaults.standard
            if isLoggedIn() {
                
            } else {
                
                return
            }
            let author = defaults.object(forKey: "loggedInUsername") as! String
            guard let title = titleOpening.text,
            let content = contentOpening.text else {
            print("Incomplete form")
            return
            }
            
            let newPost = Post(author: author, content: content, date: Date(), title: title, comments: [])
            
            do {
                // Ensure the connection
                let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
                try await dbManager.connect(uri: uri)
                
                // Insert the new post
                if try await dbManager.insertPost(post: newPost) {
                    print("Post added successfully!")
                } else {
                    print("Failed to add post.")
                }
            } catch {
                print("Error: \(error)")
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
