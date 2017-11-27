//
//  City.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/18/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit

class City : NSObject, NSCoding  {
    
    var name:String
    var temp:Float
    var clouds:Float
    var rain:Float
    
    init(name: String, temp: Float, clouds:Float, rain:Float) {
        self.name = name
        self.temp = temp
        self.clouds = clouds
        self.rain = rain
    }
    
    
    //NSCoding required function to encode my properties
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name,forKey:"name")
    }
    
    //NSCoding initializer to retrieve the encoded properties
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey:"name") as! String
        temp = 0.0
        clouds = 0
        rain = 0
        super.init()
    }
    
}
