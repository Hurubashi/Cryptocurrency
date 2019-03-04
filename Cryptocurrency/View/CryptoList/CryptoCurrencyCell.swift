//
//  CryptoCurrencyCell.swift
//  Cryptocurrency
//
//  Created by Max Rybak on 3/2/19.
//  Copyright © 2019 Max Rybak. All rights reserved.
//

import UIKit

class CryptoCurrencyCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var price: UILabel!
    
    func initCell(with currency: Currency) {
        name.text = currency.name
        symbol.text = currency.symbol
        price.text = String(describing: currency.price)
        picture.image = UIImage(named: currency.name) ?? UIImage(named: "Iconomi")
    }
    
}
