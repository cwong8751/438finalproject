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
    let refreshControl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return theData.count
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        cell.textLabel!.text = theData[indexPath.row].name
//        cell.imageView?.image = theImageCache[indexPath.row]
        let post = tableData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.postAuthor.text = post.author
        cell.postContent.text = post.content
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        cell.postDate.text = dateString
        cell.postTitle.text = post.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailedVC = DetailedViewController()
        
        detailedVC.author = tableData[indexPath.row].author
        detailedVC.content = tableData[indexPath.row].content
        detailedVC.postTitle = tableData[indexPath.row].title
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        detailedVC.date = dateString
        
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetchDataForTableView() {
        
        print("up here")
        let url = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"

        Task {
            do {
                try await dbManager.connect(uri: url)
                let listOfPosts = try await dbManager.getAllPosts() ?? []
                DispatchQueue.main.async {
                    self.tableData = listOfPosts
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
    
    @IBOutlet weak var postBar: UITextField!
    
    @IBOutlet weak var postButton: UIButton!
    
    func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged) // Step 2: Add target for pull-to-refresh
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshTableData() {
        fetchDataForTableView() // Fetch data again
    }
    
//    Next 5 lines are from https://www.youtube.com/watch?v=q7l9H9PVnr4
    @IBAction func postButtonPressed(_ sender: Any) {
        let secondController = self.storyboard!.instantiateViewController(withIdentifier: "post_controller") as! SecondViewController
        secondController.loadViewIfNeeded()
        self.present(secondController, animated: true, completion: nil)
    }
}

