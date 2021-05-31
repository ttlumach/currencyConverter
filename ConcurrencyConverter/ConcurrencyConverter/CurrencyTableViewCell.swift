//
//  CurrencyTableViewCell.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 31.05.2021.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyTranslatedNameLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(currencyTranslatedName: String, currencyName: String) {
        currencyTranslatedNameLabel.text = currencyTranslatedName
        currencyLabel.text = currencyName
    }
}
