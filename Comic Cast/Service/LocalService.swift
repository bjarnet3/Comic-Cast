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

public class LocalService {
    static let instance = LocalService()
    // Stored Public Properties in LocalService
}


