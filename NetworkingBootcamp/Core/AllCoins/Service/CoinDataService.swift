//
//  CoinDataService.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/21/24.
//

import Foundation



class CoinDataService: HTTPDataDownloader {
    
    func fetchCoinsAsync()  async throws -> [Coin] {
        
        guard let endpoint = allCoinsUrlString else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
       
        return try await fetchData(as: [Coin].self, endpoint: endpoint)
        
        
    }
    
    func fetchCoinDetails(id: String) async throws -> CoinDetails? {
        //check if data is already in cache? if not make an api call to get data
        if let cache = CoinDetailsCache.shared.get(forKey: id) {
            print("Got details from cache")
            return cache
        }
        guard let endpoint = fetchCoinDetailsUrlString(id: id) else {
            throw CoinAPIError.requestFailed(description: "Invalid URL")
        }
        //get the data from api and then store it in cache
        let details = try await fetchData(as: CoinDetails.self, endpoint: endpoint)
        print("Got from API")
        CoinDetailsCache.shared.set(details, forKey: id)
        
        return details
    }
    
    
    private var baseUrlComponenets: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.coingecko.com"
        components.path = "/api/v3/coins/"
        
        return components
    }
    //have to return a string
    private var allCoinsUrlString: String? {
        var components = baseUrlComponenets
        components.path += "markets"
        
        components.queryItems = [
            .init(name: "vs_currency", value: "usd"),
            .init(name: "order", value: "market_cap_desc"),
            .init(name: "per_page", value: "20"),
            .init(name: "page", value: "1"),
            .init(name: "sparkline", value: "false"),
            .init(name: "price_change_percentage", value: "24"),
            .init(name: "locale", value: "en")
        ]
        
        return components.url?.absoluteString //cast to a string from url
    }
   
   //since we have to get the id from somewhere else, we need to create a function to pass the id into it
    private func fetchCoinDetailsUrlString(id: String) -> String? {
        var components = baseUrlComponenets
        components.path += "\(id)"
        
        return components.url?.absoluteString
    }
    
   
    
}

//MARK: - Completion Handler
extension CoinDataService {
    
    func fetchCoinsWithResult(completion: @escaping(Result<[Coin], CoinAPIError>) -> Void) {
        guard let url = URL(string: allCoinsUrlString ?? "") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.unknownError(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request Failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalidStatusCode(statusCode: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch { //swift implicitly does the let error
                print("Failed to decode with error: \(error)")
                completion(.failure(.jsonParsingFailure))
            }
           
        }.resume()
    }
    
    func fetchCoins(completion: @escaping([Coin]?, Error?) -> Void) {
        guard let url = URL(string: allCoinsUrlString ?? "") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                print("Failed to decode coins")
                return
            }
            
            completion(coins, nil)
        }.resume()
    }
    

    func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
    print(Thread.current) //what Thread are we on? This returns the current thread object
    let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=usd"
    guard let url = URL(string: urlString) else { return } //this converts string to an actual URL object thats used to reach out to internet
    
    
    //completion handler (asynchronuously)
    URLSession.shared.dataTask(with: url) { data, response, error in
       
        if let error = error {
            print("DEBUG: Failed with error: \(error.localizedDescription)")
            return
        }
        guard let data = data else { return }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {return}
        
        guard let value = jsonObject[coin] as? [String: Double] else {
            print("Failed to parse data")
            return
        }
        guard let price = value["usd"] else { return }
        DispatchQueue.main.async {
           
//            self.coin = coin.capitalized
//            self.price = "$\(price)"
            completion(price)
        }
    }.resume()
    
    print("Did reach end of function...")
    }
    
}
