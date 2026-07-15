//
//  DeviceInfo.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/2/26.
//

import UIKit
import Darwin

struct DeviceInfo{
    
    static var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static var platform:String{
        "ios"
    }
    
    static var systemVersion:String{
        UIDevice.current.systemVersion
    }
    
    static var deviceModel: String {
        return UIDevice.current.model
    }
    
    
    
}
