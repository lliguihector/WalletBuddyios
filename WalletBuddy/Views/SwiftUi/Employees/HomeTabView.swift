//
//  HomeTabView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 8/30/25.
//

import SwiftUI
import MapKit
import Foundation

struct HomeTabView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    // MARK: - State
    @State private var showMapView = false
  //  @StateObject private var homeVM = HomeViewModel() // ✅ Add HomeViewModel
    
    
    @StateObject private var locationManager: LocationManager
    @StateObject private var homeVM: HomeViewModel

       init() {
           let locationManager = LocationManager()

           _locationManager = StateObject(
               wrappedValue: locationManager
           )

           _homeVM = StateObject(
               wrappedValue: HomeViewModel(
                   locationManager: locationManager
               )
           )
       }

    @State private var status: String = "Loading.."
    @State private var statusColor: Color = .gray
    @State private var statusIcon: String = "questionmark.circle"
    @State private var timeSinceEvent: String = "..."
    
    //MARK: Toast State
    @State private var toastMessage: String? = nil
    @State private var showToast = false
    @State private var toastIsError = false
    
    
    //MARK: BODY
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 12) {
                    greetingSection
                    checkInOutCardSection
                    currentlyOnSiteSection
                }
                .padding(.vertical)
            }
      
            .task {
                await homeVM.fetchLastCheckin() // ✅ Fetch on appear
                await homeVM.loadCheckedInUsers()
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
            //MARK: - Loading Spinner
            if homeVM.isLoading {
                LoadingSpinnerView()
                    .transition(.opacity)
                    .zIndex(2)
            }
            
            //MARK: - Toast
            if showToast, let message = toastMessage {
                VStack{
                    Spacer()
                    
                    WBToast(message: message, isError: toastIsError)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal,16)
                        .padding(.bottom, 12)
                
                }
                .zIndex(3)
                .allowsHitTesting(false)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }//end ZStack
        .animation(.easeInOut(duration: 0.3  ), value: showToast)
    }


    
    // MARK: - Helper Methods
    //Status Upate bade "Active", "Completed "
    func updateStatus(from checkin: CheckIn){


        if checkin.status == .active{
            
            status = "Active"
            statusColor = .green
            statusIcon = "location.fill"
            
            if let outTime = checkin.checkOutTime{
                timeSinceEvent = timeAgo(from: outTime)
            }
                
                
            
        }else{
            status = "Completed"
            statusColor = .gray
            statusIcon = "checkmark.circle.fill"
            
        //HELLO KITTY
            timeSinceEvent = timeAgo(from: checkin.checkInTime)
        }
        
        
    }
    
    //Format relative time
    func timeAgo(from date: Date) -> String {
        
        let interval = Date().timeIntervalSince(date)
        
        let minutes = Int(interval/60)
        let hours = Int(interval/3600)
        let days = Int(interval/86400)//24*3600
        let weeks = Int(interval/604800)//7*86400
        
        
        if weeks > 0 {
            return "\(weeks)w ago"
        }else if days > 0{
            return "\(days)d ago"
        }else if hours>0{
            let remainingMinutes = (minutes%60)
            return "\(hours)h \(remainingMinutes)m ago"
        }else if minutes>0{
            return "\(minutes)m ago"
        }else{
            return "Just now"
        }
        
        
        
    }

    //In Seconds
    func formatDuration(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    
    
    // MARK: - Toast Auto Dismiss
    private func showToastWithAutoDismiss() {
        withAnimation { showToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation { showToast = false }
        }
    }
}

//MARK: Greeting Section
private extension HomeTabView{
    
    //View
    var greetingSection: some View{
        //Good Afternon, John
        HStack {
            Text("\(greatingMessage()), \(appViewModel.userSession.user?.firstName ?? "User")")
                .font(.title3)
                .bold()
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)

    }
    
    //Methods
    private func firstName(from fullName: String) -> String {
        fullName
            .split(separator: " ")
            .first
            .map(String.init) ?? fullName
    }

    func greatingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
    
//
    
}
//MARK: Check In/Out Card Section
private extension HomeTabView {

    // MARK: Main Section

    @ViewBuilder
    var checkInOutCardSection: some View {
        if let lastCheckin = homeVM.lastCheckin {
            checkInOutCard(lastCheckin)
        } else if homeVM.isLoading {
            CheckInSkeletonView()
        } else {
            noCheckInCard
        }
    }

    // MARK: Existing Check-In Card

    func checkInOutCard(_ lastCheckin: CheckIn) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            shiftCardHeader(lastCheckin)

