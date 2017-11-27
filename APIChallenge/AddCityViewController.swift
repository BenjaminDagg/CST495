//
//  AddCityViewController.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/18/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit

class AddCityViewController:UIViewController {
    
    
    
    @IBOutlet weak var cityNameField: UITextField!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "UnwindToListSegue" {
            if (cityNameField.text?.isEmpty)! {
                return false
            }
            else {
                return true
            }
        }
        
        return true
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindToListSegue" {
            if let destinationVC = segue.destination as? CitiesTableViewController {
                let newCity = City(name: cityNameField.text!, temp: 0.0, clouds: 0.0, rain:0.0)
                    destinationVC.cities.append(newCity)
                    destinationVC.getAllTemps()
                    destinationVC.tableView.reloadData()
            }
            
        }
    }
    
}
