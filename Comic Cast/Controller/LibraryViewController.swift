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
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var progressView: UIProgressView!

    // MARK: - Properties: Array & Varables
    // -------------------------------------
    public var comics = [0:[Comic]()]
    public var comicSelected: Comic?
    
    private var comicView: AddComic?
    private var animator: UIViewPropertyAnimator?
    private var lastSelectedCell: UICollectionViewCell?
    
    private var confirmationShowing = true
    
    @IBAction func UploadAction(_ sender: Any) {
        self.enterAddComicView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitAddComicView()
        exitConfirmation()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset.top = 45
        testSetup()
    }
    
    // MARK: - Functions: Animations & Views
    // ----------------------------------------
    private func testSetup() {
        // Dilbert
        let comic0 = Comic(comicID: 0, comicName: "Dilbert", num: 1, title: "Business Insider", alt: "That's Not How It Works.", img: "https://static.businessinsider.com/image/525e97dfeab8ead530928bff/image.jpg", logo: "https://images-na.ssl-images-amazon.com/images/I/41lCbd6yFlL.jpg")
        
        let comic10 = Comic(comicID: 0, comicName: "Dilbert", num: 2, title: "Pie Chart", alt: "I pledge my life and fortune to the Pie!", img: "https://static.wingify.com/vwo/uploads/sites/3/2011/05/dilbert-strip.gif", logo: "https://images-na.ssl-images-amazon.com/images/I/41lCbd6yFlL.jpg")
        comic10.fav = true
        
        
        let comic1 = Comic(comicID: 1, comicName: "xkcd", num: 1100, title: "Vows", alt: "So, um. Do you want to get a drink after the game?", img: "https://imgs.xkcd.com/comics/vows.png", logo: "https://pbs.twimg.com/profile_images/2601531052/b7cct6s1npfvqmr87xyl_400x400.png")
        comic1.fav = true
        
        let comic2 = Comic(comicID: 1, comicName: "xkcd", num: 1320, title: "Walmart", alt: "What I really want is to hang out where I hung out with my friends in college, but have all my older relatives there too.", img: "https://imgs.xkcd.com/comics/walmart.png", logo: "http://cdn.embed.ly/providers/logos/xkcd.png")
        let comic3 = Comic(comicID: 1, comicName: "xkcd", num: 803, title: "Airfoil", alt: "This is a fun explanation to prepare your kids for; it's common and totally wrong. Good lines include 'why does the air have to travel on both sides at the same time?' and 'I saw the Wright brothers plane and those wings were curved the same on the top and bottom!'", img: "https://imgs.xkcd.com/comics/airfoil.png", logo: "http://cdn.embed.ly/providers/logos/xkcd.png")
        comic3.fav = true
        
        let comic4 = Comic(comicID: 1, comicName: "xkcd", num: 44, title: "Love", alt: "This one makes me wince every time I think about it", img: "https://imgs.xkcd.com/comics/love.jpg", logo: "https://pbs.twimg.com/profile_images/2601531052/b7cct6s1npfvqmr87xyl_400x400.png")
        
        
        // Calvin and Hobbes
        let comic6 = Comic(comicID: 2, comicName: "Calvin and Hobbes", num: 1, title: "Born to be wild", alt: "He'd be just as funny without all the Pooh jokes", img: "https://www.blingyourband.com/media/catalog/product/cache/1/image/650x650/9df78eab33525d08d6e5fb8d27136e95/i/m/image_calvin-hobbes-baby-helmet-design_2.jpg", logo: "https://gartic.com.br/imgs/mural/iv/ivan_ferraro/calvin-e-haroldo.png")
        comic6.fav = true
        
        let comic7 = Comic(comicID: 2, comicName: "Calvin and Hobbes", num: 2, title: "The dead bird", alt: "What to say about this one…sheer poetry. Did anybody say philosophy?", img: "https://calvy.files.wordpress.com/2010/08/dead-bird.jpg", logo: "https://gartic.com.br/imgs/mural/iv/ivan_ferraro/calvin-e-haroldo.png")
        comic7.fav = true
        
        let comic8 = Comic(comicID: 2, comicName: "Calvin and Hobbes", num: 3, title: "Stars", alt: "...", img: "https://i0.wp.com/dogwithblog.in/wp-content/uploads/2010/08/calvin-hobbs-stars-1.jpg", logo: "https://gartic.com.br/imgs/mural/iv/ivan_ferraro/calvin-e-haroldo.png")
        
        
        // Jerry Beck
        let comic20 = Comic(comicID: 9, comicName: "Jerry Beck", num: 1, title: "Today’s Bizarro", alt: "He'd be just as funny without all the Pooh jokes", img: "https://www.cartoonbrew.com/wp-content/uploads/bizarro4811.jpg", logo: "https://www.cartoonbrew.com/wp-content/themes/cartoon-brew/images/logo.png")
        
        self.comics[0] = [comic0, comic10]
        self.comics[1] = [comic1, comic2, comic3, comic4]
        self.comics[2] = [comic6, comic7, comic8]
        self.comics[3] = [comic20]
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
        comicView.initData(comic: self.comicSelected, completion: {
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
        guard let com = self.comics[section]?.count else { return 0 }
        return com
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(comics.keys.count)
        return comics.keys.count
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        self.lastSelectedCell = collectionView.cellForItem(at: indexPath)
        // Set Selected Comic
        let comics = self.comics[indexPath.section]
        if let comic = comics?[indexPath.row] {
            self.comicSelected = comic
        }
        
        /*
        if indexPath.row == self.comics.count {
            enterAddComicView()
        }
        */
    }
    
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

extension LibraryViewController {
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
extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // print(scrollView.contentOffset)
    }
}

