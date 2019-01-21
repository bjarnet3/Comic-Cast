//
//  ComicCollectionHeader.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 21/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class ComicCollectionHeader: UICollectionReusableView {
    
    @IBOutlet weak var comicLogoImage: UIImageView!
    @IBOutlet weak var comicNameLbl: UILabel!
    @IBOutlet weak var comicUrlLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func loadSectionHeader(comic: Comic) {
        if let urlString = comic.logo {
            if !comic.local {
                self.comicLogoImage.loadImageUsingCacheWith(urlString: urlString)
            } else {
                self.comicLogoImage.image = UIImage(named: urlString)
            }
        }
        self.comicNameLbl.text = comic.comicName ?? "No Title"
        self.comicUrlLbl.text = comic.img ?? "No Alt Message"
    }
    
}
