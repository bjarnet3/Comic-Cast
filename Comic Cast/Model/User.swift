//
//  User.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 22/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import Foundation

class User {
    
    var userID: String?
    private var userName: String?
    private var userPass: String?
    
    private var comic: Comic?
    private var comics: [Comic]?
    
    init(userID: String, userName: String, userPass: String) {
        self.userID = userID
        self.userName = userName
        self.userPass = userPass
    }
}
