//
//  CoinDetailsView.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/21/24.
//

import SwiftUI

struct CoinDetailsView: View {
    let coin: Coin
    @ObservedObject var viewModel: CoinDetailsViewModel
//    @State private var task: Task<(), Never>?
    init(coin: Coin, service: CoinDataService) {
        self.coin = coin
        self.viewModel = CoinDetailsViewModel(coinId: coin.id, service: service)
    }
    var body: some View {
        
        VStack(alignment: .leading) {
            if let coinDetails = viewModel.coinDetails {
                Text(coinDetails.name)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                
                Text(coinDetails.symbol.uppercased())
                    .font(.footnote)
                
                Text(coinDetails.description.text)
                    .font(.footnote)
                    .padding(.vertical)
            }
            
        }
        .task {
            await viewModel.fetchCoinDetails()
        }
//        .onAppear {
//            self.task = Task { await viewModel.fetchCoinDetails() }
//            
//        }
//        .onDisappear {
//            task?.cancel()
//        }
        .padding()
        
       
    }
    
}

//#Preview {
//    CoinDetailsView()
//}
