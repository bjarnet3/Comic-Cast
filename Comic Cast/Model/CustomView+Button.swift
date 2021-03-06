//
//  CustomView+Button.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 21/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
    }
}

class CustomView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.roundCorners(radius: 17.5)
        self.layer.addShadow()
    }
}

class CustomViewShaddow: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.roundCorners(radius: 22.5)
        self.layer.addShadow()
    }
}

class CustomImageView: UIImageView {
    
    func setupView() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = WHITE_SOLID.cgColor
        
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.autoresizesSubviews = true
        
        self.setupView()
    }
    
}
