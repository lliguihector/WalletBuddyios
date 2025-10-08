//
//  NavigationRouter.swift
//  WalletBuddy
//
//  Created by Hector Lliguichuzca on 7/21/25.
//
import SwiftUI
import UIKit
import Foundation

/// Represents all possible destinations in your app
@MainActor
class NavigationRouter: ObservableObject {
    static let shared = NavigationRouter()

    /// SwiftUI expects `NavigationPath`, not `[AppRoute]`
    @Published var path = NavigationPath()

    func push(_ route: AppRoute) {
        path.append(route)
        print("Navigation Stack count: \(path.count)")
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
        print("Navigation Stack count: \(path.count)")
    }

    func popToRoot() {
        path = NavigationPath()
        print("Navigation Stack cleared")
    }

    func replace(with route: AppRoute) {
        path = NavigationPath()
        path.append(route)
    }
}
