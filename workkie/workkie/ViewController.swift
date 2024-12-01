//
//  ViewController.swift
//  workkie
//
//  Created by Carl on 11/3/24.
//

import UIKit
import BSON
import Foundation
import MongoKitten
import MongoCore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dbManager = MongoTest()
    var tableData: [Post] = []
    //    Next line is from ChatGPT
    let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = tableData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let id = post._id
        cell.postAuthor.text = post.author
        cell.postContent.text = post.content
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MM/dd/yyyy " // yyyy/MM/dd HH:mm:ss
        let dateString = dateFormatter.string(from: currentDate)
        cell.postDate.text = dateString
        cell.postTitle.text = post.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let detailedVC = storyboard?.instantiateViewController(withIdentifier: "DetailedViewController") as? DetailedViewController else {
            print("DetailedViewController not found in storyboard!")
            return
        }
        
        // Pass data to DetailedViewController
        let post = tableData[indexPath.row]
        detailedVC.id = post._id
        detailedVC.author = post.author
        detailedVC.postTitle = post.title
        detailedVC.content = post.content
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm MM/dd/yyyy"
        detailedVC.date = dateFormatter.string(from: post.date ?? Date())
        detailedVC.comments = post.comments
        
        // set title
        detailedVC.title = post.title
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetchDataForTableView() {
        
        //print("up here")
        let url = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
        
        Task {
            do {
                try await dbManager.connect(uri: url)
                let listOfPosts = try await dbManager.getAllPosts() ?? []
                DispatchQueue.main.async {
                    self.tableData = listOfPosts.reversed()
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } catch {
                print("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        fetchDataForTableView()
        configureRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var postButton: UIButton!
    //    Next 5 lines are from ChatGPT
    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged) // Step 2: Add target for pull-to-refresh
        tableView.refreshControl = refreshControl
    }
    //    Next 3 lines are from ChatGPT
    @objc func refreshTableData() {
        fetchDataForTableView() // Fetch data again
    }
    
    //    Next 5 lines are from https://www.youtube.com/watch?v=q7l9H9PVnr4
    @IBAction func postButtonPressed(_ sender: Any) {
        if isLoggedIn() {
            let secondController = self.storyboard!.instantiateViewController(withIdentifier: "post_controller") as! SecondViewController
            secondController.title = "New Post"
            let navController = UINavigationController(rootViewController: secondController)
            self.present(navController, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Login to continue", message: "Log in to write a post", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
}
