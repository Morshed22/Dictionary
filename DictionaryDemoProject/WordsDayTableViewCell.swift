//
//  WordsDayTableViewCell.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 4/27/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit

class WordsDayTableViewCell: UITableViewCell {

    
    //var setCornerRadius = false
    
    @IBOutlet weak var wordLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        if self.setCornerRadius == true{
//        self.roundCorners([.bottomLeft,.bottomRight], 8.0)
//        }
//    }
    
    
}
