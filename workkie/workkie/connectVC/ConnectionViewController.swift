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

class ConnectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var connectionTableView: UITableView!
    @IBOutlet weak var noConnectionsLabel: UILabel!
    
    private var connections: [Connection] = []
    let dbManager = MongoTest()
    let dbUri = "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up table view
        connectionTableView.dataSource = self
        connectionTableView.delegate = self
        
        //TODO: fill connections array
        getConnections()
    }
    
    // table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "connectionViewCell", for: indexPath)
        cell.textLabel?.text = connections[indexPath.row].username
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected Row: \(indexPath.row)")
    }
    
    func getConnections() {
        if isLoggedIn() {
            // get user id
            let userId = UserDefaults.standard.string(forKey: "loggedInUserID") ?? ""
            
            print("logged in user id: " + userId)
            
            Task {
                do{
                    try await dbManager.connect(uri: dbUri)
                    let gUser = try await self.dbManager.getUser(userId: ObjectId(userId)!)
                    
                    // get all connections
                    if let gUser = gUser {
                        if let connections = gUser.connections {
                            print(connections)
                            self.connections = connections
                            noConnectionsLabel.isHidden = true
                        }
                        else{
                            print("got no connections")
                            connections = []
                            noConnectionsLabel.isHidden = false
                        }
                        DispatchQueue.main.async{
                            self.connectionTableView.reloadData()
                        }
                    }
                    else{
                        print("get user failed")
                        noConnectionsLabel.isHidden = true
                    }
                }
                catch {
                    print(error)
                }
            }
        }
        else{
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
    
}
