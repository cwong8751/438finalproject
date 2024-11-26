//
//  ConnectViewController.swift
//  workkie
//
//  Created by Aman Verma on 11/9/24.
//

import UIKit
import MapKit
import BSON

class ConnectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKMapViewDelegate {
    
    // define location manager for map
    let locationManager = LocationManager()
    
    // MARK: - Outlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    var profiles: [User] = []
    var filteredProfiles: [User] = []
    
    let mongoTest = MongoTest()  // Instance to handle MongoDB operations
    let useRealData = true  // Toggle between real data and pseudo data
    var currentUser: ObjectId?
    var currentUsername: String?
    
    // swipe down to refresh
    let swipeRefresh = UIRefreshControl()
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup delegates and data sources
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        mapView.delegate = self
        
        // configure swipe down to refresh
        swipeRefresh.addTarget(self, action: #selector(connectToMongoDB), for: .valueChanged)
        tableView.refreshControl = swipeRefresh
        
        // Register the custom cell nib
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        
        // Adjust row height for better UI
        tableView.rowHeight = 60
        
        // Check whether to use real MongoDB data or pseudo data
        if useRealData {
            connectToMongoDB()
        } else {
            loadPseudoData()
        }
        
        // Setup map view
        setupMapView()
        
        // send user current coordinates to mongo db so others can see
        Task {
            do {
                await setUserCoordinates()
            }
        }
        
        // start fetching connection requests
        startFetchConnectionRequest()
    }
    
    //FIXME: this does not work
    private func setUserCoordinates() async {
        // get user's latitude and longitude and update it to mongo
        let userCoord = locationManager.userCoordinates
        
        // get current user
        if let loggedInUser = UserDefaults.standard.string(forKey: "loggedInUserID") {
            
            // set global variables
            currentUser = ObjectId(loggedInUser)
            currentUsername = UserDefaults.standard.string(forKey: "loggedInUsername") ?? ""
            
            print("current user is: ", currentUsername)
            
            // get user specifics
            let allUsers = await mongoTest.getUsers()
            
            if let gotUser = allUsers?.first(where: {$0._id?.hexString == loggedInUser}) {
                // create new user object
                let userWithCoord = User(id: gotUser._id!, username: gotUser.username, password: gotUser.password, latitude: gotUser.latitude, longitude: gotUser.longitude)
                
                // insert the user back
                Task {
                    do {
                        let insertResult = try await mongoTest.updateUser(newUser: userWithCoord)
                        
                        if insertResult {
                            print("user coordinates updated ")
                        }
                        else{
                            print("update user with coordinates failed")
                        }
                    }
                    catch {
                        print("update user with coordinates failed")
                    }
                }
            }
        }
    }
    
    // MARK: - Map View Setup
    private func setupMapView() {
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.showsScale = true
        locationManager.requestLocation()
    }
    
    // update map annotations for all users
    private func updateMapAnnotationsForAllUsers() {
        // remove existing
        mapView.removeAnnotations(mapView.annotations)
        
        // Add annotations for all profiles with valid latitude and longitude
        for user in profiles {
            guard let lat = user.latitude, let lon = user.longitude else { continue }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.title = user.username
            mapView.addAnnotation(annotation)
        }
    }
    
    // set up connection
    @objc func connectToMongoDB() {
        Task {
            do {
                // Replace with your actual MongoDB URI
                try await mongoTest.connect(uri: "mongodb+srv://chengli:Luncy1234567890@users.at6lb.mongodb.net/users?authSource=admin&appName=Users")
                
                print("Connected to MongoDB successfully!")
                await loadUserProfiles()  // Load data after successful connection
            } catch {
                print("Failed to connect to MongoDB: \(error)")
                //loadPseudoData()  // Optionally load pseudo data if real data fails
            }
        }
    }
    
