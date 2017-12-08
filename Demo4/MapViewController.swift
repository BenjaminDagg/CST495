//
//  MapViewController.swift
//  Demo4
//
//  Created by Benjamin Dagg on 11/27/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    var userLocations:[Location] = []
    var locationIndex = 0
    var delegate: LocationTransferDelegate?
    var selectedLocation:Location?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        //add right nav btn to cycle through locations
        let nextBtn = UIBarButtonItem(title: "Next Location", style: .plain, target: self, action: #selector(centerMapOnLocation))
        self.navigationItem.rightBarButtonItem = nextBtn
        
        /*
        Add tap gesture recognizer to map so when
        user taps on location of map it detects where
        they pressed
        */
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addAnnotationWhereTapped))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        
        
    }
    
    
    
    /*
    When view appears draw all passed in Locatin annotations on the map. If user passed in a selected location then move map over that location
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        //add all of users locations as annotations on the map
        for i in 0..<self.userLocations.count{
            print(self.userLocations[i].title)
            mapView.addAnnotation(self.userLocations[i])
        }
        
        //show titles for every annotation
        for i in 0..<mapView.annotations.count {
            mapView.selectAnnotation(mapView.annotations[i], animated: true)
        }
        
        //move map to custom location if exists
        if let location = self.selectedLocation {
            showSelectedLocation(location)
        }
    }
    
    
    /*
    When user clicks on map, gesture recognizer converts the tap coordinates to coordinates on the map and adds an annotation to the map. Then it adds the new location to the map
    */
    func addAnnotationWhereTapped(gestureRecognizer: UILongPressGestureRecognizer) {
        print("tapped map")
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        let annotation = Location()
        let alert = UIAlertController(title: "Add Location", message: "Enter a name for your location.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in
         textField.text = "Enter name"
        })
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            annotation.title = textField?.text
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            self.userLocations.append(annotation)
            self.delegate?.addLocation(location: annotation)
            
            //select added annotation
            for i in 0..<self.mapView.annotations.count {
                if let title = self.mapView.annotations[i].title {
                    if let annotationTitle = annotation.title {
                        if title == annotationTitle {
                            self.mapView.selectAnnotation(self.mapView.annotations[i], animated: true)
                        }
                    }
                }
            }
        }))
        self.present(alert,animated: true,completion:nil)
        
    }
    
    
    
    /*
    If user passed in a location to view then move the map over that location before the view appears
    */
    func showSelectedLocation(_ location:Location) {
        
        mapView.setCenter(location.coordinate, animated: true)
        mapView.selectAnnotation(location, animated: true)
    }
    
    
    
    /*
    When 'Next Locatin' button picked, iterate through the users location to move map over the next location in the list
    */
    func centerMapOnLocation(location: Location?){
        
            //get next index in list
            let index = (self.locationIndex) % self.userLocations.count
            //move map to location
            let targetLocation = self.userLocations[index]
            mapView.setCenter(targetLocation.coordinate, animated: true)
            mapView.selectAnnotation(targetLocation, animated: true)
            //increment
            self.locationIndex += 1
        
    }
    
    
    
    
    
}
/*
//extension to update the locations array in the table view controller with the new locations
extension MapViewController {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? CitiesTableViewController {
            controller.locations = self.userLocations
            controller.tableView.reloadData()
        }
    }
}
*/
