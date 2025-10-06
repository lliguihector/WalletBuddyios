//
//  DeviceManager.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/3/25.
//
import UIKit
import Foundation


class DeviceManager{
    static let shared = DeviceManager()
    private init(){}
    //MARK: - Dependencies
    private let apiService = ApiService.shared
    
    func registerDeviceWithBackend(){
        
        
        guard let token = UserDefaults.standard.string(forKey: "apnsToken")else{
            print("No APNs token available")
            return
        }
        
        let device = Device(
            
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            apnsToken: token,
            platform: "iOS",
            model: UIDevice.current.model,
            systemVersion: UIDevice.current.systemVersion,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            lastUsedAt: Date()
            
            
            
        )
        
        apiService.sendDeviceInfoToAPI(device: device){result in
            switch result{
            case .success:
                print("Device info successfully sent to backend")
            case.failure(let error):
                print("Failed to send device info to backend: \(error)")
            }
            
        }
    }
    
        
        
        
        
        
    
    
    
    
    
    
}
