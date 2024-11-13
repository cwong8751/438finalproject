//
//  ConnectViewController.swift
//  workkie
//
//  Created by Aman Verma on 11/9/24.
//

import UIKit
//import MongoKitten

class ConnectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
        var profiles: [User] = []
        var filteredProfiles: [User] = []
    
    ////this below code is commented to populate the table with the random(sample) data
    //    let mongoTest = MongoTest()  // create an instance of MongoTest to use MongoDB functions
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        tableView.delegate = self
    //        tableView.dataSource = self
    //        searchBar.delegate = self
    //        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
    //
    //        // connect to MongoDB
    //        Task {
    //            do {
    //                _ = try await mongoTest.connect(uri: "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users")
    //
    //                print("Connected to MongoDB successfully!")
    //
    //                // load data after connection
    //                await loadUserProfiles()
    //            } catch {
    //                print("Failed to connect to MongoDB: \(error)")
    //            }
    //        }
    //    }
    //
    //    // load user profiles from MongoDB
    //    func loadUserProfiles() async {
    //        if let users = await mongoTest.getUsers() {  // get all users from the database
    //            profiles = users  // directly assign to profiles
    //            filteredProfiles = profiles
    //            DispatchQueue.main.async {
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    //
    //    // tableView DataSource Methods
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return filteredProfiles.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
    //            return UITableViewCell()
    //        }
    //
    //        let user = filteredProfiles[indexPath.row]
    //        cell.nameLabel?.text = user.username
    //        cell.designationLabel?.text = "User"  // Placeholder designation
    //
    //        // if, we want to load profile images, we can add that here
    //        cell.profileImageView.image = nil
    //
    //        return cell
    //    }
    //
    //    // searchBar Delegate Methods
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //        if searchText.isEmpty {
    //            filteredProfiles = profiles
    //        } else {
    //            filteredProfiles = profiles.filter { user in
    //                user.username.lowercased().contains(searchText.lowercased())
    //            }
    //        }
    //        tableView.reloadData()
    //    }
    //
    //    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    //        searchBar.resignFirstResponder()
    //    }
    //}
/////the above code is commented to populate the table view with sample data

<<<<<<< HEAD
        // connect to MongoDB
        Task {
            do {
                let db = try await mongoTest.connect(uri: "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users")

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
=======
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           tableView.delegate = self
           tableView.dataSource = self
           searchBar.delegate = self
           tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
           

           tableView.rowHeight = 60  // for better adjustment of the table cells

           // Load pseudo data
           loadPseudoData()
       }
       
       // Load pseudo data for demo
       func loadPseudoData() {
           profiles = [
               User(username: "Alice", password: "password1"),
               User(username: "Bob", password: "password2"),
               User(username: "Charlie", password: "password3"),
               User(username: "Diana", password: "password4"),
               User(username: "Eve", password: "password5")
           ]
           
           filteredProfiles = profiles
           tableView.reloadData()
       }
       
       // tableView DataSource Methods
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return filteredProfiles.count
       }
       
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
//               return UITableViewCell()
//           }
    //           let user = filteredProfiles[indexPath.row]
    //           cell.nameLabel?.text = user.username
    //           cell.designationLabel?.text = "Software Engineer"  // Example designation
    //
    //           // Set a common placeholder image for all profiles
    //           cell.profileImageView.image = UIImage(named: "placeholder_image")  // Replace "placeholder_image" with the actual image name in your assets
    //
    //           return cell
    //       }
>>>>>>> 117fc1c (Updation with the sample data)
    
    /////this is just to populate the table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
            return UITableViewCell()
        }
        
        // Configure user data
        let user = filteredProfiles[indexPath.row]
        cell.nameLabel?.text = user.username
        cell.designationLabel?.text = "Software Engineer"  // Placeholder designation
        
        // Set the static profile image
        cell.profileImageView?.image = UIImage(named: "profile_img")

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
