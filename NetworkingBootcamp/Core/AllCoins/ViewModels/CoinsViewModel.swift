//
//  CoinsViewModel.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/21/24.
//

import Foundation

class CoinsViewModel: ObservableObject {
    
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    private let service: CoinDataService
    
    init(service: CoinDataService) {
        self.service = service
        Task {  await fetchCoins() }
    }
    
    @MainActor //switch back to main thread - same thing as DispatchQueue.main.async {}
    func fetchCoins() async {
        do {
            self.coins = try await service.fetchCoinsAsync()
        } catch {
            if let error = error as? CoinAPIError {
                self.errorMessage = error.customDescription
            } else {
                self.errorMessage = error.localizedDescription
            }
        }
        
        //use weak self in completion handlers to remove the strong reference to the object its referencing
        //strong references retrain cycles - think of two people holding hands and not letting go
//        service.fetchCoinsWithResult {[weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let coins):
//                    self?.coins = coins
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                }
//            }
        }
//        service.fetchCoins { coins, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                
//                self.coins = coins ?? []
//            }
//            
//            
//        }
//   
    
}

