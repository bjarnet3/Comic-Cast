//
//  ComicCollectionHeader.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 21/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class ComicCollectionHeader: UICollectionReusableView {
    
    // Comic Brand / Logo, Name and Description
    // ----------------------------------------
    @IBOutlet weak var comicLogoImage: UIImageView!
    @IBOutlet weak var comicNameLbl: UILabel!
    @IBOutlet weak var comicDescLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.comicLogoImage.layer.cornerRadius = 10.0
        self.comicLogoImage.layer.borderWidth = 0.5
        self.comicLogoImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    public func loadSectionHeader(comic: Comic) {
        if let urlString = comic.logoURL {
            if !comic.local {
                self.comicLogoImage.loadImageUsingCacheWith(urlString: urlString)
            } else {
                self.comicLogoImage.image = UIImage(named: urlString)
            }
        }
        self.comicNameLbl.text = comic.comicName ?? "No Title"
        self.comicDescLbl.text = comic.imgURL ?? "No Alt Message"
    }
    
}
