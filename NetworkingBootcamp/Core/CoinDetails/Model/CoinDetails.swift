//
//  CoinDetails.swift
//  NetworkingBootcamp
//
//  Created by Brandon Carr on 8/22/24.
//

import Foundation

struct CoinDetails: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let description: Description
    
}


struct Description: Codable {
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case text = "en"
    }

}