            if lastCheckin.status == .active {
                activeShiftContent(lastCheckin)
            } else {
                completedShiftContent(lastCheckin)

                Divider()

                checkLocationLink
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 6,
            x: 0,
            y: 4
        )
        .padding(.horizontal)
        .onAppear {
            updateStatus(from: lastCheckin)
        }
    }

    // MARK: Card Header

    func shiftCardHeader(_ lastCheckin: CheckIn) -> some View {
        HStack {
            Text(
                lastCheckin.status == .active
                    ? "Current Shift"
                    : "Last Shift"
            )
            .font(.headline)
            .foregroundStyle(.primary)

            Spacer()

            Label(status, systemImage: statusIcon)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.15))
                .foregroundStyle(statusColor)
                .clipShape(Capsule())
        }
    }

    // MARK: Active Shift

    func activeShiftContent(
        _ lastCheckin: CheckIn
    ) -> some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Clocked in at")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(
                    lastCheckin.checkInTime.formatted(
                        .dateTime
                            .hour()
                            .minute()
                    )
                )
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

                TimelineView(
                    .periodic(from: .now, by: 60)
                ) { context in
                    let duration = context.date.timeIntervalSince(
                        lastCheckin.checkInTime
                    )

                    Text(
                        "\(formattedDate(lastCheckin.checkInTime)) • \(formatDuration(duration))"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }

            Spacer()

            clockOutButton
        }
    }

    // MARK: Completed Shift

    func completedShiftContent(
        _ lastCheckin: CheckIn
    ) -> some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                if let clockOutTime = lastCheckin.checkOutTime {
                    Text(
                        "\(formattedTime(lastCheckin.checkInTime)) – \(formattedTime(clockOutTime))"
                    )
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                    if let workDurationMinutes =
                        lastCheckin.workDurationMinutes {
                        let durationInSeconds = TimeInterval(
                            workDurationMinutes * 60
                        )

                        Text(
                            "\(formattedDate(lastCheckin.checkInTime)) • \(formatDuration(durationInSeconds))"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                } else {
                    Text(formattedTime(lastCheckin.checkInTime))
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(formattedDate(lastCheckin.checkInTime))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            clockInButton
        }
    }

    // MARK: No Check-In Card

    var noCheckInCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent")
                    .font(.headline)

                Spacer()

                Label(
                    "Not Clocked In",
                    systemImage: "clock"
                )
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.15))
                .foregroundStyle(.gray)
                .clipShape(Capsule())
            }

            Divider()

            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("No recent activity")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

                    Text("Ready to start?")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }

                Spacer()

                clockInButton
            }

            if let errorMessage = homeVM.errorMessage,
               !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }

            Divider()

            checkLocationLink
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 6,
            x: 0,
            y: 4
        )
        .padding(.horizontal)
    }

    // MARK: Clock In Button

    var clockInButton: some View {
        Button {
            Task {
                await performClockIn()
            }
        } label: {
            HStack(spacing: 7) {
                if homeVM.isClockingIn {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.white)

                    Text("Clocking In...")
                } else {
                    Image(systemName: "clock.badge.checkmark")
                        .font(.subheadline)

                    Text("Clock In")
                }
            }
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundStyle(.white)
            .background(
                Color(
                    red: 0.05,
                    green: 0.15,
                    blue: 0.35
                )
                .opacity(homeVM.isClockingIn ? 0.7 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(homeVM.isClockingIn)
        .accessibilityLabel(
            homeVM.isClockingIn
                ? "Clocking in"
                : "Clock in"
        )
    }

    // MARK: Clock Out Button

    var clockOutButton: some View {
        Button {
            Task {
                await performClockOut()
            }
        } label: {
            HStack(spacing: 7) {
                if homeVM.isClockingOut {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.red)

                    Text("Clocking Out...")
                } else {
                    Image(systemName: "clock.badge.xmark")
                        .font(.subheadline)

                    Text("Clock Out")
                }
            }
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundStyle(.red)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.12))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        Color.red.opacity(0.5),
                        lineWidth: 1
                    )
            }
        }
        .disabled(homeVM.isClockingOut)
        .opacity(homeVM.isClockingOut ? 0.7 : 1)
        .accessibilityLabel(
            homeVM.isClockingOut
                ? "Clocking out"
                : "Clock out"
        )
    }

    // MARK: Location Link

    var checkLocationLink: some View {
        NavigationLink {
            LocationEligibilityView()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                    .font(.subheadline)

                Text("Check Location")
                    .font(.subheadline.weight(.semibold))

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(.blue)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint(
            "Shows whether you are inside the approved attendance area"
        )
    }

    // MARK: Clock-In Action

    func performClockIn() async {
        await homeVM.checkInUser()

        guard homeVM.showSuccessAlert else {
            showErrorToast(
                homeVM.errorMessage
                    ?? "Clock-in could not be completed."
            )
            return
        }

        await homeVM.fetchLastCheckin()
        await homeVM.loadCheckedInUsers()//CAT

        guard let updatedCheckIn = homeVM.lastCheckin,
              updatedCheckIn.status == .active else {
            showErrorToast(
                "Clock-in could not be confirmed."
            )
            return
        }

        updateStatus(from: updatedCheckIn)
        

        showSuccessToast(
            homeVM.successMessage
                ?? "Clocked in successfully."
        )
    }

    // MARK: Clock-Out Action

    func performClockOut() async {
        await homeVM.checkoutUser()

        guard homeVM.showSuccessAlert else {
            showErrorToast(
                homeVM.errorMessage
                    ?? "Clock-out could not be completed."
            )
            return
        }

        await homeVM.fetchLastCheckin()
        await homeVM.loadCheckedInUsers()//CAT

        guard let updatedCheckIn = homeVM.lastCheckin,
              updatedCheckIn.status != .active else {
            showErrorToast(
                "Clock-out could not be confirmed."
            )
            return
        }

        updateStatus(from: updatedCheckIn)

        showSuccessToast(
            homeVM.successMessage
                ?? "Clocked out successfully."
        )
    }

    // MARK: Toast Helpers

    func showSuccessToast(_ message: String) {
        toastMessage = message
        toastIsError = false
        showToastWithAutoDismiss()
    }

    func showErrorToast(_ message: String) {
        toastMessage = message
        toastIsError = true
        showToastWithAutoDismiss()
    }

    // MARK: Date Formatting

    func formattedTime(_ date: Date) -> String {
        date.formatted(
            .dateTime
                .hour()
                .minute()
        )
    }

    func formattedDate(_ date: Date) -> String {
        date.formatted(
            .dateTime
                .month(.abbreviated)
                .day()
                .year()
        )
    }
}
//MARK: Currently On Site Section
private extension HomeTabView{
    
    
    var currentlyOnSiteSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Section Header
            HStack {
                Text("Currently On Site")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button {
                    print("See All tapped")
                } label: {
                    HStack(spacing: 4) {
                        Text("View Team")
                        
                        Image(systemName: "chevron.right")
                            .font(.caption.bold())
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.blue)
                }
            }
            
