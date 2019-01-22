//
//  LocalService.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

// Completion Typealias
public typealias Completion = () -> Void

/// if **Low Power Mode Enabled** return **false**
public var lowPowerModeDisabled: Bool {
    return !ProcessInfo.processInfo.isLowPowerModeEnabled
}

// Stored Images
public let imageCache = NSCache<NSString, UIImage>()

// LocalSerive Singleton for Local Properies / Functions
// -----------------------------------------------------
public class LocalService {
    static let instance = LocalService()
    // Stored Public Properties in LocalService
    
    private let settings = [
        Settings(imageName: "noun_1052547_cc", title: "Bruker Profil", info: "Set dine personlige instillinger her"),
        Settings(imageName: "noun_1402133_cc", title: "Inviter Venner", info: "Inviter venner og familie"),
        Settings(imageName: "noun_974817_cc-orange", title: "Trenger du Hjelp?", info: "FAQ, veiledning og kontakt info"),
        Settings(imageName: "noun_1177170_cc", title: "Innstillinger", info: "Applikasjons Instillinger"),
        Settings(imageName: "noun_1086663_cc", title: "Notification", info: "Set personlige varsler"),
        Settings(imageName: "noun_1323364_cc", title: "Sikkerhet / Personvern", info: "Her kan du logge ut din bruker")
    ]
    
    func getSettings() -> [Settings] {
        return settings
    }
}

// Settings Object
public struct Settings {
    private(set) public var imageName: String
    private(set) public var title: String
    private(set) public var info: String
    
    init(imageName: String, title: String, info: String) {
        self.imageName = imageName
        self.title = title
        self.info = info
    }
}


