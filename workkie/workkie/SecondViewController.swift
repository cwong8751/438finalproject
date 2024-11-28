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
    
    @IBOutlet weak var contentOpening: UITextField!
    
    let dbManager = MongoTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func postButton(_ sender: Any) {
        
        Task {
            // Collect data from UI
            let defaults = UserDefaults.standard
            let author = defaults.object(forKey: "username") as! String
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
