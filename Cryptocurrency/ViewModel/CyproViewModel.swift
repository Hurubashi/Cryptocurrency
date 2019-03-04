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

    init() {
        let currencyFetcher = cryptoService.fetchCypto()
        
        currencyFetcher.subscribe {
            [weak self] elem in
            if let newCurrencies = elem.element {
                self?.currencies.accept(newCurrencies)
            }
        }.disposed(by: bag)
        
    }
    
    
}