    // MARK: - Data Loading Methods
    func loadUserProfiles() async {
        if let users = await mongoTest.getUsers() {
            profiles = users
            filteredProfiles = profiles
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.updateMapAnnotationsForAllUsers()  // Update map after loading data
                self.swipeRefresh.endRefreshing()
            }
        } else {
            print("No users found in MongoDB.")
        }
    }
    
    func loadPseudoData() {
        profiles = [
            User(username: "Alice", password: "password1", latitude: 37.7749, longitude: -122.4194),
            User(username: "Bob", password: "password2", latitude: 37.7753, longitude: -122.4200),
            User(username: "Charlie", password: "password3", latitude: 34.0522, longitude: -118.2437),
            User(username: "Diana", password: "password4", latitude: 51.5074, longitude: -0.1278),
            User(username: "Eve", password: "password5", latitude: 48.8566, longitude: 2.3522)
        ]
        
        filteredProfiles = profiles
        tableView.reloadData()
        updateMapAnnotationsForAllUsers()  // Update map after loading pseudo data
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
            return UITableViewCell()
        }
        
        // Configure the cell with user data
        let user = filteredProfiles[indexPath.row]
        cell.nameLabel?.text = user.username
        cell.designationLabel?.text = user.education
        cell.profileImageView?.image = UIImage(named: "profile_img")  // Ensure the image exists in your assets
        
        
        // Add an action for the Connect button
        cell.connectButton.addTarget(self, action: #selector(connectButtonTapped(_:)), for: .touchUpInside)
        cell.connectButton.tag = indexPath.row  // Use the tag to identify the selected row
        
        
        return cell
    }
    
    @objc func connectButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        let selectedUser = filteredProfiles[selectedIndex]
        
        Task {
            do {
                
                let clRequest = ConnectionRequest(fromUser: currentUser!, toUser: selectedUser._id!, status: "pending", date: Date(), fromUsername: currentUsername!, toUsername: selectedUser.username)
                
                let isRequestSent = try await mongoTest.sendConnectionRequest(clRequest: clRequest)
                
                DispatchQueue.main.async {
                    if isRequestSent {
                        // Show a success alert
                        let alert = UIAlertController(
                            title: "Request Sent",
                            message: "Connection request has been sent to \(selectedUser.username).",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    } else {
                        // Show a failure alert
                        let alert = UIAlertController(
                            title: "Request Failed",
                            message: "Could not send connection request. Please try again later.",
                            preferredStyle: .alert
                        )
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            } catch {
                // Handle errors and show an error alert
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Error",
                        message: "An error occurred: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected user
        let selectedUser = filteredProfiles[indexPath.row]
        
        // Ensure the user has a valid location (latitude and longitude)
        if let latitude = selectedUser.latitude, let longitude = selectedUser.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            // Center the map on the selected user's location
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            
            // Remove old annotations and add a new one for the selected user
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = selectedUser.username
            mapView.addAnnotation(annotation)
        } else {
            // Show an alert if the user's location is unavailable
            let alert = UIAlertController(title: "Location Unavailable", message: "The selected user does not have a valid location.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        // Deselect the row after handling the tap
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - UISearchBarDelegate Methods
    //     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //         if searchText.isEmpty {
    //             filteredProfiles = profiles
    //         } else {
    //             filteredProfiles = profiles.filter { user in
    //                 user.username.lowercased().contains(searchText.lowercased())
    //             }
    //         }
    //         tableView.reloadData()
    //     }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredProfiles = profiles
            mapView.removeAnnotations(mapView.annotations)  // Clear map annotations
            updateMapAnnotationsForAllUsers()  // Re-add all annotations
        } else {
            // Filter profiles based on search text
            filteredProfiles = profiles.filter { user in
                user.username.lowercased().contains(searchText.lowercased())
            }
            
            // If there are filtered results, focus on the first one on the map
            if let firstUser = filteredProfiles.first, let lat = firstUser.latitude, let lon = firstUser.longitude {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                // updates the map
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapView.setRegion(region, animated: true)
                
                // removes old annotations and add only the matching annotations
                mapView.removeAnnotations(mapView.annotations)
                for user in filteredProfiles {
                    if let lat = user.latitude, let lon = user.longitude {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        annotation.title = user.username
                        mapView.addAnnotation(annotation)
                    }
                }
            } else {
                // If no results, remove annotations and reset map
                mapView.removeAnnotations(mapView.annotations)
            }
        }
        tableView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // function to fetch incoming requests every x seconds
    func startFetchConnectionRequest() {
        // schedule a timer to fetch every 1 minute
        
        Timer.scheduledTimer(withTimeInterval: 20.0, repeats: true) { timer in
            Task {
                do {
                    
                    // check if user is actually logged in
                    if self.currentUser?.hexString == nil && self.currentUsername == nil {
                        print("user not logged in, not fetching connection requests")
                    }
                    else{
                        print("fetching connection requests")
                        print("current user", self.currentUser?.hexString)
                        let cRequests = try await self.mongoTest.getConnectionRequest(userId: self.currentUser!)
                        
                        // get all pending connection requests
                        for rq in cRequests! {
                            
                            if rq.status == "pending" {
                                let cnRequestMessage = rq.fromUsername + " wants to connect with you"
                                // show alert
                                let alert = UIAlertController(title: "New Connection Request", message: cnRequestMessage , preferredStyle: .alert)
                                
                                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
                                    // handle when user cancels connection request
                                }))
                                
                                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                                    // handle when user confirms connection request
                                    
                                    // get the old user
                                    Task {
                                        do{
                                            let gUser = try await self.mongoTest.getUser(userId: self.currentUser!)
                                            
                                            // Safely unwrap gUser
                                            if let gUser = gUser {
                                                // Ensure connections array is non-nil
                                                var updatedConnections = gUser.connections ?? []
                                                
                                                // Create new connection and append to the array
                                                let nConnection = Connection(username: rq.fromUsername)
                                                updatedConnections.append(nConnection)
                                                
                                                // Create new user with updated connections
                                                let newUser = User(
                                                    id: gUser._id!,
                                                    username: gUser.username,
                                                    password: gUser.password,
                                                    latitude: gUser.latitude,
                                                    longitude: gUser.longitude,
                                                    connectionRequests: [], // Assuming requests are cleared
                                                    connections: updatedConnections
                                                )
                                                
                                                // creates a new user to replace the old one, remove the existing connection request
                                                try await self.mongoTest.updateUser(newUser: newUser)
                                            }
                                        }
                                        catch {
                                            print(error)
                                        }
                                    }
                                }))
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                            // else ignore the request because it is already fulfilled
                        }
                    }
                }
                catch {
                    print(error)
                }
            }
        }
    }
}
