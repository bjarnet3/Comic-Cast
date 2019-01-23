//
//  FrostyView.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

// FrostyView is a UIView SubClass
// -------------------------------
class FrostyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        setEffect()
    }
}

// Frost effect on FrostView
// -------------------------
extension FrostyView {
    func setEffect(blurEffect: UIBlurEffect.Style = .light) {
        for view in subviews {
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
        
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: blurEffect))
        frost.frame = bounds
        frost.autoresizingMask = .flexibleWidth
        
        self.layer.borderWidth = 0.4
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        insertSubview(frost, at: 0)
    }
}

// FrostyCornerView is a cornered FrostView
// ----------------------------------------
class FrostyCornerView: FrostyView {
    
    // Inspectable in Xcode
    // --------------------
    @IBInspectable var customCornerRadius: CGFloat = 20.0
    @IBInspectable var customBlurEffect: UIBlurEffect.Style = .light
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = customCornerRadius
        self.layer.borderWidth = 0.2
        self.layer.borderColor = WHITE_ALPHA.cgColor
        setEffect(blurEffect: customBlurEffect)
    }
}

class FrostyTabBar: UITabBar {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setEffect()
    }
}

extension FrostyTabBar {
    func setEffect(blurEffect: UIBlurEffect.Style = .extraLight) {
        for view in subviews {
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: blurEffect))
        frost.frame = bounds
        frost.autoresizingMask = .flexibleWidth
        
        insertSubview(frost, at: 0)
    }
}


