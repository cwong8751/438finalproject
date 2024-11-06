//
//  ViewController.swift
//  workkie
//
//  Created by Carl on 11/3/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // test mongo
        
        let dbManager = MongoTest()
        
        Task {
            do {
                // Connect to MongoDB
                try await dbManager.connect(uri: "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/Users?authSource=admin&appName=Users")
                
                // test insert a user
                let testUser = User(username: "test1", password: "testpass")
                await dbManager.insertUser(user: testUser)
            }
            catch {
                print("An error occurred: \(error)")
            }
        }
    }


}

