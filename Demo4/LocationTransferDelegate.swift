//
//  LocationTransferDelegate.swift
//  Demo4
//
//  Created by Benjamin Dagg on 11/29/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

/*
 Protocol to add locations to the table view controller from other view controllers.
 */

import UIKit

protocol LocationTransferDelegate: class {
    
    /*
    Parameter is a location object to add to the location array in the table view controller. Implemented in CitiesTableViewController. Adds new location to list, updates table view, and saves to core data
    */
    func addLocation(location:Location);
}
