//
//  SettingsViewController.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/25/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var unitsSwitch: UISwitch!
    
    var units:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //try to get users saved units if there is one
        if let tempUnits = UserPreferences.shared.tempUnits {
            self.units = tempUnits
        }
        unitsSwitch.setOn(units, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //try to get users saved units if there is one
        if let tempUnits = UserPreferences.shared.tempUnits {
            self.units = tempUnits
        }
        unitsSwitch.setOn(units, animated: true)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UserPreferences.shared.tempUnits = self.units
        
    }
    
    @IBAction func unitsSwitchPressed(sender: UISwitch) {
        print("switch pressed")
        units = unitsSwitch.isOn
        UserPreferences.shared.tempUnits = self.units
        
    }
    
}
