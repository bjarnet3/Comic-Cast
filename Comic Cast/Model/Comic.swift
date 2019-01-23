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
    var comicID: Int
    var comicUID: String?
    var comicName: String?
    var comicNumber: Int?
    
    var seasonID: Int?
    var seasonTitle: String?
    
    var episodeID: Int?
    var episodeUID: String?
    var episodeTitle: String?
    var episodeInfo: String?
    var episodeVote: Int = 0
    
    var day: String?
    var month: String?
    var year: String?
    
    var link: String?
    var news: String?

    var local: Bool = false
    var fav: Bool = false
    
    var imgURL: String?
    var logoURL: String?
    
    init(comicID: Int, comicName: String?, comicNumber: Int?, episodeTitle: String?, episodeInfo: String?, imgURL: String?, logoURL: String?) {
        self.comicID = comicID
        self.comicName = comicName
        self.comicNumber = comicNumber
        self.episodeTitle = episodeTitle
        self.episodeInfo = episodeInfo
        self.imgURL = imgURL
        self.logoURL = logoURL
    }
    
}
