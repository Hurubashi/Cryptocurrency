//
//  CryptoConverterVC.swift
//  Cryptocurrency
//
//  Created by Max Rybak on 3/3/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CryptoConverterVC: UIViewController {

    @IBOutlet weak var firstCurrencyName: UILabel!
    @IBOutlet weak var secondCurrencyName: UILabel!
    @IBOutlet weak var firsCurrencyImg: UIImageView!
    @IBOutlet weak var secondCurrencyImg: UIImageView!
    
    @IBOutlet weak var firstCurrencyAmount: UILabel!
    @IBOutlet weak var secondCurrencyAmount: UILabel!
    
    @IBOutlet weak var arrowView: UIView!
    
    let viewModel = CryptoConverterModel()
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setUpCollectionView()
    }

    // MARK: - Set up UI
    private func setUpUI() {
        
        // Creating Gesture to Switch currencies and bind to model
        let tap = UITapGestureRecognizer()
        arrowView.addGestureRecognizer(tap)
        
        tap.rx.event
            .bind(to: viewModel.valueSwitcher)
            .disposed(by: bag)
        
        // Binds to Amounts Outlets
        viewModel.firstAmount.bind {
            [weak self] elem in
            self?.firstCurrencyAmount.text = elem
        }
        .disposed(by: bag)
        
        viewModel.secondAmount.bind {
            [weak self] elem in
            self?.secondCurrencyAmount.text = elem
        }
        .disposed(by: bag)
        
        // Binds to Currency info
        viewModel.firstCurrency.bind {
            [weak self] currency in
            self?.firstCurrencyName.text = currency.symbol
            self?.firsCurrencyImg.image = UIImage(named: currency.name) ?? UIImage(named: "Iconomi")
        }
        .disposed(by: bag)

        viewModel.secondCurrency.bind {
            [weak self] currency in
            self?.secondCurrencyName.text = currency.symbol
            self?.secondCurrencyImg.image = UIImage(named: currency.name) ?? UIImage(named: "Iconomi")
        }
        .disposed(by: bag)
        
    }
    
    // MARK: - Creating Keyboard with CollectionView
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let items = BehaviorRelay(value: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "CE", "0", "."])
    
    private func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ConverterCell", bundle: nil), forCellWithReuseIdentifier: "ConverterCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(layoutCollectionView),
                                               name: UIDevice.orientationDidChangeNotification, object: nil)
        
        items.bind(to: collectionView.rx.items(cellIdentifier: "ConverterCell", cellType: ConverterCell.self)) {
            row, item, cell in
            cell.textLabel.text = item
        }
        .disposed(by: bag)
        
        collectionView.rx.modelSelected(String.self)
            .bind(to: viewModel.keyboardObserver)
            .disposed(by: bag)
        
    }
    
    @objc func layoutCollectionView() {
        collectionView.reloadData()
    }
    

}

// CollectionView cell size calculation
extension CryptoConverterVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height / 4)
    }
}
