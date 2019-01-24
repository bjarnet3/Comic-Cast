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
    @IBOutlet weak var orderSegment: UISegmentedControl!
    
    @IBAction func UploadAction(_ sender: Any) {
        self.enterAddComicView()
    }
    
    @IBAction func sortedBy(_ sender: UISegmentedControl) {
        self.withSections = sender.selectedSegmentIndex == 0 ? true : false
        if sender.selectedSegmentIndex == 0 {
            // animate(out: self.collectionView)
        } else {
            // animate(in: self.collectionView)
        }
    }
    
    @IBAction func showDetailAction(_ sender: Any) {
        if let lastCell = lastSelectedCell as? ComicCollectionCell {
            goToComicDetail(cell: lastCell)
        }
    }
    
    // MARK: - Properties: Array & Varables
    // -------------------------------------
    public var comics = [0:[Comic]()]
    public var comicsByDate = [Comic]()
    public var comicSelected: Comic?
    
    private var comicView: AddComic?
    private var animator: UIViewPropertyAnimator?
    private var lastSelectedCell: UICollectionViewCell?
    
    private var confirmationShowing = true
    private var withSections = true {
        didSet {
            if !self.withSections {
                self.comicsByDate = self.comics.flatMap{ $0.value }
            }
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitAddComicView()
        exitConfirmation()
        
        segmentSetup()
        comicsSetup()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.top = 45
    }
    
    // MARK: - Functions: Animations & Views
    // ----------------------------------------
    private func comicsSetup() {
        // Dilbert
        let comic0 = Comic(comicID: 0, comicName: "Dilbert", comicNumber: 1, episodeTitle: "Business Insider", episodeInfo: "That's Not How It Works.", imgURL: "https://static.businessinsider.com/image/525e97dfeab8ead530928bff/image.jpg", logoURL: "https://images-na.ssl-images-amazon.com/images/I/41lCbd6yFlL.jpg")
        
        let comic10 = Comic(comicID: 0, comicName: "Dilbert", comicNumber: 2, episodeTitle: "Pie Chart", episodeInfo: "I pledge my life and fortune to the Pie!", imgURL: "https://static.wingify.com/vwo/uploads/sites/3/2011/05/dilbert-strip.gif", logoURL: "https://images-na.ssl-images-amazon.com/images/I/41lCbd6yFlL.jpg")
        comic10.fav = true
        
        let comic1 = Comic(comicID: 1, comicName: "xkcd", comicNumber: 1100, episodeTitle: "Vows", episodeInfo: "So, um. Do you want to get a drink after the game?", imgURL: "https://imgs.xkcd.com/comics/vows.png", logoURL: "https://pbs.twimg.com/profile_images/2601531052/b7cct6s1npfvqmr87xyl_400x400.png")
        comic1.fav = true
        
        let comic2 = Comic(comicID: 1, comicName: "xkcd", comicNumber: 1320, episodeTitle: "Walmart", episodeInfo: "What I really want is to hang out where I hung out with my friends in college, but have all my older relatives there too.", imgURL: "https://imgs.xkcd.com/comics/walmart.png", logoURL: "http://cdn.embed.ly/providers/logos/xkcd.png")
        let comic3 = Comic(comicID: 1, comicName: "xkcd", comicNumber: 803, episodeTitle: "Airfoil", episodeInfo: "This is a fun explanation to prepare your kids for; it's common and totally wrong. Good lines include 'why does the air have to travel on both sides at the same time?' and 'I saw the Wright brothers plane and those wings were curved the same on the top and bottom!'", imgURL: "https://imgs.xkcd.com/comics/airfoil.png", logoURL: "http://cdn.embed.ly/providers/logos/xkcd.png")
        comic3.fav = true
        
        let comic4 = Comic(comicID: 1, comicName: "xkcd", comicNumber: 44, episodeTitle: "Love", episodeInfo: "This one makes me wince every time I think about it", imgURL: "https://imgs.xkcd.com/comics/love.jpg", logoURL: "https://pbs.twimg.com/profile_images/2601531052/b7cct6s1npfvqmr87xyl_400x400.png")
        
        // Calvin and Hobbes
        let comic6 = Comic(comicID: 2, comicName: "Calvin and Hobbes", comicNumber: 1, episodeTitle: "Born to be wild", episodeInfo: "He'd be just as funny without all the Pooh jokes", imgURL: "https://www.blingyourband.com/media/catalog/product/cache/1/image/650x650/9df78eab33525d08d6e5fb8d27136e95/i/m/image_calvin-hobbes-baby-helmet-design_2.jpg", logoURL: "https://gartic.com.br/imgs/mural/iv/ivan_ferraro/calvin-e-haroldo.png")
        comic6.fav = true
        
        let comic7 = Comic(comicID: 2, comicName: "Calvin and Hobbes", comicNumber: 2, episodeTitle: "The dead bird", episodeInfo: "What to say about this one…sheer poetry. Did anybody say philosophy?", imgURL: "https://calvy.files.wordpress.com/2010/08/dead-bird.jpg", logoURL: "https://gartic.com.br/imgs/mural/iv/ivan_ferraro/calvin-e-haroldo.png")
        comic7.fav = true
        
        let comic8 = Comic(comicID: 2, comicName: "Calvin and Hobbes", comicNumber: 3, episodeTitle: "Stars", episodeInfo: "...", imgURL: "https://i0.wp.com/dogwithblog.in/wp-content/uploads/2010/08/calvin-hobbs-stars-1.jpg", logoURL: "https://gartic.com.br/imgs/mural/iv/ivan_ferraro/calvin-e-haroldo.png")
        
        // Jerry Beck
        let comic20 = Comic(comicID: 9, comicName: "Jerry Beck", comicNumber: 1, episodeTitle: "Today’s Bizarro", episodeInfo: "He'd be just as funny without all the Pooh jokes", imgURL: "https://www.cartoonbrew.com/wp-content/uploads/bizarro4811.jpg", logoURL: "https://www.cartoonbrew.com/wp-content/themes/cartoon-brew/images/logo.png")
        
        comic0.episodeVote = 2
        comic10.episodeVote = 15
        comic1.episodeVote = 6
        comic3.episodeVote = 77
        comic6.episodeVote = 21
        comic20.episodeVote = 22
        comic8.episodeVote = 83
        comic7.episodeVote = 102
        
        self.comics[0] = [comic0, comic10]
        self.comics[1] = [comic1, comic2, comic3, comic4]
        self.comics[2] = [comic6, comic7, comic8]
        self.comics[3] = [comic20]
    }
    
    private func segmentSetup() {
        orderSegment.layer.cornerRadius = orderSegment.frame.height / 2
        orderSegment.layer.borderColor = UIColor.white.cgColor
        orderSegment.layer.borderWidth = 1.0
        orderSegment.layer.masksToBounds = true
        orderSegment.setTitleTextAttributes([NSAttributedString.Key.font: FONT_Avenir_Book(14.0)], for: .normal)
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

// MARK: - UICollectionViewDelegate & Datasource
// ---------------------------------------------
extension LibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let comics = self.comics[section]?.count else { return 0 }
        return withSections ? comics : comicsByDate.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return withSections ? comics.keys.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let comicCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ComicCollectionCell", for: indexPath) as?
            ComicCollectionCell else { return UICollectionViewCell() }
        if withSections {
            if let comicSection = self.comics[indexPath.section] {
                let comic = comicSection[indexPath.row]
                comicCell.loadCell(comic: comic)
                return comicCell
            }
        } else {
            let comic = self.comicsByDate[indexPath.row]
                comicCell.loadCell(comic: comic)
            return comicCell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.lastSelectedCell = collectionView.cellForItem(at: indexPath)
        
        if lastSelectedCell == collectionView.cellForItem(at: indexPath) {
            if let cell = lastSelectedCell as? ComicCollectionCell {
                goToComicDetail(cell: cell)
            }
            
        }
        // Set Selected Comic
        if withSections {
            let comics = self.comics[indexPath.section]
            if let comic = comics?[indexPath.row] {
                self.comicSelected = comic
            }
        } else {
            let comics = self.comicsByDate[indexPath.row]
            print(comics.episodeTitle)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let cellHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ComicCollectionHeader", for: indexPath) as? ComicCollectionHeader {
                
                if let comicSection = self.comics[indexPath.section] {
                    let comic = comicSection[indexPath.row]
                    cellHeader.loadSectionHeader(comic: comic)
                    return cellHeader
                } else {
                    return UICollectionReusableView()
                }
            }
        }
        return UICollectionReusableView()
    }
    
    func goToComicDetail(cell: ComicCollectionCell) {
        if let libraryDetail = self.storyboard?.instantiateViewController(withIdentifier: "LibraryDetailVC") as? LibraryDetailVC {
                if let comic = cell.comic {
                    libraryDetail.initData(comic: comic)
                    self.present(libraryDetail, animated: true)
                }
            
        }
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

