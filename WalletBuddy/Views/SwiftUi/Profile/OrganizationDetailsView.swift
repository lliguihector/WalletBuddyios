//
//  OrganizationDetailsView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 9/17/25.
//

import SwiftUI

struct OrganizationDetailsView: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    
    private var organization: Organization? {
        appViewModel.userSession.user?.organization
    }
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 16) {
                
                organizationHeaderCard
                
                contactInformationCard
                
                aboutCard
                
                industryCard
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Organization Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.primary)
                }
            }
        }
      
    }
}


// MARK: - Header Card

private extension OrganizationDetailsView {
    
    var organizationHeaderCard: some View {
        VStack(spacing: 18) {
            
            HStack(alignment: .top, spacing: 16) {
                
                organizationLogo
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text(organization?.name ?? "Organization")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "building.2.fill")
                            .font(.caption)
                        
                        Text(organization?.industry.rawValue ?? "N/A")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.10))
                    )
                    
                    // Optional description later
                    Text("Organization details and contact information.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            

        }
        .padding(18)
        .cardStyle()
    }
    
    var organizationLogo: some View {
        Group {
            if let logoUrl = organization?.logoKey,
               let url = URL(string: logoUrl) {
                
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                        
                    case .failure:
                        organizationPlaceholder
                        
                    case .empty:
                        ProgressView()
                        
                    @unknown default:
                        organizationPlaceholder
                    }
                }
                
            } else {
                organizationPlaceholder
            }
        }
        .frame(width: 92, height: 92)
        .background(Color.white)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(
                    Color(.separator).opacity(0.20),
                    lineWidth: 1
                )
        }
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 3,
            x: 0,
            y: 1
        )

    }
    
    var organizationPlaceholder: some View {
        Image(systemName: "building.2.fill")
            .resizable()
            .scaledToFit()
            .padding(24)
            .foregroundStyle(.blue)
    }
}


// MARK: - Contact Card

private extension OrganizationDetailsView {
    
    var contactInformationCard: some View {
        VStack(spacing: 0) {
            
            cardHeader(
                title: "Contact Information"
            )
            
            Divider()
                .padding(.leading, 52)
            
            infoRow(
                icon: "envelope",
                title: "Business Email",
                value: organization?.email ?? "Not provided",
                showsChevron: false
            ) {
//                emailOrganization()
            }
            
            Divider()
                .padding(.leading, 52)
            
            infoRow(
                icon: "phone",
                title: "Phone Number",
                value: organization?.phone ?? "Not provided",
                showsChevron: false
            )
            {
//                callOrganization()
            }
            
            Divider()
                .padding(.leading, 52)
            
            infoRow(
                icon: "globe",
                title: "Website",
                value: organization?.website ?? "Not provided",
                trailingIcon: "arrow.up.right.square"
            ) {
                openWebsite()
            }
        }
        .cardStyle()
    }
}


// MARK: - About Card

private extension OrganizationDetailsView {
    
    var aboutCard: some View {
        VStack(spacing: 0) {
            
            cardHeader(
                title: "About"
            )
            
            if hasAddress {
                Divider()
                    .padding(.leading, 52)
                
                infoRow(
                    icon: "mappin.and.ellipse",
                    title: "Main Location",
                    value: formattedAddress,
                    showsChevron: true
                ) {
                    openMap()
                }
            }
        }
        .cardStyle()
    }
}


// MARK: - Industry Card

private extension OrganizationDetailsView {
    
    var industryCard: some View {
        HStack(spacing: 14) {
            
            iconCircle(systemName: "tag.fill")
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Industry")
                    .font(.headline)
                
                Text(organization?.industry.rawValue ?? "Not provided")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .cardStyle()
    }
}


// MARK: - Reusable Components

private extension OrganizationDetailsView {
    
    func cardHeader(title: String) -> some View {
        
        HStack{
            Text(title)
                .font(.headline)
            
            Spacer()
        }
        .padding(16)
    }
    
    
    func infoRow(
        icon: String,
        title: String,
        value: String,
        showsChevron: Bool = false,
        trailingIcon: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        
        Button(action: action) {
            
            HStack(spacing: 14) {
                
                iconCircle(systemName: icon)
                
                VStack(alignment: .leading, spacing: 3) {
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(value)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if showsChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                }
                
                if let trailingIcon {
                    Image(systemName: trailingIcon)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    
    func iconCircle(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Color.amazingBlue) //Inside circle Icon
            .frame(width: 40, height: 40)
            .background(Color.white.opacity(0.09)) //Circle Icon color
            .clipShape(Circle())
    }
    
    
    func actionButton(
        title: String,
        icon: String
    ) -> some View {
        
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(title)
                .fontWeight(.semibold)
        }
        .foregroundStyle(Color.amazingBlue) //call and email buttons
        .frame(maxWidth: .infinity)
        .frame(height: 46)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.amazingBlue.opacity(0.5))
        )
    }
}


// MARK: - Address

private extension OrganizationDetailsView {
    
    var hasAddress: Bool {
        guard let address = organization?.address else {
            return false
        }
        
        return [
            address.street,
            address.city,
            address.state,
            address.postalCode,
            address.country
        ]
        .compactMap { $0 }
        .contains { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    
    var formattedAddress: String {
        guard let address = organization?.address else {
            return "Not provided"
        }
        
        let cityStatePostal = [
            address.city,
            address.state,
            address.postalCode
        ]
        .compactMap { value -> String? in
            guard let value,
                  !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else {
                return nil
            }
            
            return value
        }
        .joined(separator: ", ")
        
        let parts = [
            address.street,
            cityStatePostal.isEmpty ? nil : cityStatePostal,
            address.country
        ]
        .compactMap { value -> String? in
            guard let value,
                  !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            else {
                return nil
            }
            
            return value
        }
        
        return parts.isEmpty
            ? "Not provided"
            : parts.joined(separator: "\n")
    }
}


// MARK: - Actions

private extension OrganizationDetailsView {
    
    func callOrganization() {
        
        guard let phone = organization?.phone else {
            return
        }
        
        let cleanedPhone = phone.filter {
            $0.isNumber || $0 == "+"
        }
        
        guard let url = URL(string: "tel://\(cleanedPhone)") else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    
    func emailOrganization() {
        
        guard let email = organization?.email,
              let url = URL(string: "mailto:\(email)") else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    
    func openWebsite() {
        
        guard var website = organization?.website?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !website.isEmpty else {
            return
        }
        
        if !website.hasPrefix("http://") &&
            !website.hasPrefix("https://") {
            website = "https://\(website)"
        }
        
        guard let url = URL(string: website) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    
    func openMap() {
        // Navigate to your organization map here.
    }
}


// MARK: - Card Modifier

private extension View {
    
    func cardStyle() -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color(.separator).opacity(0.18),
                        lineWidth: 1
                    )
            }
    }
}
