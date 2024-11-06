//
//  User.swift
//  workkie
//
//  Created by Carl on 11/5/24.
//

import Foundation
import BSON

// user class, combined to be used with mongotest
class User: Codable {
    var _id: ObjectId? // object id is unique identifier, use this for coding
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self._id = nil // let mongo set it for us
    }
}
