//
//  Crime.swift
//  Challenge3
//
//  Created by Benjamin Dagg on 10/8/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit

class Crime {
    
    var type: String
    var location: String
    var desc:String
    var date: Date
    var satus: Bool
    
    
    
    init(type:String,location:String,description:String){
        self.type = type
        self.location = location
        self.desc = description
        self.date = Date()
        self.satus = false
    }
    
    
    
}
