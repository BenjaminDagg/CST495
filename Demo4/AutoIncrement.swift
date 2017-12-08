//
//  AutoIncrement.swift
//  Demo4
//
//  Created by Benjamin Dagg on 11/29/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

/*
 Static class to keep track in user defaults of the last used unique id number that was assigned to a location. When new location is created, increment the number and give it to the new object
 */

import Foundation

class AutoIncrement {
    
    //increment the id if it exists. If doesnt exist create new one at 0
    static func setAutoIncrement() {
        if var num = UserDefaults.standard.integer(forKey: "inc") as? Int {
            num += 1
            UserDefaults.standard.set(num, forKey: "inc")
            
        }else{
            UserDefaults.standard.set(0, forKey: "inc")
        }
    }
    
    //get the current value of the increment
    static func getAutoIncrement() -> Int {
        setAutoIncrement()
        return UserDefaults.standard.integer(forKey: "inc")
    }
    
}
