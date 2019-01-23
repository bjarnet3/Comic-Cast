//
//  AuthService.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 22/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import Foundation
import Firebase
// KeychainWrapper
import SwiftKeychainWrapper

public enum Service {
    case Facebook
    case Firebase
    case Email
    case All
}

public enum State: String {
    case active = "active"
    case inactive = "inactive"
    case foreground = "foreground"
    case background = "background"
    case terminate = "terminate"
}

public func returnState(state: String) -> State? {
    return State(rawValue: state)
}

/// Sign In Status in (LocalService Singleton)
var signedIn = AuthService.instance.signedIn

// AuthService Singleton
// ---------------------
class AuthService {
    static let instance = AuthService()
    
    var user: User? = nil {
        didSet {
            if let user = self.user {
                self.userUID = user.userID
            }
        }
    }
    
    var comic: Comic? = nil {
        didSet {
            if let comic = self.comic {
                if let comicUID = comic.comicUID {
                    self.comicUID = comicUID
                }
            }
        }
    }
    
    // Temporary Public userUID & comicUID
    // -----------------------------------
    var userUID: String? = "MaVMwKetkfOBjlwfL4yUbm8qpIp2"
    var comicUID: String?
    
    // Temporary Public userName & Password
    // ------------------------------------
    var userName: String? = "test@test.no"
    var passWord: String? = "1234567"
    
    var signedIn: Bool = false
    var authMessage: String? {
        didSet {
            let message = self.authMessage ?? "nil"
            print(message)
        }
    }
    
    func signIn(with userID: String) {
        KeychainWrapper.standard.set(userID, forKey: KEY_UID)
        signedIn = true
    }
    
    func signOut(service: Service = .All) {
        switch service {
        case .Facebook: break
        // self.facebookLogout()
        case .Firebase:
            try! Auth.auth().signOut()
        case .Email:
            try! Auth.auth().signOut()
            self.signedIn = false
        default:
            _ = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
            try! Auth.auth().signOut()
            self.signedIn = false
            AuthService.instance.user = nil
        }
    }
    
    func setUser(user: User?) {
        if let user = user {
            self.user = user
        }
    }
    
    func getUser() -> User? {
        return user
    }
    
    func setComic(comic: Comic?) {
        if let comic = comic {
            self.comic = comic
        }
    }
    
    func getComic() -> Comic? {
        return comic
    }
    
    func saveAuth() {
        if let userUID = userUID {
            KeychainWrapper.standard.set(userUID, forKey: KEY_UID)
        }
        if let userName = userName {
            KeychainWrapper.standard.set(userName, forKey: USER_NAME)
        }
        if let userPass = passWord {
            KeychainWrapper.standard.set(userPass, forKey: USER_PASS)
        }
    }
    
    func getAuth() {
        if let userUID = KeychainWrapper.standard.string(forKey: KEY_UID) {
            self.userUID = userUID
        }
        if let userName = KeychainWrapper.standard.string(forKey: USER_NAME) {
            self.userName = userName
        }
        if let userPass = KeychainWrapper.standard.string(forKey: USER_PASS) {
            self.passWord = userPass
        }
    }
    
}
