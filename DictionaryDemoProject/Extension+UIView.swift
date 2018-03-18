//
//  Extension+UIView.swift
//  DictionaryDemoProject
//
//  Created by Morshed Alam on 5/7/17.
//  Copyright © 2017 Morshed Alam. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIView {
    
    func traverseSubviewForViewOfKind(kind: AnyClass) -> UIView? {
        var matchingView: UIView?
        
        for aSubview in subviews {
            if type(of: aSubview) == kind {
                matchingView = aSubview
                return matchingView
            } else {
                if let matchingView = aSubview.traverseSubviewForViewOfKind(kind: kind) {
                    return matchingView
                }
            }
        }
        
        return matchingView
    }
}

extension Array{
    mutating func appendAtBeginning(newItem : Element){
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
}
//            if let mySegmentedControl:UISegmentedControl = searchController?.searchBar.traverseSubviewForViewOfKind(kind: UISegmentedControl.self) as! UISegmentedControl? {
//
//                let viewWidth = self.view.frame.size.width
//                var multiplier:CGFloat = 0.0
//
//                switch viewWidth
//                {
//                case 414:
//                    multiplier = 0.4
//
//                case 357:
//                    multiplier = 0.5
//                case 320:
//                   multiplier = 0.6
//                default:
//                    multiplier = 0.5
//                }
//                var segmentedControlFrame = mySegmentedControl.frame
//                segmentedControlFrame.size.width = 200//self.view.bounds.width*0.7
//
//                mySegmentedControl.frame = segmentedControlFrame
//                mySegmentedControl.frame.origin.x = self.view.center.x * multiplier
//
//                  //segmentedControlFrame.size.width/1.8
//
//            }
