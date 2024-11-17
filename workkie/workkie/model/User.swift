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
    var avatar: Data?
    var education: String?
    var degree: String?
    var email: String?
    
    // basic init function, avatar is optional, don't have to specify avatar when creating new user obj
    init(username: String, password: String, avatar: Data? = nil, email: String) {
        self.username = username
        self.password = password
        self._id = nil // let mongo set it for us
        self.avatar = avatar
        self.education = nil
        self.degree = nil
        self.email = email
    }
    
    // TODO: need avatar encode and decode function
}
