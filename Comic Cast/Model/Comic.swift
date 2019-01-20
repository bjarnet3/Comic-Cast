//
//  Comic.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import Foundation

class Comic {
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
    
    init(num: Int?, title: String?, alt: String?, img: String?) {
        self.num = num
        self.title = title
        self.alt = alt
        self.img = img
    }
    
}
