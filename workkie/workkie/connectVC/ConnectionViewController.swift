//
//  ConnectionViewController.swift
//  workkie
//
//  Created by Carl on 11/29/24.
//

import Foundation
import UIKit
import MapKit
import BSON

class ConnectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var connectionTableView: UITableView!
    @IBOutlet weak var noConnectionsLabel: UILabel!
    
    private var connections: [Connection] = []
    private var filteredConnections: [Connection] = []
    private var isSearching: Bool = false
    let dbManager = MongoTest()
    let dbUri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar
        searchBar.delegate = self
        searchBar.placeholder = "Search connections"
        searchBar.showsCancelButton = true
        
        // Set up table view
        connectionTableView.dataSource = self
        connectionTableView.delegate = self
        connectionTableView.register(UINib(nibName: "ConnectionCell", bundle: nil), forCellReuseIdentifier: "ConnectionCell")
        connectionTableView.rowHeight = 120
        getConnections()
    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredConnections.count : connections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionCell", for: indexPath) as? ConnectionCell else {
            return UITableViewCell()
        }
        
        let connection = isSearching ? filteredConnections[indexPath.row] : connections[indexPath.row]
        
        cell.nameLabel.text = connection.username
        cell.detailButton.addTarget(self, action: #selector(detailButtonPressed(_:)), for: .touchUpInside)
        cell.detailButton.tag = indexPath.row
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Row: \(indexPath.row)")
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredConnections.removeAll()
        } else {
            isSearching = true
            filteredConnections = connections.filter { connection in
                return connection.username.lowercased().contains(searchText.lowercased())
            }
        }
        connectionTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredConnections.removeAll()
        connectionTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Get Connections
    func getConnections() {
        if isLoggedIn() {
            let userId = UserDefaults.standard.string(forKey: "loggedInUserID") ?? ""
            
            print("logged in user id: " + userId)
            
            Task {
                do {
                    try await dbManager.connect(uri: dbUri)
                    let gUser = try await self.dbManager.getUser(userId: ObjectId(userId)!)
                    
                    if let gUser = gUser {
                        if let connections = gUser.connections {
                            print(connections)
                            self.connections = connections
                            noConnectionsLabel.isHidden = true
                        } else {
                            print("got no connections")
                            connections = []
                            noConnectionsLabel.isHidden = false
                        }
                        DispatchQueue.main.async {
                            self.connectionTableView.reloadData()
                        }
                    } else {
                        print("get user failed")
                        noConnectionsLabel.isHidden = true
                    }
                } catch {
                    print(error)
                }
            }
        } else {
            print("not getting connections, user not logged in")
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
    
    // MARK: - Detail Button Action
    @objc func detailButtonPressed(_ sender: UIButton) {
        let selectedIndex = sender.tag
        
        Task {
            do {
                try await dbManager.connect(uri: dbUri)
                let listUsers = try await dbManager.getUsers()
                var userBeingSend: User? = nil
                
                if let listUsers = listUsers {
                    for user in listUsers {
                        if user.username == connections[selectedIndex].username {
                            userBeingSend = user
                            break
                        }
                    }
                    
                    DispatchQueue.main.async {
                        let connectionDetailView = self.storyboard?.instantiateViewController(withIdentifier: "connectionDetailView") as! ConnectionDetailViewController
                        
                        if let user = userBeingSend {
                            connectionDetailView.user = user
                        }
                        connectionDetailView.title = "User Profile"
                        
                        let navController = UINavigationController(rootViewController: connectionDetailView)
                        self.present(navController, animated: true, completion: nil)
                    }
                } else {
                    print("get list of users failed")
                }
            } catch {
                print(error)
            }
        }
    }
}
