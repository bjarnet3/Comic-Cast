//
//  AddViewController.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit
import Firebase

class CastViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var confirmationView: UIView!
    
    @IBAction func uploadComicAction(_ sender: UIButton) {
        enterAddComicView()
    }
    
    // MARK: - Properties: Array & Varables
    // -------------------------------------
    public var comicz = [Comic]()
    public var comics = [Comic]()
    
    public var comicSelected = [Comic]()
    
    private var confirmationShowing = true
    
    private var comicView: AddComic?
    private var animator: UIViewPropertyAnimator?
    
    private var lastSelectedCell: UICollectionViewCell?
    
    private func testSetup() {
        // Dilbert
        let comic0 = Comic(comicID: 0, comicName: "Dilbert", comicNumber: 1, comicTitle: "Business Insider", comicInfo: "That's Not How It Works.", imgURL: "https://static.businessinsider.com/image/525e97dfeab8ead530928bff/image.jpg", logoURL: "https://images-na.ssl-images-amazon.com/images/I/41lCbd6yFlL.jpg")
        
        // Calvin and Hobbes
        let comic1 = Comic(comicID: 2, comicName: "Calvin and Hobbes", comicNumber: 1, comicTitle: "Born to be wild", comicInfo: "He'd be just as funny without all the Pooh jokes", imgURL: "https://www.blingyourband.com/media/catalog/product/cache/1/image/650x650/9df78eab33525d08d6e5fb8d27136e95/i/m/image_calvin-hobbes-baby-helmet-design_2.jpg", logoURL: "https://gartic.com.br/imgs/mural/iv/ivan_ferraro/calvin-e-haroldo.png")
        comic1.fav = true
        
        self.comicz.append(contentsOf: [comic0, comic1])
    }
    
    // Observe Child Added
    // -------------------
    private func observeChildAdded() {
        let comicsREF = DataService.instance.REF_COMICS
        comicsREF.queryOrdered(byChild: "comicDate").observe(.childAdded, with: { (snapshot) in
            if let snapValue = snapshot.value as? Dictionary<String, AnyObject> {
                guard let comicUID = snapValue["comicUID"] as? String else { return }
                guard let comicTitle = snapValue["comicTitle"] as? String else { return }
                guard let comicInfo = snapValue["comicInfo"] as? String else { return }
                guard let comicURL = snapValue["comicURL"] as? String else { return }
                guard let comicDate = snapValue["comicDate"] as? String else { return }
                guard let userURL = snapValue["userURL"] as? String else { return }
                guard let userUID = snapValue["userUID"] as? String else { return }
                guard let userName = snapValue["userName"] as? String else { return }
                
                let comic = Comic(comicUID: comicUID, comicNumber: nil, comicTitle: comicTitle, comicInfo: comicInfo, comicDate: comicDate, imgURL: comicURL, logoURL: userURL, userUID: userUID, userName: userName)
                
                self.comics.append(comic)
                self.collectionView.reloadData()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitAddComicView()
        exitConfirmation()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset.top = 50
        
        observeChildAdded()
    }

    private func enterAddComicView() {
        // Instantiate Visual Blur View
        let visualView = UIVisualEffectView(frame: UIScreen.main.bounds)
        self.view.addSubview(visualView)
        
        let staticFrame = CGRect(x: 22.5, y: 50, width: 330, height: 342)
        let comicView = AddComic(frame: staticFrame)
        comicView.pickerImage = getImageFromPicker
        
        // Set properties
        visualView.effect = nil
        comicView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        comicView.alpha = 0.0
        comicView.backgroundColor = UIColor.clear
        
        // Instantiate UIPropertyAnimator
        animator = UIViewPropertyAnimator(duration: 0.38, curve: .easeOut) {
            visualView.effect = UIBlurEffect(style: .light)
        }
        
        self.comicView = comicView
        
        // Add Visual and RequestView to subview
        self.view.addSubview(visualView)
        self.view.addSubview(comicView)
        
        // Start Animator Animation (visualView)
        animator?.startAnimation()
        visualView.isUserInteractionEnabled = true
        
        // Start Request Animation
        UIView.animate(withDuration: 0.42, delay: 0.05, usingSpringWithDamping: 0.70, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
            comicView.alpha = 1.0
            comicView.isUserInteractionEnabled = true
            comicView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        
        // Init Data to comicView
        comicView.initData(comic: self.comicSelected.first, completion: {
            print("complete itemView")
            self.exitAddComicView()
        })
    }
    
    private func exitAddComicView() {
        var visualView: UIVisualEffectView?
        
        for view in self.view.subviews {
            if view is UIVisualEffectView {
                print("VisualEffectView is found")
                visualView = (view as? UIVisualEffectView)!
            }
            if view is AddComic {
                if let comicView = view as? AddComic {
                    self.comicView = comicView
                    
                    if let visualView = visualView {
                        self.animator = UIViewPropertyAnimator(duration: 0.38, curve: .easeOut) {
                            visualView.effect = nil
                        }
                        self.animator?.startAnimation()
                        visualView.isUserInteractionEnabled = false
                        
                        UIView.animate(withDuration: 0.35, delay: 0.00, usingSpringWithDamping: 0.70, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                            
                            self.comicView?.alpha = 0.0
                            self.comicView?.isUserInteractionEnabled = false
                            self.comicView?.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                        })
                        self.comicView = nil
                    }
                }
            }
        }
    }
    
    private func setProgress(progress: Float = 1.0, animated: Bool = true, alpha: CGFloat = 1.0, delay: TimeInterval = 0.15, duration: TimeInterval = 0.45, completion: Completion? = nil) {
        if let progressView = self.progressView {
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


}

// MARK: - UIImagePicker & UINavigationControllerDelegate
// ------------------------------------------------------
extension CastViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func getImageFromPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self //  self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: false)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // self.newItemImageView.image = image
            // self.itemImage(loaded: true)
            if comicView == self.comicView {
                comicView?.initImage(image: image)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate & Datasource
// ---------------------------------------------
extension CastViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comics = self.comics.count
        return comics + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCollectionCell", for: indexPath) as?
            AddCollectionCell else { return AddCollectionCell() }
        guard let comicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCollectionCell", for: indexPath) as?
            ComicCollectionCell else { return ComicCollectionCell() }
        
        if indexPath.row < self.comics.count {
            let comic = self.comics[indexPath.row]
            comicCell.loadCell(comic: comic)
            return comicCell
        } else {
            return addCell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // If last row selected
        if indexPath.row == self.comics.count {
            // Enter Add Comic View
            enterAddComicView()
        } else {
            // Enter Comic Detail
        }
        self.lastSelectedCell = collectionView.cellForItem(at: indexPath)
    }
    
}

extension CastViewController {
    func enterConfirmation() {
        if !confirmationShowing {
            UIView.animate(withDuration: 0.56, delay: 0.00, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                self.confirmationView.alpha = 1.0
                self.confirmationView.isUserInteractionEnabled = true
                self.confirmationView.transform = CGAffineTransform(translationX: 0, y: -15.0)
                self.confirmationShowing = true
            })
        }
        
    }
    
    func exitConfirmation() {
        if confirmationShowing {
            UIView.animate(withDuration: 0.55, delay: 0.02, usingSpringWithDamping: 0.67, initialSpringVelocity: 0.31, options: .curveEaseOut, animations: {
                self.confirmationView.alpha = 0.0
                self.confirmationView.isUserInteractionEnabled = false
                self.confirmationView.transform = CGAffineTransform(translationX: 0, y: 15.0)
                self.confirmationShowing = false
            })
        }
    }
}

// MARK: - UIScrollView, Delegate
// ------------------------------
extension CastViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset)
    }
}

