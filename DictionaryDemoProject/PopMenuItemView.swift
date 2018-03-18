//
//  PopMenuItemView.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 5/29/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit

protocol PopMenuItemViewProtocol{
    func favorlanBtnClck(item:String, popview:PopMenuItemView)
}

class PopMenuItemView: UIView {
    
    
    @IBOutlet weak var favOrworDayBtn: UIButton!
    var favorlagDelegate:PopMenuItemViewProtocol?
    @IBAction func fovouriteBtnPress(_ sender: UIButton) {
        
        print(sender.titleLabel!.text!)
        
        favorlagDelegate?.favorlanBtnClck(item: "favourite", popview:self)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    @IBAction func LanguageBtnPress(_ sender: UIButton) {
        
        favorlagDelegate?.favorlanBtnClck(item: "language",popview:self)
    }

}
