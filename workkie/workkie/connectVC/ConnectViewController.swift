//
//  ConnectViewController.swift
//  workkie
//
//  Created by Aman Verma on 11/9/24.
//

import UIKit
import MapKit
//import MongoKitten  // Ensure you have MongoKitten installed and properly configured

class ConnectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKMapViewDelegate {
    
    // define location manager for map
    let locationManager = LocationManager()
    
    // I just fixed your code because it giving me errors when i am merging.
    
    // MARK: - Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var profiles: [User] = []
    var filteredProfiles: [User] = []
    
    let mongoTest = MongoTest()  // Instance to handle MongoDB operations
    
    // Toggle to switch between real MongoDB data and pseudo data
    let useRealData = false
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup delegates and data sources
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Register the custom cell nib
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        
        // Adjust row height for better UI
        tableView.rowHeight = 60
        
        if useRealData {
            connectToMongoDB()
        } else {
            loadPseudoData()
        }
        
        // set up mapview
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        locationManager.requestLocation()
        
        // set up location manager
        locationManager.$userCoordinates
            .receive(on: DispatchQueue.main)
            .sink {
            [weak self] coordinates in
            guard let self = self, let coordinates = coordinates else {return}
                let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 0.1, longitudinalMeters: 0.1)
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    // MARK: - MongoDB Connection
    func connectToMongoDB() {
        Task {
            do {
                // Replace with your actual MongoDB URI
                try await mongoTest.connect(uri: "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users")
                
                print("Connected to MongoDB successfully!")
                
                // Load data after successful connection
                await loadUserProfiles()
            } catch {
                print("Failed to connect to MongoDB: \(error)")
                // Optionally, load pseudo data if real data fails
                loadPseudoData()
            }
        }
    }
    
    // MARK: - Data Loading Methods
    
    /// Loads user profiles from MongoDB asynchronously
    func loadUserProfiles() async {
        if let users = await mongoTest.getUsers() {  // Ensure getUsers() is properly implemented
            profiles = users
            filteredProfiles = profiles
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            print("No users found in MongoDB.")
            // Optionally, load pseudo data if no users are found
            DispatchQueue.main.async {
                self.loadPseudoData()
            }
        }
    }
    
    /// Loads pseudo data for demonstration purposes
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
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
            // Return a default cell if casting fails
            return UITableViewCell()
        }
        
        // Configure the cell with user data
        let user = filteredProfiles[indexPath.row]
        cell.nameLabel?.text = user.username
        cell.designationLabel?.text = "Software Engineer"  // Placeholder; modify as needed
        
        // Set the profile image (ensure "profile_img" exists in your assets)
        cell.profileImageView?.image = UIImage(named: "profile_img")
        
        return cell
    }
    
    // MARK: - UISearchBarDelegate Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter profiles based on search text
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
        // Dismiss the keyboard when search button is clicked
        searchBar.resignFirstResponder()
    }
}
