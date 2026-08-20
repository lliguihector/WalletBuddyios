//
//  HomeViewModel.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 10/18/25.
//
import Foundation
import CoreLocation


@MainActor
class HomeViewModel: ObservableObject{
    //MARK: - Properties
    @Published var isLoading: Bool = false
    @Published var isLoadingActiveUsers: Bool = false
    
    @Published var showFailureAlert: Bool = false
    @Published var errorMessage: String? = nil
    @Published var activeUsersError: String? = nil
    @Published var lastCheckin: CheckIn?
    @Published var successMessage: String? = nil
    @Published var showSuccessAlert = false
    
    @Published var users: [CheckedInUser] = []
    @Published var isClockingOut: Bool = false
    @Published var isClockingIn: Bool = false
    
    //MARK: - DEPENDENCIES
    private var apiService = ApiService.shared
    private var firebaseService = FirebaseAuthManager.shared
    
    private let locationManager: LocationManager
    
    //MARK: MAP
 
    init(locationManager: LocationManager){
        self.locationManager = locationManager
    }
    
    
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
    }

    func getCurrentCoordinates() -> (
         latitude: Double,
         longitude: Double
     )? {
         guard let location = locationManager.currentLocation else {
             errorMessage = "Unable to get your current location."
             return nil
         }

         return (
             latitude: location.coordinate.latitude,
             longitude: location.coordinate.longitude
         )
}
    
    
    
    
    
    //MARK: - FETCH USER MOST RESETN CHECK-IN
    func fetchLastCheckin() async{
        
    isLoading = true
        defer {isLoading = false}
        
        do{
            //Get Firebase ID token
            guard let idToken = try await firebaseService.getIDToken(forceRefresh: true)else{
                showFailureAlert = true
                errorMessage = "Authentication failed. Please log in again."
                return
            }
            //Call API
            let result = await apiService.fetchLastCheckin(token: idToken)
            
            //Handle result
            switch result{
            case .success(let checkIn):
                self.lastCheckin = checkIn
                self.showFailureAlert = false
                self.errorMessage = nil
                print("\(checkIn)")
                
            case .failure(let error):
                self.showFailureAlert = true
                switch error{
                case .invalidURL:
                    errorMessage = "Invalid server URL."
                case .encodingError:
                    errorMessage = "Failed to encode Request"
                case .decodingError:
                    errorMessage = "Failed to decode data."
                case .networkError(let err):
                    errorMessage = "Network error: \(err.localizedDescription)"
                    
                case .unauthorized:
                    errorMessage = "Your session has expired. Please log in again."
                case .serverError( _ , let message):
                    //Use backend's actual error message, or a dedault
                    errorMessage = message ?? "Server rejected the request."
                }
            }
        }catch{
            showFailureAlert = true
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
    }
    
    //MARK: - CHECK OUT USER

    func checkoutUser() async {
        guard !isClockingOut else { return }

        isClockingOut = true

        // Reset previous request state
        showSuccessAlert = false
        showFailureAlert = false
        successMessage = ""
        errorMessage = nil

        defer {
            isClockingOut = false
        }

        // Get current location
        guard let location = locationManager.currentLocation else {
            showFailureAlert = true
            errorMessage = "Unable to get your current location."
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        do {
            // Get Firebase ID token
            guard let idToken = try await firebaseService.getIDToken(
                forceRefresh: false
            ) else {
                showFailureAlert = true
                errorMessage = "Unable to authenticate your account."
                return
            }

            // Get device information
            let device = DeviceCheckInInfo(
                id: DeviceInfo.deviceId,
                platform: DeviceInfo.platform,
                osVersion: DeviceInfo.systemVersion,
                model: DeviceInfo.deviceModel,
                appVersion: Bundle.main.infoDictionary?[
                    "CFBundleShortVersionString"
                ] as? String
            )

            // Call checkout API
            let result = await apiService.checkout(
                firebaseIDToken: idToken,
                latitude: latitude,
                longitude: longitude,
                device: device
            )

            switch result {
            case .success(let response):
                if response.success {
                    successMessage = response.message
                    errorMessage = nil

                    showFailureAlert = false
                    showSuccessAlert = true
                    
                  
                } else {
                    // Defensive handling in case the backend returns
                    // success: false with a 2xx status.
                    successMessage = ""
                    errorMessage = response.message

                    showSuccessAlert = false
                    showFailureAlert = true
                }

            case .failure(let apiError):
                successMessage = ""
                errorMessage = apiError.message

                showSuccessAlert = false
                showFailureAlert = true
            }
        } catch {
            successMessage = ""
            errorMessage = "Authentication error: \(error.localizedDescription)"

            showSuccessAlert = false
            showFailureAlert = true
        }
    }


    //MARK: - CHECK IN USER
    
    func checkInUser() async {
        
        guard !isClockingIn else {return}
        
        isClockingIn =  true
        
        //RESET
        showSuccessAlert = false
        showFailureAlert = false
        successMessage = ""
        errorMessage = nil
        
        defer {
            isClockingIn = false
        }
        
        do{
            //Make sure the current location is available
            guard let location = locationManager.currentLocation else {
                showFailureAlert = false
                errorMessage = "Unable to get your current location. Please try again."
                return
            }
            
            
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            
            guard let idToken = try await firebaseService.getIDToken(forceRefresh: true)else{
                showFailureAlert = true
                errorMessage = "Authentication failed. Please log in again."
                return
            }
        
            
            
            //Get device information
            let device = DeviceCheckInInfo(id: DeviceInfo.deviceId, platform: DeviceInfo.platform, osVersion: DeviceInfo.systemVersion, model: DeviceInfo.deviceModel, appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            )
                
            
            
            let result = await apiService.sendLocationToDB(withToken: idToken,latitude: latitude,longitude: longitude,device: device)

            switch result {
                case .success(let checkIn):
       
                showFailureAlert = false
                errorMessage = nil
                successMessage = "\(checkIn.message)"
                showSuccessAlert = true
                
                    showSuccessAlert = true
                    errorMessage = nil //Clear any previous errors
    
                case .failure(let error):
  
                  showFailureAlert = true
            
                
                //Map error to user-friendly message
                switch error{
                case .invalidURL:
                    errorMessage = "Something went wrong with the server URL."
                case .encodingError:
                errorMessage = "Failure to encode request body."
                case .decodingError:
                    errorMessage = "Could not understand the server response"
                case .networkError(let err):
                    errorMessage = "Network issue: \(err.localizedDescription)"
                    
                case .unauthorized:
                    errorMessage = "Unauthorized access. Please log in again."
                case .serverError( _ , let message):
                    //Use backend's actual error message, or a dedault
                    errorMessage = message ?? "Server rejected the request."
                }
                }
            
        }catch{
            showSuccessAlert = false
            showFailureAlert = true
            errorMessage =
                "Unexpected error: \(error.localizedDescription)"

        }
        
        
        
        

        
    }
    
    
    
    //MARK: - GET ARRAY OF CHECKED-IN USERS WITHIN USER ORGANIZATION
    func loadCheckedInUsers() async {
        isLoadingActiveUsers = true
        defer {isLoadingActiveUsers = false}
        
        
        do{
            
            //Get Firebase ID token
            guard let idToken = try await firebaseService.getIDToken(forceRefresh: true)else{
                showFailureAlert = true
                errorMessage = "Authentication failed. Please log in again."
                return
            }
            //Call API
            let result = await apiService.fetchCheckedInUsers(token: idToken)
            
            
            //Handle resulr
            switch result{
            case .success(let fetchedUsers):
                self.users = fetchedUsers
                self.showFailureAlert = false
                self.activeUsersError = nil
                
                if fetchedUsers.isEmpty{
                    print("No users currently checked in.")
                }
                
            case .failure(let error):
//                self.showFailureAlert = true
                switch error{
            case .invalidURL:
                         activeUsersError = "Invalid URL."

                     case .networkError(let err):
                         activeUsersError = "Network error: \(err.localizedDescription)"

                     case .decodingError:
                         activeUsersError = "Failed to decode server response."

                     case .encodingError:
                         activeUsersError = "Failed to encode request body."

                     case .unauthorized:
                         activeUsersError = "Your session has expired. Please log in again."

                     case .serverError(_, let message):
                         activeUsersError = message ?? "Server rejected the request."
                     }
                print("API Error: \(errorMessage ?? "Unknown")")
            }
                    
            
        }catch{
//            showFailureAlert = true
            activeUsersError = "Unexpected error: \(error.localizedDescription)"
        }
    }
    
    
}
extension APIError {
    var message: String {
        switch self {
        case .invalidURL:
            return "The server URL is invalid."

        case .encodingError:
            return "Unable to prepare the clock-out request."

        case .decodingError:
            return "Unable to read the server response."

        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"

        case .unauthorized:
            return "Your session has expired. Please sign in again."

        case .serverError(_, let message):
            return message ?? "Unable to clock out."
        }
    }
}
