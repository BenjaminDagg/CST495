//
//  UserPreferences.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/25/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import Foundation

class UserPreferences : NSObject {
    
    static let shared : UserPreferences  = {
        
        let instance = UserPreferences()
        
        return instance
        
    }()
    
    override init() {
        super.init()
    }
    
    // MARK: - Common
    static func getBoolPreference(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func setBoolPreference(_ key: String, newValue: Bool) {
        UserDefaults.standard.set(newValue, forKey: key)
        //NotificationCenter.default.post(name: .didUpdatePreferences, object: nil)
    }
    
    // MARK: - Defaults
    static func registerDefaults() {
        // First get custom defaults plist to get defaults for any user default
        if  let path = Bundle.main.path(forResource: "DefaultPreferences", ofType: "plist"){
            
        
        let defaultPrefs = NSDictionary(contentsOfFile: path) as! [String: AnyObject]
        
        UserDefaults.standard.register(defaults: defaultPrefs)
        
        // Then override with any defaults set in the Root.plist file
        if let settingsURL = Bundle.main.url(forResource: "Root", withExtension: "plist", subdirectory: "Settings.bundle"),
            let settingsPlist = NSDictionary(contentsOf: settingsURL),
            let preferences = settingsPlist["PreferenceSpecifiers"] as? [NSDictionary] {
            
            // Loop through the preferences, setting each default
            for prefSpecification in preferences {
                if let key = prefSpecification["Key"] as? String, let value = prefSpecification["DefaultValue"] {
                    //If key doesn't exists in userDefaults then register it, else keep original value
                    if UserDefaults.standard.value(forKey: key) == nil {
                        UserDefaults.standard.set(value, forKey: key)
                        print("registerDefaultsFromSettingsBundle: Set following to UserDefaults - (key: \(key), value: \(value), type: \(type(of: value)))")
                    }
                }
            }
        } else {
            print("registerDefaultsFromSettingsBundle: Could not find Settings.bundle")
        }
        }
    }
    
    static func resetDefaults() {
        let appDomain = Bundle.main.bundleIdentifier!
        let defaults = UserDefaults.standard
        defaults.removePersistentDomain(forName: appDomain)
    }

    
    var tempUnits:Bool? {
        
        get {
            return UserDefaults.standard.value(forKey: "tempUnits") as? Bool
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "tempUnits")
        }
        
    }
    
    var savedCities:[City]? {
        get {
            return UserDefaults.standard.value(forKey: "savedCities") as? [City]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "savedCities")
        }
    }
    
}
