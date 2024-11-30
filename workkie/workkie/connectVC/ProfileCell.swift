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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        designationLabel?.translatesAutoresizingMaskIntoConstraints = false
        connectButton?.translatesAutoresizingMaskIntoConstraints = false

        if let profileImageView = profileImageView {
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


        if let nameLabel = nameLabel, let profileImageView = profileImageView, let connectButton = connectButton {
            NSLayoutConstraint.activate([
                nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
                nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                nameLabel.trailingAnchor.constraint(equalTo: connectButton.leadingAnchor, constant: -10)
            ])
        }

        if let designationLabel = designationLabel, let nameLabel = nameLabel {
            NSLayoutConstraint.activate([
                designationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                designationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
                designationLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
            ])
        }

        if let connectButton = connectButton {
            NSLayoutConstraint.activate([
                connectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                connectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                connectButton.widthAnchor.constraint(equalToConstant: 120),
                connectButton.heightAnchor.constraint(equalToConstant: 32)
            ])
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
