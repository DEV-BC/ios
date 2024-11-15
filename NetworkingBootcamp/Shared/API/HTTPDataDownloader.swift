//
//  HTTPDataDownloader.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/22/24.
//

import Foundation

//created a protocol that way function is accessible to everyone who conforms to the protocol. More Services may want to use the fetch data func so don't want it limited to just the CoinDataService class
protocol HTTPDataDownloader {
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String) async throws -> T
}
//because fetchData will do the same thing everytime, we can implement it in an extension. IF it was going to do something different for each class that conforms to it, then the implementation would happen in that specific class
extension HTTPDataDownloader {
    
    func fetchData<T: Decodable>(as type: T.Type, endpoint: String) async throws -> T { //as type T.Type - what type you want it to return be
        guard let url = URL(string: endpoint) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
           throw CoinAPIError.requestFailed(description: "Request Failed")
        }
        
        guard httpResponse.statusCode == 200 else {
           throw CoinAPIError.invalidStatusCode(statusCode: httpResponse.statusCode)
            
        }
        
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Error: \(error)")
            throw error as? CoinAPIError ?? .unknownError(error: error)
        }
    }
    
}
