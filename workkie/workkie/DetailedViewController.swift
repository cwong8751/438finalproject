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

class DetailedViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var theData: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    let dbManager = MongoTest()
    
    var id: ObjectId!
    var author: String!
    var postTitle: String!
    var content: String!
    var date: String!
    var comments: [String] = []

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
        
        setupTableView()
        fetchDataForTableView()
        
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetchDataForTableView() {
        let theData = comments
    }
    
    @IBAction func commentPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let commentview = storyboard.instantiateViewController(withIdentifier: "commentVC")
//        self.present(commentview, animated: true, completion: nil)
//        commentview.postId = id
        
        if let commentView = storyboard.instantiateViewController(withIdentifier: "commentVC") as? CommentViewController {
            commentView.postId = id
            self.present(commentView, animated: true, completion: nil)
        } else {
            print("Failed to cast to CommentViewController")
        }
    }
    
}
