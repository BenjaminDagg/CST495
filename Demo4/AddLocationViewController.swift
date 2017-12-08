//
//  AddLocationViewController.swift
//  Demo4
//
//  Created by Benjamin Dagg on 11/30/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Alamofire
import MapKit

/*
 Interface to add a new location to the table view controller. User enters a location city,state,country,etc. and uses Google Maps API to get the coordinates of that locatoin. Finally calls the delegate method of LocationTransfer to add the new location to the list
 */


class AddLocationViewController: UIViewController {
    
    let apiKey = "AIzaSyCrVOYY6IkDCou59ZdaW1Q53zhkQm6q-vw"
    
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    
    var gotValidResponse:Bool = false
    var delegate: LocationTransferDelegate?
    var lat:Double = 0.0
    var long:Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add function to submit button to lookup location
        self.submitBtn.addTarget(self, action: #selector(submitBtnPressed), for: .touchUpInside)
        
        //add done btn to right of nav bar
        let doneBtn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveLocationAndSegue))
        self.navigationItem.rightBarButtonItem = doneBtn
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //hide error and lat and long fields when view appears
        self.errorLabel.isHidden = true
        self.latLabel.isHidden = true
        self.longLabel.isHidden = true
    }
    
    
    
    //checks if user entered location before trying to lookup location
    func formIsValid() -> Bool {
        
        if (self.locationField.text?.isEmpty)! || self.locationField.text == "" {
            return false
        }
        else {
            return true
        }
        
    }
    
    
    
    /*
    When submit button pressed check if user entered a location. If not give an error and return. If they did then lookup given location
    */
    func submitBtnPressed(sender: UIButton) {
        
        //form is valid (user entered a value
        if formIsValid() == true {
            //hide error if it is showing
            self.errorLabel.isHidden = false
            
            //take whitespace out of entered location
            let location = self.locationField.text
            let formatedLocation = location?.replacingOccurrences(of: " ", with: "")
            
            //lookup location in api
            getCoordinates(location: formatedLocation!)
        }
        //user didnt enter a location so return and show wrror
        else {
            self.errorLabel.text = "Must enter a location"
            self.errorLabel.isHidden = false
        }
        
    }
    
    
    
    /*
    Takes string of a city,state,country,landmark
    and looks up location in google maps api to get its
    longitute and latitude
    */
    func getCoordinates(location:String) {
        
        
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?address=\(location)&key=\(apiKey)", method: .post)
            .responseJSON(queue: .main) { response in
            
                guard  response.result.isSuccess else {
                    print("error1")
                    
                    self.gotValidResponse = false
                    return
                }
                guard let responseJSON = response.result.value as? [String: AnyObject] else {
                    print("error 2")
                   self.gotValidResponse = false
                    return
                }
                
                if let results = responseJSON["results"] as? [[String: AnyObject]] {
                    if results.count > 0 {
                        let result = results[0]
                        let geometry = result["geometry"] as? [String: AnyObject]
                        if let geometry = geometry {
                            let location = geometry["location"] as? [String:Double]
                            if let location = location {
                                let lat = location["lat"]
                                let long = location["lng"]
                                guard let latitude = lat, let longitude = long else {
                                    return
                                }
                                print("lat = \(latitude) long = \(longitude)")
                                self.lat = latitude
                                self.long = longitude
                                DispatchQueue.main.async {
                                    self.latLabel.text = "lat: \(String(latitude))"
                                    self.latLabel.isHidden = false
                                    self.longLabel.text = "long: \(String(longitude))"
                                    self.longLabel.isHidden = false
                                    self.errorLabel.isHidden = true
                                    self.gotValidResponse = true
                                    
                                }
                            }
                        }
                    }
                }
        }
        gotValidResponse = false
        
    }
    
    
    /*
    Checks if user entered a value and got a valid response. If not then give an error and return. If valid then save the new location to the users list and return to main view controller
    */
    func saveLocationAndSegue(sender: UIBarButtonItem) {
        
        if formIsValid() == true {
            print("lat text = \(self.latLabel.text!)")
            if let name = self.locationField.text {
                let coordinate = CLLocationCoordinate2D(latitude: self.lat, longitude: self.long)
                 print("self.long = \(self.long)")
                let newLocation = Location(name: name, coordinate: coordinate)
                self.delegate?.addLocation(location: newLocation)
                self.performSegue(withIdentifier: "unwindToTableVC", sender: self)
            }else {
                print("if let name failed")
            }
            
        }
        //form was invalid 
        else {
            var alert = UIAlertController(title: "Error", message: "Must enter valid location to continue", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            }))
            
            present(alert, animated: true, completion: nil)
        }
        
    }
    
}

