//
//  File.swift
//  GoodRecipeToDay
//
//  Created by apple on 04.08.2023.
//

import Foundation
import Reachability

class InternetConnectionManager {
    // Static constant to hold the single instance of the manager
    static let shared = InternetConnectionManager()

    // Private Reachability instance
    private let reachability: Reachability

    // Private initializer to prevent creating instances from outside the class
    private init() {
        reachability = try! Reachability()

        // Start monitoring for internet connection changes
        startMonitoring()
    }

    // Start monitoring for internet connection changes
    private func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectionChange(notification:)), name: .reachabilityChanged, object: reachability)

        do {
            try reachability.startNotifier()
        } catch {
            print("Could not start reachability notifier")
        }
    }

    // Stop monitoring for internet connection changes
    private func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
    }

    // Handle internet connection change notifications
    @objc private func handleConnectionChange(notification: Notification) {
        if reachability.connection != .unavailable {
            print("Internet is available.")
        } else {
            print("Internet is not available.")
        }
    }

    // Check if internet is currently available
    func isInternetAvailable() -> Bool {
        return reachability.connection != .unavailable
    }
}
