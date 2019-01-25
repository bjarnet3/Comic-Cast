//
//  DetailLibraryVC.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 24/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class LibraryDetailVC: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLbl: UILabel!
    @IBOutlet weak var detailTitleLbl: UILabel!
    @IBOutlet weak var detailAltLbl: UILabel!
    @IBOutlet weak var detailVote: UILabel!
    @IBOutlet weak var detailFav: UIButton!
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: {
            print("dismiss complete")
        })
    }
    @IBAction func setFavorite(_ sender: Any) {
        self.favorite = !self.favorite
    }
    
    public var comic: Comic?
    private var favorite = false {
        didSet {
            let color = favorite == true ? UIColor.red : UIColor.lightGray
            self.detailFav.alpha = favorite == true ? 0.9 : 0.7
            self.detailFav.titleLabel?.textColor = color
            self.detailFav.setTitleColor(color, for: .normal)
            self.comic?.fav = favorite
        }
    }
    
    func initData(comic: Comic) {
        self.comic = comic
    }
    
    // MARK: - ViewDidLoad, ViewWillLoad etc...
    // ----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let comic = self.comic {
            guard let comicUrl = comic.comicURL else { return }
            detailImageView.loadImageUsingCacheWith(urlString: (comicUrl))
            guard let comicName = comic.comicName else { return }
            self.detailNameLbl.text = comicName
            guard let comicTitle = comic.comicTitle else { return }
            self.detailTitleLbl.text = comicTitle
            guard let comicInfo = comic.comicInfo else { return }
            self.detailAltLbl.text = comicInfo
            let episodeVote = comic.comicVote
            self.detailVote.text = String(episodeVote)
            favorite = comic.fav
        }
        
        
    }
    
    
}
