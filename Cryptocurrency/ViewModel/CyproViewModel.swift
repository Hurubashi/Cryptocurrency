//
//  CyproViewModel.swift
//  Cryptocurrency
//
//  Created by Max Rybak on 3/2/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import RxSwift
import RxCocoa

class CryptoViewModel {
    
    private let cryptoService = CryptoService()
    private let bag = DisposeBag()
    
    let currencies = BehaviorRelay<[Currency]>(value: [])
    let error = BehaviorRelay<ApiError?>(value: nil)
    
    init() {
        let currencyFetcher = cryptoService.fetchCypto()
        
        
        currencyFetcher.subscribe(
            onNext: {
                [weak self] elem in
                self?.currencies.accept(elem)
            },
            onError: { [weak self] error in
                if let castedError = error as? ApiError{
                    self?.error.accept(castedError)
                } else {
                    self?.error.accept(ApiError.noConnection)
                }
        })
        .disposed(by: bag)
        
    }
    
    
}
