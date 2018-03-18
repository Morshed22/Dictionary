//
//  WordOfDayHeader.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 5/31/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit

class WordOfDayHeader : UIView{

    @IBOutlet weak var titleLabel: UILabel!
    
  
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.topRight,.topLeft], 8.0)
    }
    
}

extension UIView {
    func roundCorners(_ corner: UIRectCorner,_ radii: CGFloat) {
        self.layoutIfNeeded()
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.layer.bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii)).cgPath
        
        self.layer.mask = maskLayer
        layer.masksToBounds = true
    }
}
