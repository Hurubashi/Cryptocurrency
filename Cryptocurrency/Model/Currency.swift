//
//  Currency.swift
//  Cryptocurrency
//
//  Created by Max Rybak on 3/2/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import Foundation

struct CurrencyWrapper: Decodable {
    
    let data: [Currency]
    
    struct Currency: Decodable {
        
        let name: String
        let symbol: String
        let quote: Quote
        struct Quote: Decodable {
            
            let USD: USD
            struct USD: Decodable {
                let price: Double
            }
        }
        
    }
}

struct Currency {
    let name: String
    let symbol: String
    let price: Double
    
    init(with data: CurrencyWrapper.Currency) {
        name = data.name
        symbol = data.symbol
        price = data.quote.USD.price
    }
}
