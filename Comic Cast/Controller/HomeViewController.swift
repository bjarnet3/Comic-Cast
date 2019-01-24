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

    // MARK: - IBOutlet: Connection to View "storyboard"
    // -------------------------------------------------
    @IBOutlet weak var registerView: FrostyCornerView!
    @IBOutlet weak var loginView: FrostyCornerView!
    
    @IBOutlet weak var loginUserName: UXTextField!
    @IBOutlet weak var loginPassWord: UXTextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UXTextField!
    @IBOutlet weak var profileAge: UXTextField!
    @IBOutlet weak var profileGender: UXTextField!
    
    @IBOutlet weak var batMessageView: FrostyCornerView!
    @IBOutlet weak var batMessage: UILabel!
    @IBOutlet weak var batMessageClose: UIButton!
    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    // MARK: - Properties: Array & Varables
    // -------------------------------------
    private var batMessageShowing = true
    private var loginViewShowing = true
    private var registerViewShowing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupBatMessage()
    }
    
    func setupBatMessage() {
        self.exitBatMessage()
        /*
        self.batMessageClose.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.batMessageClose.layer.cornerRadius = self.batMessageClose.frame.height / 2
        */
        self.batMessageView.layer.cornerRadius = self.batMessageView.frame.height / 2
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
        self.exitLoginView()
        self.profileImage.layer.cornerRadius = 18.0
    }
    
    // Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - IBAction: Methods connected to UI
    // -----------------------------------------
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
        exitBatMessage(delay: 0.0)
    }
    
    @IBAction func batMessageAlertAction(_ sender: Any) {
        self.batAlertMessage()
    }
    
    @IBAction func loginViewAction(_ sender: Any) {
        if !loginViewShowing {
            exitAllView()
            enterLoginView()
        } else {
            exitLoginView()
        }
    }
    
    @IBAction func registerViewAction(_ sender: Any) {
        if !registerViewShowing {
            exitAllView()
            enterRegisterView()
        } else {
            exitRegisterView()
        }
    }
    
    @IBAction func resignKeyboard(_ sender: Any) {
        dismissKeyboard()
    }

    // MARK: - EMAIL AUTHENTICATION & EMAIL REGISTER
    // ---------------------------------------------
    func emailLogin() {
        dismissKeyboard()
        if let email = self.loginUserName.text, let pwd = self.loginPassWord.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (auth, error) in
                if error == nil {
                    let authMessage = "PRINT: Email user authenticated with Firebase"
                    AuthService.instance.authMessage = authMessage
                    self.enterBatMessage()
                    
                    if let userUID = auth?.user.uid {
                        let user = User(userUID: userUID, userName: email, userPass: pwd)
                        AuthService.instance.setUser(user: user)
                        AuthService.instance.signIn(with: userUID)
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
        dismissKeyboard()
        if let email = self.loginUserName.text, let pwd = self.loginPassWord.text {
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (auth, error) in
                if error != nil {
                    let authMessage = "PRINT: Unable to Login with Error \(String(describing: error))"
                    print(authMessage)
                    hapticButton(.error)
                    AuthService.instance.authMessage = authMessage
                    AuthService.instance.signOut(service: .Email)
                    
                    self.batMessage.text = authMessage
                } else {
                    if let userUID = auth?.user.uid {
                        let user = User(userUID: userUID, userName: email, userPass: pwd)
                        hapticButton(.success)
                        let authMessage = "PRINT: Email login success"
                        print(authMessage)
                        AuthService.instance.authMessage = authMessage
                        AuthService.instance.signIn(with: userUID)
                        
                        self.batMessage.text = authMessage
                        let userData = [
                            "userUID": userUID,
                            "userEmail": email,
                            "userName" : self.profileName.text ?? "unknown",
                            "userAge": self.profileAge.text ?? "unknown",
                            "userGender": self.profileGender.text ?? "no gender"
                            ]
                        let profileImage = self.profileImage.image
                        self.completeRegister(user: user, userData: userData, userImage: profileImage)
                    }
                }
            })
        }
    }
    
    func completeRegister(user: User, userData: [String : String], userImage: UIImage?) {
        if let userUID = user.userUID {
            DataService.instance.createFirbaseDBUser(uid: userUID, userData: userData)
            KeychainWrapper.standard.set(userUID, forKey: KEY_UID)
            if let profileImage = userImage {
                DataService.instance.post(image: profileImage, to: user, completion: {
                    printDebug(object: "SUCCESS")
                })
            }
        }
    }
    
}