            // Loading State
            if homeVM.isLoadingActiveUsers {
                ProgressView("Loading active users...")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                
            // Error State
            } else if let error = homeVM.activeUsersError {
                Text(error)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                
            // Empty State
            } else if homeVM.users.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "person.3")
                        .font(.system(size: 30))
                        .foregroundStyle(.secondary)
                    
                    Text("No users currently checked in")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                
            // Active Users
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 18) {
                        ForEach(homeVM.users) { user in
                            Button {
                                print("Selected \(user.name)")
                                
                                // Navigate to the employee profile or chat here.
                            } label: {
                                VStack(spacing: 8) {
                                    
                                    ZStack {
                                        // Outer ring
                                        // White background for transparent PNG images
                                        Circle()
                                            .fill(
                                                Color(
                                                    red: 0.97,
                                                    green: 0.96,
                                                    blue: 0.93
                                                )
                                            )
                                        // Profile image
                                        AsyncImage(
                                            url: URL(
                                                string: user.profileImageUrl ?? ""
                                            )
                                        ) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()

                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()

                                            case .failure:
                                                profilePlaceholder

                                            @unknown default:
                                                profilePlaceholder
                                            }
                                        }
                                        .frame(width: 72, height: 72)
                                        .clipShape(Circle())
                                    }
                                    .frame(width: 72, height: 72)
                                    .overlay(alignment: .bottomTrailing) {
                                        // Online indicator
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 18, height: 18)
                                            .overlay {
                                                Circle()
                                                    .stroke(
                                                        Color(.secondarySystemGroupedBackground),
                                                        lineWidth: 3
                                                    )
                                            }
                                    }
                                    Text(firstName(from: user.name))
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                        .frame(width: 75)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .padding(18)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .shadow(
            color: Color.black.opacity(0.07),
            radius: 8,
            x: 0,
            y: 4
        )
        .padding(.horizontal)
        .padding(.top, 4)
    }
    
    
    // MARK: - Profile Placeholder
    private var profilePlaceholder: some View {
        ZStack {
            Color.gray.opacity(0.15)
            
            Image(systemName: "person.fill")
                .font(.system(size: 25))
                .foregroundStyle(.gray)
        }
    }

}


