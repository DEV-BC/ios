//
//  CoinDetailsCache.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/22/24.
//

import Foundation
class CoinDetailsCache {
    
    //being able to share this cache with the entire application - don't want multiple cache instances in app. want app to use one instance. Better to use dependency injection
    static let shared = CoinDetailsCache()
    //this type of cache will clear when the app is restarted
    //has built in functionality to where is memory is running low, it will remove the least looked at cache stored. For example if its data that you didn't look at in an hour compared to the other stuff, it will delete that
    private let cache = NSCache<NSString, NSData>()
    
    func set(_ coinDetails: CoinDetails, forKey key: String) {
        guard let data = try? JSONEncoder().encode(coinDetails) else { return }
        
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> CoinDetails? {
        guard let data = cache.object(forKey: key as NSString) as? Data else { return nil}
        
        return try? JSONDecoder().decode(CoinDetails.self, from: data)
    }
}
