//
//  CoinDetailsViewModel.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/22/24.
//

import Foundation

class CoinDetailsViewModel: ObservableObject {
    private let service: CoinDataService
    private let coinId: String
    
    @Published var coinDetails: CoinDetails?
    
    init(coinId: String, service: CoinDataService) {
        self.service = service
        self.coinId = coinId
        
    }
    
    @MainActor
    func fetchCoinDetails() async  {
        do {
          let coinDetails = try await service.fetchCoinDetails(id: coinId)
            self.coinDetails = coinDetails
        } catch  {
            print("Error: \(error.localizedDescription)")
        }
    }
}
