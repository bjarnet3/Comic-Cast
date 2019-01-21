//
//  LibraryViewController.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    
    // MARK: - IBOutlet: Connection to View "storyboard"
    // -------------------------------------------------
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var progressView: UIProgressView!

    // MARK: - Properties: Array & Varables
    // -------------------------------------
    private var comic: Comic?
    private var comics = [0:[Comic]()]
    private var comicsZero = [Comic]()
    private var comicsOne = [Comic]()

    private var comicView: AddComic?
    private var animator: UIViewPropertyAnimator?
    private var lastSelectedCell: UICollectionViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        testSetup()
    }
    
    // MARK: - Functions: Animations & Views
    // ----------------------------------------
    private func testSetup() {
        let comic1 = Comic(comicID: 0, comicName: "xkcd", num: 1100, title: "Vows", alt: "So, um. Do you want to get a drink after the game?", img: "https://imgs.xkcd.com/comics/vows.png", logo: "https://cdn.shopify.com/s/files/1/0149/3544/products/hoodie_1_7f9223f9-6933-47c6-9af5-d06b8227774a_thumb.png")
        let comic2 = Comic(comicID: 0, comicName: "xkcd", num: 1320, title: "Walmart", alt: "What I really want is to hang out where I hung out with my friends in college, but have all my older relatives there too.", img: "https://imgs.xkcd.com/comics/walmart.png", logo: "https://cdn.shopify.com/s/files/1/0149/3544/products/hoodie_1_7f9223f9-6933-47c6-9af5-d06b8227774a_thumb.png")
        let comic3 = Comic(comicID: 0, comicName: "xkcd", num: 803, title: "Airfoil", alt: "This is a fun explanation to prepare your kids for; it's common and totally wrong. Good lines include 'why does the air have to travel on both sides at the same time?' and 'I saw the Wright brothers plane and those wings were curved the same on the top and bottom!'", img: "https://imgs.xkcd.com/comics/airfoil.png", logo: "https://cdn.shopify.com/s/files/1/0149/3544/products/hoodie_1_7f9223f9-6933-47c6-9af5-d06b8227774a_thumb.png")
        let comic4 = Comic(comicID: 0, comicName: "xkcd", num: 44, title: "Love", alt: "This one makes me wince every time I think about it", img: "https://imgs.xkcd.com/comics/love.jpg", logo: "https://cdn.shopify.com/s/files/1/0149/3544/products/hoodie_1_7f9223f9-6933-47c6-9af5-d06b8227774a_thumb.png")
        
        let comic5 = Comic(comicID: 1, comicName: "xkcd", num: 44, title: "Love", alt: "This one makes me wince every time I think about it", img: "https://imgs.xkcd.com/comics/love.jpg", logo: "https://cdn.shopify.com/s/files/1/0149/3544/products/hoodie_1_7f9223f9-6933-47c6-9af5-d06b8227774a_thumb.png")
        
        self.comicsZero.append(comic1)
        self.comicsZero.append(comic2)
        self.comicsZero.append(comic3)
        self.comicsZero.append(comic4)
        self.comicsOne.append(comic5)
        
        self.comics[0]?.append(contentsOf: comicsZero)
        self.comics[1]?.append(contentsOf: comicsOne)
    }

    private func enterAddComicView() {
        // Instantiate Visual Blur View
        let visualView = UIVisualEffectView(frame: UIScreen.main.bounds)
        self.view.addSubview(visualView)
        
        let staticFrame = CGRect(x: 10, y: 60, width: 354, height: 442)
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
        comicView.initData(comic: self.comic, completion: {
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

// MARK: - UICollectionViewDelegate & Datasource
// ---------------------------------------------
extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.comics[section]?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let comicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCollectionCell", for: indexPath) as?
            ComicCollectionCell else { return UICollectionViewCell() }
        
        if let comicSection = self.comics[indexPath.section] {
            let comic = comicSection[indexPath.row]
            comicCell.loadCell(comic: comic)
            return comicCell
        }
        return UICollectionViewCell()
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.lastSelectedCell = collectionView.cellForItem(at: indexPath)

        if indexPath.row == self.comics.count {
            enterAddComicView()
        }
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            if let cellHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ComicCollectionHeader", for: indexPath) as? ComicCollectionHeader {
                
                if let comicSection = self.comics[indexPath.section] {
                    let comic = comicSection[indexPath.row]
                    cellHeader.loadSectionHeader(comic: comic)
                    return cellHeader
                }
            }
        }
        return UICollectionReusableView()
    }
    
}

// MARK: - UIImagePicker & UINavigationControllerDelegate
// ------------------------------------------------------
extension LibraryViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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

// MARK: - UIScrollView, Delegate
// ------------------------------
extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset)
    }
}

