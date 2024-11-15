//
//  NetworkingBootcampApp.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/21/24.
//

import SwiftUI

@main
struct NetworkingBootcampApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(service: CoinDataService())
        }
    }
}
