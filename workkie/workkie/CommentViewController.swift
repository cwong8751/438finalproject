//
//  CommentViewController.swift
//  workkie
//
//  Created by Sang Won Bae on 11/28/24.
//

import UIKit
import MongoKitten
import MongoCore
import BSON

class CommentViewController: UIViewController {
    
    var postId: ObjectId!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentText.layer.borderColor = UIColor.lightGray.cgColor
        commentText.layer.borderWidth = 1.0
        commentText.layer.cornerRadius = 4
    }
    
    @IBOutlet weak var commentText: UITextView!
    
    let dbManager = MongoTest()
    
    @IBAction func postComment(_ sender: Any) {
        
        Task {
            
            let defaults = UserDefaults.standard
            if isLoggedIn() {
                
            } else {
                return
                dismiss(animated: true, completion: nil)
            }
            let author = defaults.object(forKey: "loggedInUsername") as! String
            let comment = commentText.text
            
            
            do {
                // Ensure the connection
                let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
                try await dbManager.connect(uri: uri)
                
                // Insert the new post
                if try await dbManager.insertComment(postId: postId, author: author, content: comment ?? "N/A") {
                    print("Post added successfully!")
                } else {
                    print("Failed to add post.")
                }
            } catch {
                print("Error: \(error)")
            }

            dismiss(animated: true, completion: nil)
            
        }
        
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
    }
    

}
