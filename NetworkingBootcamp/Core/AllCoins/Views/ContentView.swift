//
//  ContentView.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/21/24.
//

import SwiftUI

struct ContentView: View {
    private let service = CoinDataService()
    
    @StateObject var viewModel: CoinsViewModel

    
    init(service: CoinDataService) {
        self.service = service
        self._viewModel = StateObject(wrappedValue: CoinsViewModel(service: service))
    }
    
    var body: some View {
        
        NavigationStack {
            List {
                    
                    ForEach(viewModel.coins) { coin in
                        NavigationLink(value: coin) {
                            HStack(spacing: 16) {
                                Text("\(coin.marketCapRank)")
                                    .foregroundColor(.gray)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(coin.name)
                                        .fontWeight(.semibold)
                                    
                                    Text(coin.symbol.uppercased())
                                }
                            }
                            .font(.footnote)
                        }
                    }
                }
            .navigationDestination(for: Coin.self, destination: { coin in
                CoinDetailsView(coin: coin, service: service)
            })
                .overlay {
                    if let error = viewModel.errorMessage {
                        Text(error)
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
