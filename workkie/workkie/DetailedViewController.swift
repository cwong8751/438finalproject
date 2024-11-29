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
    
    let refreshControl = UIRefreshControl()
    
//    var theData: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return theData.count
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel!.text = theData[indexPath.row]
//        cell.textLabel!.text = comments[indexPath.row] as! String
        cell.textLabel!.text = comments?[indexPath.row] as? String ?? "Unknown Comment"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping

        return cell
    }
    
    let dbManager = MongoTest()
    
    var id: ObjectId!
    var author: String!
    var postTitle: String!
    var content: String!
    var date: String!
    var comments: [String]?

    @IBOutlet weak var authorvc: UILabel!
    
    @IBOutlet weak var titlevc: UILabel!
    
    @IBOutlet weak var datevc: UILabel!
    
    @IBOutlet weak var contentvc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isLoggedIn() {
        }
        else{
            // trigger login screen
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                present(loginVC, animated: true, completion: nil)
            }
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        authorvc?.text = author
        titlevc?.text = postTitle
        datevc?.text = date
        contentvc?.text = content
        contentvc?.textAlignment = .left
        contentvc?.numberOfLines = 0
        contentvc?.lineBreakMode = .byWordWrapping
        
        setupTableView()
        setupRefreshControl()
        fetchDataForTableView()
        updateButtonVisibility()
    }
    
    func isLoggedIn() -> Bool {
        
        if let user = UserDefaults.standard.string(forKey: "loggedInUserID"),
           !user.isEmpty,
           let username = UserDefaults.standard.string(forKey: "loggedInUsername"),
           !username.isEmpty {
            
            return true
        }
        return false
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        fetchDataForTableView()
    }
    
    func fetchDataForTableView() {
//        let theData = comments
//        tableView.reloadData()
        Task {
            do {
                // Simulated fetch (Replace this with your actual MongoDB query)
                let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
                try await dbManager.connect(uri: uri)

                if let fetchedComments = try await dbManager.getAllComments(forPostId: id) {
                    comments = fetchedComments
                }
                
                tableView.reloadData()
                refreshControl.endRefreshing() // Stop refresh animation
            } catch {
                print("Failed to fetch comments: \(error)")
                refreshControl.endRefreshing() // Stop refresh even on failure
            }
        }
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
    @IBOutlet weak var deleteButton: UIButton!
    
    func updateButtonVisibility() {
        deleteButton.isHidden = true
        if isLoggedIn() {
            let defaults = UserDefaults.standard
            let currentUser = defaults.object(forKey: "loggedInUsername") as! String
            if currentUser == author {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
            }
        }
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        let currentUser = defaults.object(forKey: "loggedInUsername") as! String
        if currentUser == author {
            
            Task {
                do {
                    let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
                    try await dbManager.connect(uri: uri)

                    if try await dbManager.deletePost(postId: id) {
                        print("Post deleted successfully!")
                    } else {
                        print("Failed to delete post.")
                    }
                    
                } catch {
                    print("Failed to delete post: \(error)")
                }
            }
        }
    }
}
