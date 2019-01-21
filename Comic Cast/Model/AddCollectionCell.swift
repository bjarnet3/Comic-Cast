//
//  ComicCollectionCell.swift
//  Comic Cast
//
//  Created by Bjarne Tvedten on 20/01/2019.
//  Copyright © 2019 Digital Mood. All rights reserved.
//

import UIKit

class AddCollectionCell: UICollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 15
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // isSelected
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                //This block will be executed whenever the cell’s   selection state is set to true (i.e For the selected cell)
                
            } else {
                //This block will be executed whenever the cell’s selection state is set to false (i.e For the rest of the cells)
            }
        }
    }
    
    // Highligh Animation
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.48, initialSpringVelocity: 0.32, options: .curveEaseInOut, animations: { () in
                    
                    self.alpha = 0.85
                    
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    hapticButton(.selection)
                })
            } else {
                UIView.animate(withDuration: 0.45, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.4, options: .curveEaseOut, animations: { () in
                    self.alpha = 1.0
                    
                    self.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
                })
            }
        }
    }
}
