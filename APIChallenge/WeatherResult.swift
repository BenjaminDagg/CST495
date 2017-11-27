//
//  WeatherResult.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/23/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import Foundation

class WeatherResult {
    
    var temp:Float
    var clouds:Float
    var rain:Float
    
    init(temp:Float, clouds:Float,rain:Float){
        self.temp = temp
        self.clouds = clouds
        self.rain = rain
    }
    
}
