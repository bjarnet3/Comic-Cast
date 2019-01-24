//
//  DetailLibraryVC.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 24/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class LibraryDetailVC: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: {
            print("dismiss complete")
        })
    }
    
    var comic: Comic?
    var urlString: String?
    
    func initData(comic: Comic) {
        self.comic = comic
        guard let imageURL = comic.imgURL else { return }
        
    }
    
    // MARK: - ViewDidLoad, ViewWillLoad etc...
    // ----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.loadImageUsingCacheWith(urlString: (comic?.imgURL)!)
    }
    
    
}