// MARK: - Animations & Messages
// -----------------------------
extension HomeViewController {
    func batAlertMessage() {
        if batMessageShowing {
            exitBatMessage(delay: 3.0)
        } else {
            enterBatMessage(completion: {
                self.exitBatMessage(delay: 2.5)
            })
        }
    }
    
    func enterBatMessage(completion: Completion? = nil, delay: Double = 0.0) {
        if !batMessageShowing {
            UIView.animate(withDuration: 0.56, delay: delay, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
                
                self.batMessageView.alpha = 1.0
                self.batMessageView.isUserInteractionEnabled = true
                
                self.batMessageView.transform = CGAffineTransform(translationX: 0, y: -12.8)
                self.batMessageShowing = true
            })
            completion?()
        }
    }
    
    func exitBatMessage(completion: Completion? = nil, delay: Double = 0.0) {
        if batMessageShowing {
            UIView.animate(withDuration: 0.55, delay: delay, usingSpringWithDamping: 0.67, initialSpringVelocity: 0.31, options: .curveEaseOut, animations: {
                
                self.batMessageView.alpha = 0.0
                self.batMessageView.isUserInteractionEnabled = false
                
                self.batMessageView.transform = CGAffineTransform(translationX: 0, y: 12.8)
                self.batMessageShowing = false
            })
            completion?()
        }
    }
    
    func enterLoginView(completion: Completion? = nil, delay: Double = 0.0) {
        if !loginViewShowing {
            UIView.animate(withDuration: 0.56, delay: delay, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
                
                self.loginView.alpha = 1.0
                self.loginView.isUserInteractionEnabled = true
                
                self.loginView.transform = CGAffineTransform(translationX: 0, y: -12.8)
                self.loginViewShowing = true
            })
            completion?()
        }
    }
    
    func exitLoginView(completion: Completion? = nil, delay: Double = 0.0) {
        if loginViewShowing {
            UIView.animate(withDuration: 0.55, delay: delay, usingSpringWithDamping: 0.67, initialSpringVelocity: 0.31, options: .curveEaseOut, animations: {
                
                self.loginView.alpha = 0.0
                self.loginView.isUserInteractionEnabled = false
                
                self.loginView.transform = CGAffineTransform(translationX: 0, y: 12.8)
                self.loginViewShowing = false
            })
            completion?()
        }
    }
    
    func enterRegisterView(completion: Completion? = nil, delay: Double = 0.0) {
        if !registerViewShowing {
            UIView.animate(withDuration: 0.56, delay: delay, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.3, options: .curveEaseIn, animations: {
                
                self.registerView.alpha = 1.0
                self.registerView.isUserInteractionEnabled = true
                
                self.registerView.transform = CGAffineTransform(translationX: 0, y: -12.8)
                self.registerViewShowing = true
            })
            completion?()
        }
    }
    
    func exitRegisterView(completion: Completion? = nil, delay: Double = 0.0) {
        if registerViewShowing {
            UIView.animate(withDuration: 0.55, delay: delay, usingSpringWithDamping: 0.67, initialSpringVelocity: 0.31, options: .curveEaseOut, animations: {
                
                self.registerView.alpha = 0.0
                self.registerView.isUserInteractionEnabled = false
                
                self.registerView.transform = CGAffineTransform(translationX: 0, y: 12.8)
                self.registerViewShowing = false
            })
            completion?()
        }
    }
    
    func exitAllView() {
        exitLoginView()
        exitRegisterView()
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

