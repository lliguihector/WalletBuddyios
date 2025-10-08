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
    
    //MARK: -- Properties
    private let pendingKey = "pendingDeviceUpload"
    private let  tokenKey = "apnsTokenKey"
    
    
    
    var currentToken: String?{
       return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    
    func saveToken(_ token: String){
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    
    
    
    func registerDeviceWithBackend(token:String){
        
  print("Regestering device token with backedn....")
        let device = Device(
            
            deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "",
            apnsToken: token,
            platform: "iOS",
            model: UIDevice.current.model,
            systemVersion: UIDevice.current.systemVersion,
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            lastUsedAt: Date()
            
        
            
        )
        attemptUpload(device: device)
   
    }
    
      //Attempt to post device data to backend
    private func attemptUpload(device: Device){

        apiService.sendDeviceInfoToAPI(device: device){result in
            switch result{
            case .success:
                print("Device info successfully sent to backend")
                self.clearPending()
            case.failure(let error):
                print("Failed to send device info to backend: \(error)")
                
                self.savePending(device: device)
            }
            
        }
        

        
    }
        
        
        
    
    //MARK: -- Pending Device
    
    
    //Save pending Device Data in UserDefaults
    private func savePending(device: Device){
        if let data = try? JSONEncoder().encode(device){
            UserDefaults.standard.set(data, forKey: pendingKey)
        }
    }
    
    //Clear any saved pending 
    private func clearPending(){
        UserDefaults.standard.removeObject(forKey: pendingKey)
    }
    
    func retryPendingDevice(){
        if let data = UserDefaults.standard.data(forKey: pendingKey){
            if let device = try? JSONDecoder().decode(Device.self, from: data){
                attemptUpload(device: device)
            }
        }
    }
    
    
    
    
    //MARK: -- Request user permision for notifications
    func requestNotificationPermissionAndRegister(){
        
        let center = UNUserNotificationCenter.current()

          center.requestAuthorization(options: [.alert, .badge, .sound]) {granted, error in
              
              if let error = error{
                  print("Notification permission error: \(error)")
                  return
              }
              
              if granted{
                  print("Notification permission granted")
                  DispatchQueue.main.async {
                      UIApplication.shared.registerForRemoteNotifications()
                  }
              }else{
                  print("User denied notification permission")
              }
              
          }
          
        
    }

    
    
}
