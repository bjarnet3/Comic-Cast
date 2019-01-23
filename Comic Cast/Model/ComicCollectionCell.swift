//
//  ComicCollectionCell.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class ComicCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var comicImageView: UIImageView!
    @IBOutlet weak var comicTitleLbl: UILabel!
    @IBOutlet weak var comicAltLbl: UILabel!
    @IBOutlet weak var comicFav: UIButton!
    @IBOutlet weak var episodeVote: UILabel!
    
    public var comic: Comic?
    public var selectMultipleItems = false
    public var cellImageLoaded = false
    
    public enum Direction {
        case enter
        case exit
    }
    
    public var favorite = false {
        didSet {
            self.comic?.fav = favorite
            
            let color = favorite == true ? UIColor.red : UIColor.lightGray
            self.comicFav.alpha = favorite == true ? 0.9 : 0.7
            self.comicFav.titleLabel?.textColor = color
            self.comicFav.setTitleColor(color, for: .normal)
            
            self.layoutIfNeeded()
            print("layutIfNeeded")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupShaddow()
        setupLayer()
    }

    private func setupShaddow() {
        contentView.layer.cornerRadius = 18.0
        contentView.layer.borderWidth = 0.6
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.4, height: 2.2)
        layer.shadowRadius = 5.5
        layer.shadowOpacity = 0.45
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
    }
    
    private func setupLayer() {
        self.comicFav.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.comicFav.layer.cornerRadius = 10.0
        
        /*
        self.episodeVote.layer.maskedCorners = [.layerMaxXMinYCorner]
        self.episodeVote.layer.cornerRadius = 10.0
        
        self.comicTitleLbl.layer.maskedCorners = [.layerMinXMinYCorner]
        self.comicTitleLbl.layer.cornerRadius = 10.0
        */
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        self.favorite = !favorite
    }
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected /* && selectMultipleItems */ {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.48, initialSpringVelocity: 0.32, options: .curveEaseInOut, animations: { () in
                    
                    self.alpha = 0.65
                })
            } else {
                UIView.animate(withDuration: 0.40, delay: 0.0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.30, options: .curveEaseOut, animations: { () in
                    
                    self.alpha = 1.0
                })
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.48, initialSpringVelocity: 0.32, options: .curveEaseInOut, animations: { () in
                    
                    self.alpha = 1.0
                    self.comicImageView.alpha = 1.0
                    self.transform = CGAffineTransform(scaleX: 1.16, y: 1.16)
                    hapticButton(.selection)
                })
            } else {
                UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: { () in
                    
                    self.alpha = 0.85
                    self.comicImageView.alpha = 0.85
                    self.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
                })
            }
        }
    }
    
    func animateView( direction: Direction) {
        if direction == .enter {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        } else {
            self.alpha = 1
            self.comicImageView.alpha = 0.85
            self.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
            // self.contentView.alpha = 1
            // self.contentView.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        }
    }
    
    public func loadCell(comic: Comic, animated: Bool = true) {
        self.cellImageLoaded = false
        if let urlString = comic.imgURL {
            if !comic.local && animated {
                
                self.animateView(direction: .enter)
                let random = Double(arc4random_uniform(UInt32(900))) / 4200
                self.comicImageView.loadImageUsingCacheWith(urlString: urlString, completion: {
                    
                    UIView.animate(withDuration: 0.6, delay: random, usingSpringWithDamping: 0.70, initialSpringVelocity: 0.3, options: .curveEaseOut, animations: {
                        self.animateView(direction: .exit)
                        
                        self.comic = comic
                        self.favorite = comic.fav
                        let title = comic.episodeTitle ?? "No Title"
                        let info = comic.episodeInfo ?? "No Info"
                        let votes = comic.episodeVote
                        self.comicTitleLbl.text = "  \(title)"
                        self.comicAltLbl.text = "   \(info)"
                        self.episodeVote.text = String(votes)
                    })
                })
            } else {
                self.comicImageView.image = UIImage(named: urlString)
                self.comic = comic
                self.favorite = comic.fav
                self.comicTitleLbl.text = comic.episodeTitle ?? "No Comic Title"
                self.comicAltLbl.text = comic.episodeInfo ?? "No Alt Text"
                self.episodeVote.text = String(comic.episodeVote)
            }
            self.cellImageLoaded = true
        }
        
    }
}
