//
//  ConnectionDetailViewController.swift
//  workkie
//
//  Created by Carl on 11/30/24.
//

import Foundation
import UIKit

class ConnectionDetailViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var connectionAmtLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        profileImageView.image = UIImage(named: "profile_img")
        
        if let user = user {
            usernameLabel.text = user.username
            emailLabel.text = user.email
            educationLabel.text = user.education
            degreeLabel.text = user.degree
            connectionAmtLabel.text = String(user.connections?.count ?? 0)
        }
    }
}
