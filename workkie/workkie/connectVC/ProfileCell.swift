//
//  ProfileCell.swift
//  workkie
//
//  Created by Aman Verma on 11/11/24.
//
//

import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
    
    /////the commented line of code is to populate the table view with the sample data
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        // Customize the button
//        connectButton?.layer.cornerRadius = 8
//        connectButton?.backgroundColor = .systemBlue
//        connectButton?.setTitleColor(.white, for: .normal)
//
//
//        
//        // Customize the profile image view to be circular
//        profileImageView?.layer.cornerRadius = profileImageView.frame.size.width / 2
//        profileImageView?.clipsToBounds = true
//        
//        // Set font sizes, alignments, or other properties if necessary
//        nameLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        designationLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
//    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        // Configure profile image to be circular
//        profileImageView?.layer.cornerRadius = profileImageView.frame.size.width / 2
//        profileImageView?.clipsToBounds = true
//        
//        // Style the connect button
//        connectButton?.layer.cornerRadius = 8
//        connectButton?.backgroundColor = .systemBlue
//        connectButton?.setTitleColor(.white, for: .normal)
//        
//        // Set a default placeholder image in case no image is provided
//        profileImageView?.image = UIImage(named: "placeholder_image") // Ensure "placeholder_image" exists in assets
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        // Set button title and style
        connectButton?.setTitle("Connect", for: .normal)
        connectButton?.setTitleColor(.white, for: .normal)
        connectButton?.layer.cornerRadius = 8
        connectButton?.backgroundColor = .systemBlue
        
        // Disable autoresizing mask translation for all views
//        profileImageView?.image = UIImage(named: "profile_img")
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        designationLabel?.translatesAutoresizingMaskIntoConstraints = false
        connectButton?.translatesAutoresizingMaskIntoConstraints = false
        



        // Set up profileImageView constraints safely
        if let profileImageView = profileImageView {
            // Set the static profile image
            profileImageView.image = UIImage(named: "profile_img")
            
            NSLayoutConstraint.activate([
                profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                profileImageView.widthAnchor.constraint(equalToConstant: 50),
                profileImageView.heightAnchor.constraint(equalToConstant: 50)
            ])
            profileImageView.layer.cornerRadius = 20
            profileImageView.clipsToBounds = true
        }


        // Set up nameLabel constraints safely
        if let nameLabel = nameLabel, let profileImageView = profileImageView, let connectButton = connectButton {
            NSLayoutConstraint.activate([
                nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                nameLabel.trailingAnchor.constraint(equalTo: connectButton.leadingAnchor, constant: -10)
            ])
        }

        // Set up designationLabel constraints safely
        if let designationLabel = designationLabel, let nameLabel = nameLabel {
            NSLayoutConstraint.activate([
                designationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                designationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
                designationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
            ])
        }

        // Set up connectButton constraints safely
        if let connectButton = connectButton {
            NSLayoutConstraint.activate([
                connectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                connectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                connectButton.widthAnchor.constraint(equalToConstant: 120),
                connectButton.heightAnchor.constraint(equalToConstant: 32)
//                connectButton.
            ])
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
