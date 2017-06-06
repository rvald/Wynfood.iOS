//
//  Reachability.swift
//  NetworkReachabilityTutorial
//
//  Created by craftman on 2/27/17.
//  Copyright © 2017 craftman. All rights reserved.
//

import Foundation
import SystemConfiguration

let ReachabilityDidChangeNotificationName = "ReachabilityDidChangeNotification"

enum ReachabilityStatus {
    
    case NotReachable
    case ReachableViaWifi
    case ReachableViaWWAN
    
}

class Reachability: NSObject {
    
    // MARK: - Properties
    private var networkReachability: SCNetworkReachability?
    private var notifying = false
    
    private var flags: SCNetworkReachabilityFlags {
        
        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        
        if let reachability = networkReachability, withUnsafeMutablePointer(to: &flags, { SCNetworkReachabilityGetFlags(reachability, UnsafeMutablePointer($0)) }) == true {
            
            return flags
        
        } else {
            
            return []
        }
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        if flags.contains(.reachable) == false {
            
            // the target host is not reachable
            return .NotReachable
        
        } else if flags.contains(.isWWAN) == true {
            
            // WWAN connections are OK if the calling application is using the CFNetwork APIs
            return .ReachableViaWWAN
        
        } else if flags.contains(.connectionRequired) == false {
            
            // If the target host is reachable and no connection is required, then Wifi is working
            return .ReachableViaWifi
        
        } else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            
            // the connection is on-demand (or on traffic) 
            // if the calling application is using the CFSocketStream or higher APIs and
            // no user intervention is required
            return .ReachableViaWifi
        
        } else {
            
            return .NotReachable
        }
    }
    
    var isReachable: Bool {
        
        switch currentReachabilityStatus {
            
        case .NotReachable:
            return false
        
        case .ReachableViaWifi, .ReachableViaWWAN:
            return true
            
        }
    }
    
    // MARK: - Initialization
    init?(hostAddress: sockaddr_in) {
        
        var address = hostAddress
        
        guard let defaultRouteReachability = withUnsafePointer(to: &address, { $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, $0)
            
            }
            
        }) else {
            
            return nil
        }
        
        networkReachability = defaultRouteReachability
        
        super.init()
        
        if networkReachability == nil {
            
            return nil
            
        }
    }
    
    // MARK: - Methods
    static func networkReachabilityForInternetConnection() -> Reachability? {
        
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        return Reachability(hostAddress: zeroAddress)
    }
    
    static func networkReachabilityForLocalWifi() -> Reachability? {
        
        var localWifiAddress = sockaddr_in()
        localWifiAddress.sin_len = UInt8(MemoryLayout.size(ofValue: localWifiAddress))
        localWifiAddress.sin_family = sa_family_t(AF_INET)
        localWifiAddress.sin_addr.s_addr = 0xA9FE0000
        
        return Reachability(hostAddress: localWifiAddress)
    }
    
    func startNotifier() -> Bool {
        
        guard notifying == false else {
            return false
        }
        
        var context = SCNetworkReachabilityContext()
        
        context.info = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        
        guard let reachability = networkReachability, SCNetworkReachabilitySetCallback(reachability, { (networkReachability, flags, info) in
            
            if let currentInfo = info {
                
                let infoObject = Unmanaged<AnyObject>.fromOpaque(currentInfo).takeUnretainedValue()
                
                if infoObject is Reachability {
                    
                    let networkReachability = infoObject as! Reachability
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: ReachabilityDidChangeNotificationName), object: networkReachability)
                }
            }
            
        }, &context) == true else { return false }
        
        guard SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue) == true else { return false }
        
        notifying = true
        return notifying
    }
    
    func stopNotifier() {
        
        if let reachability = networkReachability, notifying == true {
            
            SCNetworkReachabilityUnscheduleFromRunLoop(reachability, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode as! CFString)
            notifying = false
        }
    }
    
    deinit {
        
        stopNotifier()
    }
    
}
