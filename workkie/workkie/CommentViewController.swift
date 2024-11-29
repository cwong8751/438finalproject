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
    }
    
    @IBOutlet weak var commentText: UITextField!
    
    let dbManager = MongoTest()
    
    @IBAction func postComment(_ sender: Any) {
        
        Task {
            
            let defaults = UserDefaults.standard
            let author = defaults.object(forKey: "username") as! String
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
    

}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
