//
//  Comic.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import Foundation

class Comic {
    var comicID: Int
    var comicName: String?
    
    var num: Int?
    var title: String?
    
    var day: String?
    var month: String?
    var year: String?
    
    var link: String?
    var news: String?
    var alt: String?
    
    var local: Bool = false
    var img: String?
    var logo: String?
    
    init(comicID: Int, comicName: String?, num: Int?, title: String?, alt: String?, img: String?, logo: String?) {
        self.comicID = comicID
        self.comicName = comicName
        self.num = num
        self.title = title
        self.alt = alt
        self.img = img
        self.logo = logo
    }
    
}
