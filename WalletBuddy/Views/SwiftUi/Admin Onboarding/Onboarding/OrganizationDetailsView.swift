//
//  OrganizationDetailsView.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 9/17/25.
//
import SwiftUI
struct OrganizationDetailsView: View {
    
  
    let organization: Organization
    
    var body: some View {
    
        ScrollView {
            
            VStack(spacing: 20) {
                // Logo and Name
                HStack(spacing: 16) {
                    if let logoUrl = organization.logoUrl, let url = URL(string: logoUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 7)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 80, height: 80)
                        }
                    } else {
                        Image(systemName: "building.2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 7)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                    Text(organization.name)
                        .font(.title2)
                        .bold()
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    
                        Text(organization.type) // Subtitle
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                              
                }
                    Spacer()
                }
                
                Divider()
                
                // General Info Section
                VStack(alignment: .leading, spacing: 4) {
                    SectionHeader(title: "Contact")
                    contactInfoRow(title: "Email", icon: "envelope.fill",value: organization.email)
                    contactInfoRow(title: "Phone", icon: "phone.fill",value: organization.phone)
                }
                
                Divider()
                
                // Address Section
                VStack(alignment: .leading, spacing: 4) {
                    SectionHeader(title: "Address")
                    addressInfoRow(title: "Street", value: organization.address.street)
                    addressInfoRow(title: "City", value: organization.address.city)
                    addressInfoRow(title: "State",  value: organization.address.state)
                    addressInfoRow(title: "Postal Code", value: organization.address.postalCode)
                    addressInfoRow(title: "Country", value: organization.address.country)

                }
                // Map Button After Address
                               Button(action: {
//
                                   
                                   
                               }) {
                                   HStack(spacing: 4) {
                                       Image(systemName: "map.fill")
                                       Text("View on Map")
                                           .font(.subheadline)
                                   }
                                   .padding(8)
                                   .frame(maxWidth: .infinity)
                                   .background(Color.blue.opacity(0.1))
                                   .foregroundColor(.blue)
                                   .cornerRadius(10)
                               }
                               .padding(.top, 8)
                               
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Helper Row
    // Contact info row: icon + label
    @ViewBuilder
    private func contactInfoRow(title: String, icon: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }
        }
    }

    // Address info row: label + value only
    @ViewBuilder
    private func addressInfoRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
                .foregroundColor(.primary)
           
        }
    }

    // MARK: - Section Header
    @ViewBuilder
    private func SectionHeader(title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.primary)
            .padding(.bottom, 4)
    }
}

