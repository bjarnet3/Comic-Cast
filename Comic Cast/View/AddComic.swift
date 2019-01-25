//
//  AddComic.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class AddComic: UIView {
    
    @IBOutlet var addComicView: FrostyCornerView!
    
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicProgressView: UIProgressView!
    
    @IBOutlet weak var comicImageAddButton: UIButton!
    
    @IBOutlet weak var comicTitleCheck: UIButton!
    @IBOutlet weak var comicAltCheck: UIButton!
    
    @IBOutlet weak var comicTitleTextField: UITextField!
    @IBOutlet weak var comicAltTextField: UITextField!
    
    @IBOutlet weak var comicUploadButton: UIButton!
    @IBOutlet weak var comicCancelButton: UIButton!
    
    private var comic: Comic?
    private var completion: Completion?
    public var pickerImage: Completion?
    
    // MARK: - IBAction: Methods connected to UI
    // ----------------------------------------
    
    // Send Simple Message
    @IBAction private func uploadAction(_ sender: Any) {
        self.uploadRequest()
    }
    
    @IBAction private func cancelAction(_ sender: Any) {
        self.cancelRequest()
    }
    
    @IBAction private func tapBackground(_ sender: Any) {
        self.endEditing()
    }
    
    @IBAction private func completedAction(_ sender: Any) {
        self.endEditing()
    }
    
    // MARK: - Functions, Database & Animation
    // ---------------------------------------
    public func uploadRequest(completion: Completion? = nil) {
        setProgress(progress: 1.0, animated: true, alpha: 1.0, delay: 0.05, duration: 4.2, completion: nil)
        if let image = self.comicImageView.image {
            
            if let user = AuthService.instance.getUser() {
                if let comicUID = DataService.instance.REF_COMICS.childByAutoId().key {
                    /*
                    let comic = Comic(comicUID: comicUID, comicNumber: user.comics?.count ?? 0, comicTitle: comicTitleTextField.text ?? "", comicInfo: comicAltTextField.text ?? "", imgURL: "", logoURL: user.imageURL, userUID: user.userUID, userName: user.userName)
 
                    */
                    let dateString = dateToString()
                    let comic = Comic(comicUID: comicUID, comicNumber: user.comics?.count ?? 0, comicTitle: comicTitleTextField.text ?? "", comicInfo: comicAltTextField.text ?? "", comicDate: dateString, imgURL: "", logoURL: user.imageURL, userUID: user.userUID, userName: user.userName)
                    
                    DataService.instance.new(comic: comic, with: image, completion: {
                        self.setProgress(progress: 0.0, animated: true, alpha: 0.0, delay: 0.0, duration: 5.2, completion: {
                            self.completion?()
                        })
                    })
                }
            }
            
        } else {
            self.pickerImage?()
            setProgress(progress: 0.0, animated: true, alpha: 0.0, delay: 0.0, duration: 4.2, completion: {
                completion?()
            })
        }
    }
    
    private func cancelRequest() {
        self.comicImageAddButton.alpha = 1.0
        self.comicImageAddButton.isUserInteractionEnabled = true
        self.comicUploadButton.setTitle("Upload Comic", for: .normal)
        self.completion?()
    }
    
    //Calls this function when the tap is recognized.
    private func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.endEditing()
    }
    
    private func endEditing() {
        setProgress(progress: 0.0, animated: true, alpha: 1.0, delay: 0.4, duration: 3.2, completion: nil)
        let titleItemText = self.comicTitleTextField.text?.isEmpty ?? true ? " □ " : " ■ "
        let priceItemText = self.comicAltTextField.text?.isEmpty ?? true ? " □ " : " ■ "
        
        self.comicTitleCheck.setTitle(titleItemText, for: .normal)
        self.comicAltCheck.setTitle(priceItemText, for: .normal)
        
        self.endEditing(true)
    }
    
    private func setProgress(progress: Float = 1.0, animated: Bool = true, alpha: CGFloat = 1.0, delay: TimeInterval = 0.15, duration: TimeInterval = 0.45, completion: Completion? = nil) {
        if let progressView = self.comicProgressView {
            if animated {
                progressView.setProgress(progress, animated: animated)
                UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.70, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                    progressView.alpha = alpha
                })
            } else {
                progressView.setProgress(progress, animated: animated)
                progressView.alpha = alpha
            }
        }
        completion?()
    }
    
    // MARK: - Initializers
    // ---------------------------------------
    
    // This initializer hides init(frame:) from subclasses
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    // Initialize frame
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    // Initialize Xib File
    private func initNib() {
        Bundle.main.loadNibNamed("AddComic", owner: self, options: nil)
        addSubview(addComicView)
        addComicView.frame = self.bounds
        addComicView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // Initialize Data
    public func initData(comic: Comic?, completion: Completion? = nil) {
        if let comic = comic?.comicTitle {
            print(comic)
        }
        self.completion = completion
    }
    
    public func initImage(image: UIImage) {
        self.comicImageView.image = image
        self.comicImageAddButton.alpha = 0.0
        self.comicImageAddButton.isUserInteractionEnabled = false
        self.comicUploadButton.setTitle("Upload Image", for: .normal)
    }
    
    // MARK: - ViewLoad / LayoutView
    // ---------------------------------------
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
