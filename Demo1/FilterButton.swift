//
//  FilterButton.swift
//  Demo1
//
//  Created by Benjamin Dagg on 9/3/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit
import CoreImage

class FilterButton : UIButton{
    
    var buttonTitle:String
    var filterString:String
    
    required init(filterString: String, buttonTitle:String){
        self.filterString = filterString
        self.buttonTitle = buttonTitle
        super.init(frame: .zero)
        
        backgroundColor = UIColor.lightGray
        setTitleColor(UIColor.black, for: UIControlState.normal)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
