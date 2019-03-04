//
//  CryptoListVC.swift
//  Cryptocurrency
//
//  Created by Max Rybak on 3/1/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CryptoListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel = CryptoViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CryptoCurrencyCell", bundle: nil), forCellReuseIdentifier: "CryptoCell")
        
        viewModel.currencies.bind(to: tableView.rx.items(cellIdentifier: "CryptoCell", cellType: CryptoCurrencyCell.self)) {
            row, currency, cell in
            cell.initCell(with: currency)
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Currency.self).subscribe {
            [weak self] currencyEvent in
            let vc = CryptoConverterVC(nibName: "CryptoConverterVC", bundle: nil)
            vc.viewModel.firstCurrency.accept(currencyEvent.element!)
            self?.navigationController!.pushViewController(vc , animated: true)
        }.disposed(by: bag)
    }

}
