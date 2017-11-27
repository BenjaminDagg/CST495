//
//  ReachabilityManager.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/23/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import Reachability
import ReachabilitySwift

class ReachabilityManager : NSObject {
    
    static let shared = ReachabilityManager()
    
    
    var isNetworkAbailable: Bool {
        return reachabilityStatus != .notReachable
    }
    
    
    
    var listeners = [NetworkStatusListener]()
    
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    var reachability = Reachability()
    
    func reachabilityChanged(notification: Notification) {
        print("in reachability manager reachability changed")
        var reachability = notification.object as! Reachability
        
        switch reachability.currentReachabilityStatus {
        case .notReachable:
            print("not reachable")
        case .reachableViaWiFi:
            print("wifi reachable")
        case .reachableViaWWAN:
            print("WAN reachable")
        }
        
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }
        
    }
    
    func startMonitoring() {
        print("Started monitoring..")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: self.reachability)
        
        do {
            try reachability?.startNotifier()
        }catch {
            print("Could not start reachability notifier")
        }
    }
    
    func stopMonitoring(){
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }
    
    
    func addListener(listener: NetworkStatusListener){
        listeners.append(listener)
    }
    
    func removeListener(listener: NetworkStatusListener){
        listeners = listeners.filter{ $0 !== listener}
    }
    
}
