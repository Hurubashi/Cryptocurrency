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
        
        viewModel.currencies.bind(to: tableView.rx.items(cellIdentifier: "cell")) {
            row, currency, cell in
            cell.textLabel?.text = currency.name
        }.disposed(by: bag)
        
    }

}
