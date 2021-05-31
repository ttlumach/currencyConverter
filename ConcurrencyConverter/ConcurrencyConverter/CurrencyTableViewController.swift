//
//  CurrencyTableViewController.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 31.05.2021.
//

import UIKit
struct CurrencyTableViewControllerCellData {
    let currency: DataConstants.Currency
    let currencyName: DataConstants.СurrencyTranslatedNames
}

protocol CurrencyTableViewControllerDelegate: class {
    func currencyPicked(currency: DataConstants.Currency)
}

protocol CurrencyTableViewControllerDataSource: class {
    var currencyDataToPresent: [CurrencyTableViewControllerCellData] { get set }
}

class CurrencyTableViewController: UITableViewController {

    var cellId = "CurrencyTableViewCell"
    weak var delegate: CurrencyTableViewControllerDelegate! = nil
    weak var dataSource: CurrencyTableViewControllerDataSource! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        tableView.register(UINib(nibName: cellId, bundle: nil), forCellReuseIdentifier: cellId)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.currencyDataToPresent.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CurrencyTableViewCell
        let currency = dataSource.currencyDataToPresent[indexPath.row].currency.rawValue
        let currencyName = dataSource.currencyDataToPresent[indexPath.row].currencyName.rawValue
        
        cell.setup(currencyTranslatedName: currencyName, currencyName: currency)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickedCurrency = dataSource.currencyDataToPresent[indexPath.row].currency
        delegate.currencyPicked(currency: pickedCurrency)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
