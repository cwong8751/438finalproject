//
//  ConnectionRequest.swift
//  workkie
//
//  Created by Carl on 11/24/24.
//

import Foundation
import BSON

class ConnectionRequest: Codable {
    var fromUser: ObjectId
    var toUser: ObjectId
    var fromUsername: String
    var toUsername: String
    var status: String
    var date: Date
    
    // status is almost always pending
    init(fromUser: ObjectId, toUser: ObjectId, status: String, date: Date, fromUsername: String, toUsername: String) {
        self.fromUser = fromUser
        self.toUser = toUser
        self.status = status
        self.date = date
        self.fromUsername = fromUsername
        self.toUsername = toUsername
    }
    
    func toDocument() -> Document {
        return [
            "fromUser": fromUser,
            "toUser": toUser,
            "status": status,
            "date": date,
            "fromUsername": fromUsername,
            "toUsername": toUsername
        ]
    }
}
