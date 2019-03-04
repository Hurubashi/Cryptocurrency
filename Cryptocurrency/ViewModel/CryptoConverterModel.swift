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
    
    let firstCurrency = BehaviorRelay(value: Currency(name: "mockValue", symbol: "mockValue", price: 0))
    let secondCurrency = BehaviorRelay(value: Currency(name: "USD", symbol: "USD", price: 1))
    
    let firstAmount = BehaviorRelay(value: "")
    let secondAmount = BehaviorRelay(value: "")
    
    let keyboardObserver = PublishSubject<String>()
    let valueSwitcher = PublishRelay<UITapGestureRecognizer>()
    
    init() {
        subscribeToKeyboardObserver()
        bindFirstAmountToSecond()
        subscribeToValueSwitcher()
    }
    
    // Manage CollectionView Keyboard
    func subscribeToKeyboardObserver() {
        keyboardObserver
        .subscribe {
            [weak self] event in
            let current = self?.firstAmount.value ?? ""
            if let newElem = event.element {
                if newElem == "CE" {
                    self?.firstAmount.accept("")
                } else if (current == "0"), newElem != "." {
                    self?.firstAmount.accept(newElem)
                } else if current.count < 10 , !(newElem == "0" && current == "0"),
                    !(current.contains(".") && newElem == ".") {
                    self?.firstAmount.accept(current + newElem)
                }
            }
        }
        .disposed(by: bag)
    }
    
    // Calculate second currencyAmount based on firstAmount
    func bindFirstAmountToSecond() {
        firstAmount.map {
            [weak self] elem in
            var num = 0.0
            if self?.secondCurrency.value.name == "USD" {
                num = ((Double(elem) ?? 0) * (self?.firstCurrency.value.price ?? 0) )
            } else {
                if (self?.firstCurrency.value.price ?? 0) < 1.0 {
                    num = ((Double(elem) ?? 0) * (self?.secondCurrency.value.price ?? 0) )
                } else {
                    num = ((Double(elem) ?? 0) / (self?.secondCurrency.value.price ?? 1) )
                }
            }
            return String(num)
        }
        .bind(to: secondAmount)
        .disposed(by: bag)
    }
    
    // Subscribe to valueSwitcher that binded to arrowView,
    // upon tap gesture switch currencies and amounts
    func subscribeToValueSwitcher() {
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
