//
//  CustomTableViewCell.swift
//  workkie
//
//  Created by Sang Won Bae on 11/12/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var postAuthor: UILabel!
    
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var postContent: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
