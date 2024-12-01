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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
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
    
    @IBOutlet weak var contentvc: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        authorvc?.text = "By " + author
        titlevc?.text = postTitle
        datevc?.text = "Posted on " + date
        contentvc?.text = content
        //        contentvc?.textAlignment = .left
        //        contentvc?.numberOfLines = 0
        //        contentvc?.lineBreakMode = .byWordWrapping
        
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
                let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
                try await dbManager.connect(uri: uri)
                
                if let fetchedComments = try await dbManager.getAllComments(forPostId: id) {
                    //                    comments = fetchedComments
                    DispatchQueue.main.async {
                        self.comments = fetchedComments
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to fetch comments: \(error)")
                    self.refreshControl.endRefreshing()
                }
            }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func commentPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let commentView = storyboard.instantiateViewController(withIdentifier: "commentVC") as? CommentViewController {
            commentView.postId = id
            commentView.title = "New Comment"
        
            let navigationController = UINavigationController(rootViewController: commentView)
            self.present(navigationController, animated: true, completion: nil)
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
