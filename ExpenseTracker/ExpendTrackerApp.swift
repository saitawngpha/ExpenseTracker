//
//  ExpendTrackerApp.swift
//  ExpendTracker
//
//  Created by Steve Pha on 1/26/23.
//

import SwiftUI

@main
struct ExpendTrackerApp: App {
    @StateObject var transactionListVM = TransactionListViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(transactionListVM)
        }
    }
}
