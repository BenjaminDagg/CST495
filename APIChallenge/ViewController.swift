//
//  ViewController.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/16/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit
import Reachability
import Alamofire
import SwiftKeychainWrapper



class TempAPI {
    
    static var result:Float = 0
    
    
    static func getData(name:String, handler: @escaping (WeatherResult)->Void) {
        
        let apiKey = KeychainWrapper.standard.string(forKey: "apiKey")
        
        print("in api class apiKey = \(String(describing: apiKey!))")
        
        
        //json call to api
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?APPID=\(apiKey!)&q=\(name)&units=imperial", method: .get,
                          parameters:["APPID":apiKey!])
            .responseJSON(queue: .main) { response in
                guard  response.result.isSuccess else {
                    print("error1")
                    return
                }
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    print("error 2")
                    return
                }
                
                //get the temp from the JSOn resonse
                let temp:Float = responseJSON["main"]?["temp"] as! Float
                //get clouds
                let clouds:Float = responseJSON["clouds"]?["all"] as! Float
                //get rain
                var rain:Float = 0.0
                if let testRain = responseJSON["rain"]?["3h"] as? Float {
                    rain = testRain
                }
                let result = WeatherResult(temp: temp, clouds: clouds, rain: rain)
                handler(result)
            }
        
    }


}

