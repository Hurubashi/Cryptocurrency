//
//  CryptoConverterModel.swift
//  Cryptocurrency
//
//  Created by Max Rybak on 3/3/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import RxSwift
import RxCocoa

class CryptoConverterModel {
    
    private let bag = DisposeBag()
    
    let firstCurrency = BehaviorRelay(value: Currency(name: "NIL", symbol: "NIL", price: 1))
    let secondCurrency = BehaviorRelay(value: Currency(name: "USD", symbol: "USD", price: 1))
    
    let firstAmount = BehaviorRelay(value: "0.0")
    let secondAmount = BehaviorRelay(value: "")
    
    let keyboardObserver = PublishSubject<String>()
    
    let valueSwitcher = PublishRelay<UITapGestureRecognizer>()
    
    init() {
        
        keyboardObserver
        .subscribe {
            [weak self] event in
            let current = self?.firstAmount.value ?? ""
            if let newElem = event.element {
                if newElem == "CE" {
                    self?.firstAmount.accept("0.0")
                } else if current == "0.0", newElem != "." {
                    self?.firstAmount.accept(newElem)
                } else if current.count < 9 , !(newElem == "0" && current == "0"),
                    !(current.contains(".") && newElem == ".") {
                    self?.firstAmount.accept(current + newElem)
                }
            }
        }
        .disposed(by: bag)

        firstAmount.map {
            [weak self] elem in
            let num = ((Double(elem) ?? 0) * (self?.firstCurrency.value.price ?? 0) )
            return String(num)
            }
        .bind(to: secondAmount)
        .disposed(by: bag)

        valueSwitcher
        .subscribe(onNext: {
            [weak self] recognizer in
            
            if let first = self?.firstCurrency.value,
                let second = self?.secondCurrency.value {
                self?.firstCurrency.accept(second)
                self?.secondCurrency.accept(first)
            }
            
            if let firstAmount = self?.firstAmount.value,
                let secondAmount = self?.secondAmount.value {
                self?.firstAmount.accept(secondAmount)
                self?.secondAmount.accept(firstAmount)
            }
        })
        .disposed(by: bag)

    }
    
}
