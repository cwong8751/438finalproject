//
//  ConnectViewController.swift
//  workkie
//
//  Created by Aman Verma on 11/9/24.
//

import UIKit
import MongoKitten

class ConnectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var profiles: [User] = []
    var filteredProfiles: [User] = []
    
    let mongoTest = MongoTest()  // create an instance of MongoTest to use MongoDB functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")

        // connect to MongoDB
        Task {
            do {
                let db = try await mongoTest.connect(uri: "your-mongodb-connection-string")
                print("Connected to MongoDB successfully!")
                
                // load data after connection
                await loadUserProfiles()
            } catch {
                print("Failed to connect to MongoDB: \(error)")
            }
        }
    }
    
    // load user profiles from MongoDB
    func loadUserProfiles() async {
        if let users = await mongoTest.getUsers() {  // get all users from the database
            profiles = users  // directly assign to profiles
            filteredProfiles = profiles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // tableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
            return UITableViewCell()
        }
        
        let user = filteredProfiles[indexPath.row]
        cell.nameLabel?.text = user.username
        cell.designationLabel?.text = "User"  // Placeholder designation
        
        // if, we want to load profile images, we can add that here
        cell.profileImageView.image = nil

        return cell
    }
    
    // searchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProfiles = profiles
        } else {
            filteredProfiles = profiles.filter { user in
                user.username.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
