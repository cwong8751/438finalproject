//
//  User.swift
//  workkie
//
//  Created by Carl on 11/5/24.
//

import Foundation

class User: Codable {
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
