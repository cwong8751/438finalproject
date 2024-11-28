//
//  Post.swift
//  workkie
//
//  Created by Carl on 11/9/24.
//

import Foundation
import BSON

class Post: Codable {
    var _id: ObjectId?
    var author: String
    var content: String
    var date: Date
    var title: String
    var comments: [String]
    var upvotes: Int?
    
    // init function
    init(author: String, content: String, date: Date, title: String, comments: [String]) {
        self._id = nil // let mongo set it for us
        
        self.author = author
        self.content = content
        self.date = date
        self.title = title
        self.comments = comments
        self.upvotes = 0 // default number of upvotes is 0
    }
}
