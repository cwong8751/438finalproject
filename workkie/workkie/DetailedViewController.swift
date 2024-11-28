//
//  DetailedViewController.swift
//  workkie
//
//  Created by Sang Won Bae on 11/10/24.
//

import UIKit
import MongoKitten
import MongoCore
import BSON

class DetailedViewController: UIViewController {
    
    var id: ObjectId!
    var author: String!
    var postTitle: String!
    var content: String!
    var date: String!

    @IBOutlet weak var authorvc: UILabel!
    
    @IBOutlet weak var titlevc: UILabel!
    
    @IBOutlet weak var datevc: UILabel!
    
    @IBOutlet weak var contentvc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        authorvc?.text = author
        titlevc?.text = postTitle
        datevc?.text = date
        contentvc?.text = content
        
    }

}
