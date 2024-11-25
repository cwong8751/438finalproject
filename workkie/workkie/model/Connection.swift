//
//  Connection.swift
//  workkie
//
//  Created by Carl on 11/25/24.
//

import Foundation
import BSON


class Connection: Codable {
    var _id: ObjectId?
    var username: String
    
    init(_id: ObjectId? = nil, username: String) {
        self._id = _id
        self.username = username
    }
    
    func toDocument() -> Document {
        return [
            "$_id": _id!,
            "username": username,
        ]
    }
}
