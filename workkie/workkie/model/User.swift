//
//  User.swift
//  workkie
//
//  Created by Carl on 11/5/24.
//

import Foundation
import BSON

class User: Codable {
    var _id: ObjectId? // object id is unique identifier, use this for coding
    var username: String
    var password: String
    var latitude: Double?  // to show latitude
    var longitude: Double? // to show longitude
    var education: String?
    var degree: String?
    var connectionRequests: [ConnectionRequest]?
    var connections: [Connection]?
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        self._id = nil // let mongo set it for us
        self.latitude = nil
        self.longitude = nil
        self.education = nil
        self.degree = nil
        self.connectionRequests = []
        self.connections = []
    }
    
    init(username: String, password: String, latitude: Double?, longitude: Double?) {
        self.username = username
        self.password = password
        self.latitude = latitude
        self.longitude = longitude
        self._id = nil
        self.education = nil
        self.degree = nil
        self.connectionRequests = []
        self.connections = []
    }
    
    init(id: ObjectId, username: String, password: String, latitude: Double?, longitude: Double?) {
        self.username = username
        self.password = password
        self.latitude = latitude
        self.longitude = longitude
        self._id = id
        self.education = nil
        self.degree = nil
        self.connectionRequests = []
        self.connections = []
    }
    
    init(id: ObjectId, username: String, password: String, latitude: Double?, longitude: Double?, connectionRequests: [ConnectionRequest]) {
        self._id = id
        self.username = username
        self.password = password
        self.latitude = latitude
        self.longitude = longitude
        self.connectionRequests = connectionRequests
        self.connections = []
    }
    
    init(id: ObjectId, username: String, password: String, latitude: Double?, longitude: Double?, connectionRequests: [ConnectionRequest], connections: [Connection]) {
        self._id = id
        self.username = username
        self.password = password
        self.latitude = latitude
        self.longitude = longitude
        self.connectionRequests = connectionRequests
        self.connections = connections
    }
    
    init(id: ObjectId, username: String, password: String, latitude: Double, longitude: Double, education: String, degree: String, connectionRequests: [ConnectionRequest], connections: [Connection]) {
        self._id = id
        self.username = username
        self.password = password
        self.education = education
        self.degree = degree
        self.longitude = longitude
        self.latitude = latitude
        self.connections = connections
        self.connectionRequests = connectionRequests
    }
    
    func toDocument() -> Document {
        var document: Document = [
            "username": username,
            "password": password,
            "connectionRequests": connectionRequests?.map { $0.toDocument() } ?? [],
            "connections": connections?.map { $0.toDocument() } ?? [],
            "latitude": latitude ?? 0,
            "longitude": longitude ?? 0,
            "education": education ?? "N/A",
            "degree": degree ?? "N/A"
        ]
        
        if let id = _id {
            document["_id"] = id
        }
        
        return document
    }

}
