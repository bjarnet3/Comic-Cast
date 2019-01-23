//
//  FirstViewController.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit
// Firebase
import Firebase
// KeychainWrapper
import SwiftKeychainWrapper

// Home Sweet Home...
// -----------------------------------------
class HomeViewController: UIViewController {

    @IBOutlet weak var loginView: FrostyCornerView!
    
    @IBOutlet weak var loginUserName: UITextField!
    @IBOutlet weak var loginPassWord: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profileAddress: UITextField!
    @IBOutlet weak var profileAge: UITextField!
    @IBOutlet weak var profileGender: UITextField!
    
    @IBOutlet weak var batMessageView: FrostyCornerView!
    @IBOutlet weak var batMessage: UILabel!
    @IBOutlet weak var batMessageClose: UIButton!
    @IBOutlet weak var batMessageOK: UIButton!
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    private var batMessageShowing = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupBatMessage()
    }
    
    func setupBatMessage() {
        self.exitBatMessage()
        self.batMessageClose.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.batMessageClose.layer.cornerRadius = self.batMessageClose.frame.height / 2
        
        self.batMessageOK.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.batMessageOK.layer.cornerRadius = self.batMessageClose.frame.height / 2
    }
    
    func setupScrollView() {
        if let image = UIImage(named: "U0Y2pqS") {
            // let patternImage = UIColor(patternImage: image)
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            // imageView.contentScaleFactor = 1.0
            // self.backgroundScrollView.backgroundColor = patternImage
            self.backgroundScrollView.addSubview(imageView)
        }
    }
    
    func setupLogin() {
        self.profileImage.layer.cornerRadius = 18.0
    }
    
    // MARK: - LOGIN ACTION FUNCTIONS
    @IBAction func signInAction(_ sender: Any) {
        emailLogin()
    }
    
    @IBAction func signOutAction(_ sender: Any) {
        AuthService.instance.signOut()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        emailRegister()
    }
    
    @IBAction func setProfileImg(_ sender: Any) {
        getImageFromPicker()
    }
    
    @IBAction func tapBackgroundView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func exitBatMessageAction(_ sender: Any) {
        exitBatMessage(delay: 0.05)
    }

    // MARK: - EMAIL AUTHENTICATION & EMAIL REGISTER
    func emailLogin() {
        if let email = AuthService.instance.userName, let pwd = AuthService.instance.passWord {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (auth, error) in
                if error == nil {
                    let authMessage = "PRINT: Email user authenticated with Firebase"
                    AuthService.instance.authMessage = authMessage
                    self.enterBatMessage()
                    
                    if let userID = auth?.user.uid {
                        let user = User(userID: userID, userName: email, userPass: pwd)
                        AuthService.instance.setUser(user: user)
                        AuthService.instance.signIn(with: userID)
                        // let name = "Bjarne"
                        // 1. Get info from database, and load to labels and buttons
                        // 2. Run login "Animations"
                        // 3. Show signOutViw
                        
                        self.batMessage.text = authMessage
                        self.batAlertMessage()
                    }
                } else {
                    let authMessage = "Wrong Email or Password"
                    AuthService.instance.authMessage = authMessage
                    AuthService.instance.signOut(service: .Email)
                    // SHOW DIALOG BOX WITH - WRONG EMAIL or PASSWORD
                    self.batMessage.text = authMessage
                    self.batAlertMessage()
                }
            })
        }
    }
    
    func emailRegister() {
        if let email = AuthService.instance.userName, let pwd = AuthService.instance.passWord {
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (auth, error) in
                if auth != nil {
                    let authMessage = "PRINT: Unable to Login with Error \(String(describing: error))"
                    hapticButton(.error)
                    AuthService.instance.authMessage = authMessage
                    AuthService.instance.signOut(service: .Email)
                    
                    self.batMessage.text = authMessage
                } else {
                    if let userID = auth?.user.uid {
                        hapticButton(.success)
                        let authMessage = "PRINT: Email login success"
                        AuthService.instance.authMessage = authMessage
                        AuthService.instance.signIn(with: userID)
                        
                        self.batMessage.text = authMessage
                        let userData = [
                            "userID": userID,
                            "userEmail": email,
                            "userAddress": self.profileAddress.text ?? "",
                            "userAge": self.profileAge.text ?? "",
                            "userGender": self.profileGender.text ?? ""
                            ]
                        self.completeRegister(id: userID, userData: userData)
                    }
                }
            })
        }
    }
    
    func completeRegister(id: String, userData: [String : String]) {
        DataService.instance.createFirbaseDBUser(uid: id, userData: userData)
        KeychainWrapper.standard.set(id, forKey: KEY_UID)
    }

}

extension HomeViewController {
    func batAlertMessage() {
        if batMessageShowing {
            exitBatMessage(completion: {
                self.enterBatMessage(completion: {
                    self.exitBatMessage()
                }, delay: 2.0)
            }, delay: 0.0)
        } else {
            enterBatMessage(completion: {
                self.exitBatMessage(delay: 0.5)
            }, delay: 2.2)
        }
    }
    
    func enterBatMessage(completion: Completion? = nil, delay: Double = 2.0) {
        if !batMessageShowing {
            UIView.animate(withDuration: 0.56, delay: delay, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                
                self.batMessageView.alpha = 1.0
                self.batMessageView.isUserInteractionEnabled = true
                
                self.batMessageView.transform = CGAffineTransform(translationX: 0, y: -15.0)
                self.batMessageShowing = true
            })
            completion?()
        }
    }
    
    func exitBatMessage(completion: Completion? = nil, delay: Double = 2.0) {
        if batMessageShowing {
            UIView.animate(withDuration: 0.55, delay: delay, usingSpringWithDamping: 0.67, initialSpringVelocity: 0.31, options: .curveEaseOut, animations: {
                
                self.batMessageView.alpha = 0.0
                self.batMessageView.isUserInteractionEnabled = false
                
                self.batMessageView.transform = CGAffineTransform(translationX: 0, y: 15.0)
                self.batMessageShowing = false
            })
            completion?()
        }
    }
    
}

// MARK: - UIImagePicker & UINavigationControllerDelegate
// ------------------------------------------------------
extension HomeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func getImageFromPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self //  self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage.image = image
            // self.postImageToFirebase(image: image)
        }
        self.dismiss(animated: true, completion: nil)
    }
}

