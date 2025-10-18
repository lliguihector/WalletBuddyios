//
//  HomeTabView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/30/25.
//

import SwiftUI
import MapKit

struct HomeTabView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    // MARK: - State
    @State private var showMapView = false
    @StateObject private var homeVM = HomeViewModel() // ✅ Add HomeViewModel
    
    @State private var status: String = "Loading.."
    @State private var statusColor: Color = .gray
    @State private var statusIcon: String = "questionmark.circle"
    @State private var timeSinceEvent: String = "..."
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Greeting Section
                    HStack {
                        Text("\(greatingMessage()), \(userViewModel.appUser?.firstName ?? "User")")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // MARK: - Last Check-In Card
                    if let lastCheckin = homeVM.lastCheckin {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.blue)
                                Text("Last Check-In")
                                    .font(.headline)
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 2){
                                    Label{
                                        Text(status)
                                            .font(.caption)
                                            .bold()
                                    }icon:{
                                        Image(systemName: statusIcon)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(statusColor.opacity(0.15))
                                    .foregroundColor(statusColor)
                                    .clipShape(Capsule())
                                    
                                    Text(timeSinceEvent)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            HStack {
                                Text("Date & Time:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(lastCheckin.checkInTime.formatted(date: .abbreviated, time: .shortened))
                                    .foregroundColor(.primary)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Location:")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("Room 201") // You can update dynamically later
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
                        .padding(.horizontal)
                        .onAppear {
                            updateStatus(from: lastCheckin)
                        }
                    } else if homeVM.isLoading {
                        
                      CheckInSkeletonView()
                    } else if homeVM.showFailureAlert {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            
                            HStack {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.blue)
                                Text("Last Check-In")
                                    .font(.headline)
                                Spacer()
                                
                           
                            }
                            Divider()
                            VStack {
                                Spacer() // pushes content down
                                Text(homeVM.errorMessage ?? "No check-in data available")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Spacer() // pushes content up
                            }
                            .frame(maxWidth: .infinity) // full width
                            .cornerRadius(16)
                            .padding(.horizontal)

                            
                         
                        } .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
                            .padding(.horizontal)
                       
                    }
                    
                    // MARK: - Start Check-In Button
                    Button(action: { showMapView = true }) {
                        HStack {
                            Image(systemName: "clock.badge.checkmark")
                            Text("Start Check-In")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color.blue, Color.cyan], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .sheet(isPresented: $showMapView) {
                MapView()
            }
            .task {
                await homeVM.fetchLastCheckin() // ✅ Fetch on appear
            }
            
            // MARK: - Offline Banner
            if !networkMonitor.isConnected {
                VStack {
                    Text("No Internet Connection")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                    Spacer()
                }
                .transition(.move(edge: .top))
                .zIndex(1)
            }
        }
    }


    
    // MARK: - Helper Methods
    
    //Greeting Logic
    func greatingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
    //Status Upate
    func updateStatus(from checkin: CheckIn){


        if checkin.checkedOut{
            
            status = "Checked Out"
            statusColor = .red
            statusIcon = "xmark.circle.fill"
            
            if let outTime = checkin.checkedOutTime{
                timeSinceEvent = timeAgo(from: outTime)
            }
                
                
            
        }else{
            status = "Checked In"
            statusColor = .green
            statusIcon = "checkmark.circle.fill"
            
        
            timeSinceEvent = timeAgo(from: checkin.checkInTime)
        }
        
        
    }
    
    //Format relative time
    func timeAgo(from date: Date) -> String {
        
        let interval = Date().timeIntervalSince(date)
        let hours = Int(interval/3600)
        let minutes = Int(interval.truncatingRemainder(dividingBy: 3600))/60
        
        
        if hours>0 {
                return "\(hours)h \(minutes)m ago"
        }else if minutes > 0{
            return "\(minutes)m ago"
        }else{
            return "Just Now"
        }
    }
    
}
