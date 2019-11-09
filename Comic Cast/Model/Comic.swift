//
//  Comic.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import Foundation

// Comic is the Primary Object
// ---------------------------
class Comic {
    var comicID: Int?
    var comicUID: String?
    var comicNumber: Int?
    var comicName: String?

    var comicTitle: String?
    var comicInfo: String?
    var comicVote: Int = 0
    var comicURL: String?
    var comicDate: String?

    var userURL: String?
    var userUID: String?
    var userName: String?
    
    var fav: Bool = false
    
    // @available(iOS, deprecated, message: "Only for the static objects")
    init(comicID: Int, comicName: String?, comicNumber: Int?, comicTitle: String?, comicInfo: String?, imgURL: String?, logoURL: String?) {
        self.comicID = comicID
        self.comicName = comicName
        self.comicNumber = comicNumber
        self.comicTitle = comicTitle
        self.comicInfo = comicInfo
        self.comicURL = imgURL
        self.userURL = logoURL
    }
    
    init(comicUID: String?, comicNumber: Int?, comicTitle: String?, comicInfo: String?, comicDate: String?, comicURL: String?, userURL: String?, userUID: String?, userName: String?) {
        self.comicUID = comicUID
        self.comicNumber = comicNumber
        self.comicTitle = comicTitle
        self.comicInfo = comicInfo
        self.comicDate = comicDate ?? dateToString()
        self.comicURL = comicURL
        self.userURL = userURL
        self.userUID = userUID
        self.userName = userName
    }
    
}
