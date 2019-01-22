//
//  SettingsTableViewCell.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 21/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    func setupView(settings: Settings) {
        self.settingsImage.image = UIImage(named: settings.imageName)
        self.titleLbl.text = settings.title
        self.descriptionLbl.text = settings.info
    }
}
