//
//  NetworkStatusListener.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/23/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import Foundation

public protocol NetworkStatusListener : class {
    
    
    
    func networkStatusDidChange(status: Reachability.NetworkStatus)
    
}
