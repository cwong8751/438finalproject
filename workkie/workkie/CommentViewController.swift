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
    weak var delegate: CommentViewControllerDelegate?
    
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
            let author = defaults.object(forKey: "loggedInUsername") as! String
            let comment = commentText.text
            
            do {
                
                let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users&readPreference=primary&readConcernLevel=majority"
                try await dbManager.connect(uri: uri)
                
                
                if try await dbManager.insertComment(postId: postId, author: author, content: comment ?? "N/A") {
                    print("comment added successfully!")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            self.delegate?.commentAdded(commentString: author + ": " + (comment ?? ""))
                        }
                    }
                } else {
                    print("Failed to add comment.")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Failed to add comment", message: "Something went wrong, please try again", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            } catch {
                print("Error: \(error)")
            }
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
    
    protocol CommentViewControllerDelegate: AnyObject {
        func commentAdded(commentString: String)
    }
}


