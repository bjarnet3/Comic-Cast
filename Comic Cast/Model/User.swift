//
//  User.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 22/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import Foundation

class User {
    
    var userUID: String?
    var userName: String?
    
    private var userEmail: String?
    private var userPass: String?
    
    var imageURL: String?
    var comics: [Comic]?
    
    init(userUID: String, userName: String, userPass: String) {
        self.userUID = userUID
        self.userName = userName
        self.userPass = userPass
    }
    
    init(userUID: String, userName: String, userPass: String, imageURL: String?) {
        self.userUID = userUID
        self.userName = userName
        self.userPass = userPass
        self.imageURL = imageURL
    }
    
    init(userUID: String, userName: String, userEmail: String?, userPass: String, imageURL: String?) {
        self.userUID = userUID
        self.userName = userName
        self.userEmail = userEmail
        self.userPass = userPass
        self.imageURL = imageURL

    }
    
}
