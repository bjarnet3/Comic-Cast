//
//  DataService.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 22/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import Foundation
import Firebase

// OFF SCOPE GLOBAL Database REF
// -----------------------------
let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

// DataService Singleton for Database Capabilities
// -----------------------------------------------------
class DataService {
    static let instance = DataService()
    // private let _REF: DatabaseReference = Database.database().reference(withPath: "data")
    
    // DB references
    private var _REF_BASE = DB_BASE
    
    // DB child references
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_COMICS = DB_BASE.child("comics")
    
    // Storage reference "AKA Datahiding"
    private var _REF_PROFILE_IMAGES = STORAGE_BASE.child("users")
    private var _REF_COMIC_IMAGES = STORAGE_BASE.child("comics")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_COMICS: DatabaseReference {
        return _REF_COMICS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = Auth.auth().currentUser?.uid
        let user = REF_USERS.child(uid!)
        return user
    }
    
    // Storage Images Reference "Path on the server"
    var REF_PROFILE_IMAGES: StorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    var REF_COMIC_IMAGES: StorageReference {
        return _REF_COMIC_IMAGES
    }
    
    // Database Functions
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
        // Create or Update "Users / UID / Values"
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateChildValues(userData: [String: String]) {
        let REF = REF_USER_CURRENT.child("testing")
        REF.updateChildValues(userData)
    }
    
    func post(userData: [String: Any]?, to user: User, completion: Completion? = nil) {
        if let userUID = user.userUID {
            let REF = REF_USERS.child(userUID)
            if let userData = userData {
                REF.updateChildValues(userData)
            }
        }
        completion?()
    }
    
    func post(comic: Comic, completion: Completion? = nil) {
        if let comicUID = comic.comicUID {
            let REF = REF_COMICS.child(comicUID)
            let userData: [String: String] = [
                "comicUID" : comicUID,
                "comicTitle": comic.comicTitle!,
                "comicInfo": comic.comicInfo!,
                "comicDate": comic.comicDate!,
                "comicURL": comic.comicURL!,
                "userURL": comic.userURL!,
                "userUID": comic.userUID!,
                "userName": comic.userName ?? "unknow",
            ]
            REF.updateChildValues(userData)
        }
        completion?()
    }
    
    func post(image: UIImage?, to comic: Comic?, completion: Completion? = nil) {
        if let user = AuthService.instance.getUser() {
            if let userUID = user.userUID {
                if let comicUID = /* KeychainWrapper.standard.string(forKey: KEY_UID) */ AuthService.instance.comicUID {
                    if let img = image {
                        // Generic Function
                        // if let imgData = UIImageJPEGRepresentation(img, 0.4) {
                        if let imgData = img.jpegData(compressionQuality: 0.4) {
                            // Unique image identifier
                            let imageUID = NSUUID().uuidString
                            // Set metaData for the image
                            let metadata = StorageMetadata()
                            metadata.contentType = "image/jpeg"
                            // Upload image - STORAGE_BASE.child(" --- ").child( --- ).put(image, meta)
                            let storageREF = DataService.instance.REF_COMIC_IMAGES.child(comicUID).child("items").child("\(imageUID).jpg")
                            storageREF.putData(imgData, metadata: metadata) { (metadata, error) in
                                if error != nil {
                                    print("postImageToFirebase: Unable to upload image to Firebase storage")
                                    print(error!)
                                } else {
                                    print("postImageToFirebase: Successfully uploaded image to Firebase storage")
                                    storageREF.downloadURL { (url, err) in
                                        if let absoluteUrlString = url?.absoluteString {
                                            if DataService.instance.REF_COMICS.child(comicUID).childByAutoId().key != nil {
                                                if let comic = comic {
                                                    let newComic = Comic(comicUID: comicUID, comicNumber: comic.comicNumber, comicTitle: comic.comicTitle, comicInfo: comic.comicInfo, imgURL: absoluteUrlString, logoURL: comic.userURL, userUID: userUID, userName: user.userName)
                                                    DataService.instance.post(comic: newComic)
                                                }
                                                completion?()
                                            }
                                        } else {
                                            print("unable to get imageLocation")
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
            }
            
        }
        
    }
    
    func new(comic: Comic?, with image: UIImage?, completion: Completion? = nil) {
        if let user = AuthService.instance.user {
            if let img = image {
                if let comicUID = comic?.comicUID {
                    
                    // if let imgData = UIImageJPEGRepresentation(img, 0.4) {
                    if let imgData = img.jpegData(compressionQuality: 0.4) {
                        // Unique image identifier
                        let imageUID = NSUUID().uuidString
                        // Set metaData for the image
                        let metadata = StorageMetadata()
                        metadata.contentType = "image/jpeg"
                        // Upload image - STORAGE_BASE.child(" --- ").child( --- ).put(image, meta)
                        let storageREF = DataService.instance.REF_COMIC_IMAGES.child(comicUID).child("\(imageUID).jpg")
                        storageREF.putData(imgData, metadata: metadata) { (metadata, error) in
                            if error != nil {
                                print("postImageToFirebase: Unable to upload image to Firebase storage")
                                print(error!)
                            } else {
                                print("postImageToFirebase: Successfully uploaded image to Firebase storage")
                                storageREF.downloadURL { (url, err) in
                                    if let absoluteUrlString = url?.absoluteString {
                                        if let comic = comic {
                                            comic.comicURL = absoluteUrlString
                                            DataService.instance.post(comic: comic)
                                        } else {
                                            if let comicUID = DataService.instance.REF_COMICS.childByAutoId().key {
                                                let newComic = Comic(comicUID: comicUID, comicNumber: 0, comicTitle: "comicTitle", comicInfo: "comicInfo", comicDate: comic?.comicDate, imgURL: absoluteUrlString, logoURL: user.imageURL, userUID: user.userUID, userName: user.userName)
                                                DataService.instance.post(comic: newComic)
                                            }
                                        }
                                        completion?()
                                    } else {
                                        print("unable to get imageLocation")
                                    }
                                }
                            }
                        }
                        
                    }
                }
                    
                }

            
        }
    }
    
    
    func post(image: UIImage?, to user: User?, completion: Completion? = nil) {
        if let userID = /* KeychainWrapper.standard.string(forKey: KEY_UID) */ AuthService.instance.userUID {
            if let img = image {
                // Generic Function
                // if let imgData = UIImageJPEGRepresentation(img, 0.4) {
                if let imgData = img.jpegData(compressionQuality: 0.4) {
                    // Unique image identifier
                    let imageUID = NSUUID().uuidString
                    // Set metaData for the image
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    // Upload image - STORAGE_BASE.child("post-pics").child(uniqueID).put(image, meta)
                    let storageREF = DataService.instance.REF_PROFILE_IMAGES.child(userID).child("library").child("\(imageUID).jpg")
                    storageREF.putData(imgData, metadata: metadata) { (metadata, error) in
                        if error != nil {
                            print("postImageToFirebase: Unable to upload image to Firebase storage")
                            print(error!)
                        } else {
                            print("postImageToFirebase: Successfully uploaded image to Firebase storage")
                            storageREF.downloadURL { (url, err) in
                                if let absoluteUrlString = url?.absoluteString {
                                    if let user = user {
                                        let imageURL = absoluteUrlString
                                        let userData: [String: Any] = [
                                            "imageURL" : imageURL
                                        ]
                                        self.post(userData: userData, to: user)
                                        completion?()
                                    } else {
                                        print("unable to get imageLocation")
                                    }
                                }
                            }
                        }

                    }
                }
                
            }
        }
    }
    
    
}
