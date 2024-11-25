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
    var status: String
    var date: Date
    
    // status is almost always pending
    init(fromUser: ObjectId, toUser: ObjectId, status: String, date: Date) {
        self.fromUser = fromUser
        self.toUser = toUser
        self.status = status
        self.date = date
    }
    
    func toDocument() -> Document {
        return [
            "fromUser": fromUser,
            "toUser": toUser,
            "status": status,
            "date": date
        ]
    }
}
