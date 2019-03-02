//
//  CryptoService.swift
//  Cryptocurrency
//
//  Created by Max Rybak on 3/2/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAtomic

class CryptoService {
    
    // MARK: - API request configuration values
    private var cryptoListURL = URL(fileURLWithPath: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest")
    private let apiKey = "5535990c-2062-4c5d-b476-ffdb3096ab70"
    private let start = URLQueryItem(name: "start", value: "1")
    private let limit = URLQueryItem(name: "limit", value: "5")
    private let convert = URLQueryItem(name: "convert", value: "USD")
    
    
    private func composeRequest() -> URLRequest? {
        var components = URLComponents(url: cryptoListURL, resolvingAgainstBaseURL: false)
        components?.queryItems = [start, limit, convert]
        if let url = components?.url {
            var request = URLRequest(url: url)
            request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
            return request
        } else {
            return nil
        }
    }
    
    func fetchCypto() -> Observable<[Currency]> {
        
        guard let composedRequest = composeRequest() else { return Observable.empty() }
        
        let request = Observable<URLRequest>.create {
            observer in
            observer.onNext(composedRequest)
            observer.onCompleted()
            return Disposables.create()
        }
        
        return request.flatMap {
            request in
            return URLSession.shared.rx.response(request: request).map {
                response, data in
                if 200 ..< 300 ~= response.statusCode {
                    let currencyWrapper = try JSONDecoder().decode(CurrencyWrapper.self, from: data)
                    var currency = [Currency]()
                    for elem in currencyWrapper.data {
                        currency.append(Currency(with: elem))
                    }
                    return currency
                } else {
                    throw ApiError.wentWrong
                }
            }
        }
    }
    
    
    
    
}
