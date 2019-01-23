//
//  Constants.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

// Static User ID, Facebook ID, Post ID og Request ID
let KEY_UID = "uid"
let KEY_FID = "fid"
let KEY_PID = "pid"
let KEY_RID = "rid"

let USER_NAME = "usr"
let USER_PASS = "pss"

// Color Constants
let SHADOW_GRAY: CGFloat = 120.0 / 255.0
let BLACK_SOLID = UIColor.black
let GRAY_SOLID = UIColor.gray

let WHITE_SOLID = hexStringToUIColor("#FFFFFF")
let WHITE_ALPHA = hexStringToUIColor("#FFFFFF", 0.3)

let PINK_SOLID = hexStringToUIColor("#cc00cc")
let PINK_DARK_SOLID = hexStringToUIColor("#660033")
let PINK_DARK_SHARP = hexStringToUIColor("#FF3191") // FF3191

let ORANGE_SOLID = hexStringToUIColor("#cc3300")
let RED_SOLID = hexStringToUIColor("#cc0000")
let RED_SHARP_SOLID = hexStringToUIColor("#FF0D23")
let RED_SHARP_ALPHA = hexStringToUIColor("#FF0D23", 0.5)

let RED_PINK_SOLID = hexStringToUIColor("#FF294C")
let PINK_NANNY_LOGO = hexStringToUIColor("#ff3366")
let ORANGE_NANNY_LOGO = hexStringToUIColor("#ff6633")

let PINK_TABBAR_SELECTED = hexStringToUIColor("#FC2F92")
let PINK_TABBAR_UNSELECTED = hexStringToUIColor("#FF85FF")

let LIGHT_GREY = hexStringToUIColor("#EBEBEB")
let LIGHT_PINK = hexStringToUIColor("#FF72C8")
let LIGHT_BLUE = hexStringToUIColor("#0096FF")

let AQUA_BLUE = hexStringToUIColor("#0096FF")
let STRAWBERRY = hexStringToUIColor("#FF2F92")
let SILVER     = hexStringToUIColor("#D6D6D6")

// Font
var FONT_Avenir_Book = { (_ size: CGFloat?) -> UIFont in
    return UIFont(name: "Avenir-Book", size: size ?? 13.0)! }

