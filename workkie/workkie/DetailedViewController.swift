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

class DetailedViewController: UIViewController, UITableViewDataSource, CommentViewController.CommentViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updatePlaceholder()
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
        
        setupTableView()
        setupRefreshControl()
        fetchDataForTableView()
//        Next line is from ChatGPT
        updateButtonVisibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchDataForTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
//    Next 4 lines are from ChatGPT
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
//    Next 3 lines are from ChatGPT
    @objc func refreshData() {
        fetchDataForTableView()
    }
    
    func fetchDataForTableView() {
        Task {
            do {
                let uri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users&readPreference=primary&readConcernLevel=majority"

                try await dbManager.connect(uri: uri)
                if let fetchedComments = try await dbManager.getAllComments(postId: id) {
//                    Next 5 lines are from ChatGPT
                    DispatchQueue.main.async {
                        self.comments = fetchedComments
                        self.tableView.reloadData()
                        self.updatePlaceholder()
                        self.refreshControl.endRefreshing()
                    }
                }
            } catch {
//                Next 3 lines are from ChatGPT
                DispatchQueue.main.async {
                    print("Failed to fetch comments: \(error)")
                    self.refreshControl.endRefreshing()
                }
            }
//            Next 2 lines are from ChatGPT
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @IBAction func commentPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if isLoggedIn() {
            if let commentView = storyboard.instantiateViewController(withIdentifier: "commentVC") as? CommentViewController {
                commentView.postId = id
                commentView.title = "New Comment"
                commentView.delegate = self
                
                let navigationController = UINavigationController(rootViewController: commentView)
                self.present(navigationController, animated: true, completion: nil)
            } else {
                print("Failed to cast to CommentViewController")
            }
        } else {
            let alert = UIAlertController(title: "Login to continue", message: "Log in to write a comment", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    @IBOutlet weak var deleteButton: UIButton!
    
    func updateButtonVisibility() {
//        Next line is from ChatGPT
        deleteButton.isHidden = true
        if isLoggedIn() {
            let defaults = UserDefaults.standard
            let currentUser = defaults.object(forKey: "loggedInUsername") as! String
//            Next 4 lines are from ChatGPT
            if currentUser == author {
                deleteButton.isHidden = false
            } else {
                deleteButton.isHidden = true
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
        return false
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
    
    // function to add a "no comments"
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No comments"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func updatePlaceholder() {
        if let cmts = comments {
            if cmts.count <= 0 {
                tableView.backgroundView = emptyLabel
            } else {
                tableView.backgroundView = nil
            }
        }
        else{
            tableView.backgroundView = emptyLabel
        }
    }
    
    // delegate method
    func commentAdded(commentString: String) {
        // since mongo has some read delay time right after write, we use delegate to add a local copy
        comments?.append(commentString)
        tableView.reloadData()
    }
}
