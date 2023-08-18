//
//  NetworkConnectivity.swift
//  WanderView
//
//  Created by Steve Hechio on 18/08/2023.
//

import Foundation
import Network

class NetworkConnectivity {
    static let shared = NetworkConnectivity()

    private let monitor = NWPathMonitor()
    private var isConnected = true

    private init() {
        startMonitoring()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }

        let queue = DispatchQueue(label: "NetworkMonitorQueue")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    func isReachable() -> Bool {
        return isConnected
    }
}
