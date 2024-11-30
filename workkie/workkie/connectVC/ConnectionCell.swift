//
//  ConnectionCell.swift
//  workkie
//
//  Created by Carl on 11/30/24.
//

import Foundation
import UIKit

class ConnectionCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        nameLabel?.translatesAutoresizingMaskIntoConstraints = false
        detailButton?.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        
        if let nameLabel = nameLabel, let profileImageView = profileImageView, let detailButton = detailButton {
            NSLayoutConstraint.activate([
                nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
                nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // Center vertically
                nameLabel.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -10)
            ])
        }
        
        if let detailButton = detailButton {
            NSLayoutConstraint.activate([
                detailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                detailButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                detailButton.widthAnchor.constraint(equalToConstant: 120),
                detailButton.heightAnchor.constraint(equalToConstant: 32)
            ])
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
