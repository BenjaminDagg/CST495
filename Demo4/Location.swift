//
//  Location.swift
//  Demo4
//
//  Created by Benjamin Dagg on 11/27/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

/*
 Custom mapkit MKAnnotation object. Holds name of location, coordinates and a unique id. Used by map view to draw annotation objects
 */

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
    
    var title:String?
    var coordinate: CLLocationCoordinate2D
    var id:Int
    
    //default constructor
    override init(){
        self.title = ""
        self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        self.id = AutoIncrement.getAutoIncrement()
    }
    
    //MKAnnotation constructor
    init(name:String, coordinate: CLLocationCoordinate2D){
        self.title = name
        self.coordinate = coordinate
        self.id = AutoIncrement.getAutoIncrement()
        super.init()
    }
    
    //another MKannotation contrsutor
    init(name:String, coordinate: CLLocationCoordinate2D, id: Int){
        self.title = name
        self.coordinate = coordinate
        self.id = id
        super.init()
    }
}
