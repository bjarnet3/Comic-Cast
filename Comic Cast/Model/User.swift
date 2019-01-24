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
    private var userName: String?
    private var userPass: String?
    
    private var comic: Comic?
    private var comics: [Comic]?
    
    init(userUID: String, userName: String, userPass: String) {
        self.userUID = userUID
        self.userName = userName
        self.userPass = userPass
    }
}
