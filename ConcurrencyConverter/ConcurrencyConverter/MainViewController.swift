//
//  ViewController.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 30.05.2021.
//

import UIKit

class MainViewController: UIViewController {
    private enum ConstantsVC: String {
        case displayVCid = "DisplayCurrencyViewController"
        case buttonsVCid = "NumberButtonsViewController"
        case footerVCid = "RecentCurrencyViewController"
        case pickerVCid = "CurrencyTableViewController"
    }
    
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    weak var displayViewController: DisplayCurrencyViewController!
    weak var buttonsViewController: NumberButtonsViewController!
    weak var footerViewController: RecentCurrencyViewController!
    var currencyPickerTableViewController: CurrencyTableViewController? = nil
    
    let rateService = RateServiceMock()
    var rateConverter: RateConverter!
    var currencyDataToPresent: [CurrencyTableViewControllerCellData] = []
    
    var isCurrency1Picking = false
    var isCurrency2Picking = false
    
    var selectedCurrencyFrom: DataConstants.Currency = .USD {
        didSet {
            currencyDidChange(isCurrencyFrom: true, isCurrencyTo: false)
        }
    }
    var selectedCurrencyFromValue: String = "0" {
        didSet {
            if selectedCurrencyFromValue.count > 13 {
                selectedCurrencyFromValue = String(selectedCurrencyFromValue.prefix(13))
            } else {
                
            }
            displayViewController.currency1ValueLabel.text = String(selectedCurrencyFromValue)
        }
    }
    var selectedCurrencyTo: DataConstants.Currency = .UAH {
        didSet {
            currencyDidChange(isCurrencyFrom: false, isCurrencyTo: true)
        }
    }
    
    var selectedCurrencyToValue: String = "0" {
        didSet {
            displayViewController.currency2ValueLabel.text = String(selectedCurrencyToValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        setup()
    }
    
    func setup() {
        rateService.getExchangeRate { (result, error) in
            if let error = error {
                print(error)
            }
            if let result = result {
                self.rateConverter = RateConverter(rateData: result.rates)
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let displayVC = storyboard.instantiateViewController(withIdentifier: ConstantsVC.displayVCid.rawValue)
        self.displayView.addSubview(displayVC.view)
        self.addChild(displayVC)
        displayVC.view.frame = displayView.bounds
        displayVC.didMove(toParent: self)
        displayViewController = displayVC as? DisplayCurrencyViewController
        
        let buttonsVC = storyboard.instantiateViewController(withIdentifier: ConstantsVC.buttonsVCid.rawValue)
        self.buttonsView.addSubview(buttonsVC.view)
        self.addChild(buttonsVC)
        buttonsVC.view.frame = buttonsView.bounds
        buttonsVC.didMove(toParent: self)
        buttonsViewController = buttonsVC as? NumberButtonsViewController
        
        let footerVC = storyboard.instantiateViewController(withIdentifier: ConstantsVC.footerVCid.rawValue)
        self.footerView.addSubview(footerVC.view)
        self.addChild(footerVC)
        footerVC.view.frame = footerView.bounds
        footerVC.didMove(toParent: self)
        footerViewController = footerVC as? RecentCurrencyViewController
        currencyDidChange(isCurrencyFrom: true, isCurrencyTo: true)
        
        let pickerVC = storyboard.instantiateViewController(withIdentifier: ConstantsVC.pickerVCid.rawValue)
        currencyPickerTableViewController = pickerVC as? CurrencyTableViewController
        
        setupCurrencyPicker()
        currencyPickerTableViewController?.delegate = self
        currencyPickerTableViewController?.dataSource = self
        currencyPickerTableViewController?.view.frame = self.view.frame
        displayViewController.delegate = self
        buttonsViewController.delegate = self
    }
    
    func currencyDidChange(isCurrencyFrom: Bool, isCurrencyTo: Bool){
        
        if isCurrencyFrom {
            displayViewController.currency1NameLabel.text = selectedCurrencyFrom.rawValue
            footerViewController?.currencyFrom = selectedCurrencyFrom.rawValue
          
            guard let rate = rateConverter?.convert(amount: 1, currency: selectedCurrencyFrom, into: selectedCurrencyTo) else { return }
            footerViewController?.rate = rate
        }
        if isCurrencyTo {
            displayViewController.currency2NameLabel.text = selectedCurrencyTo.rawValue
            footerViewController?.currencyTo = selectedCurrencyTo.rawValue
            
            guard let rate = rateConverter?.convert(amount: 1, currency: selectedCurrencyFrom, into: selectedCurrencyTo) else { return }
            footerViewController?.rate = rate
        }
    }
    
    func countCurrency() { 
        if let amount = Double(selectedCurrencyFromValue) {
            selectedCurrencyToValue = String(rateConverter.convert(amount: amount, currency: selectedCurrencyFrom, into: selectedCurrencyTo))
        } else if let amount = Double(selectedCurrencyFromValue.dropLast()) {
            selectedCurrencyToValue = String(rateConverter.convert(amount: amount, currency: selectedCurrencyFrom, into: selectedCurrencyTo))
        } else {
            return
        }
    }
}

extension MainViewController: NumberButtonsViewControllerDelegate {
    func buttonPressed(button: Button) {
        var currentValue = String(selectedCurrencyFromValue)
        if String(selectedCurrencyFromValue) == "0" && button != .coma && button != .go && button != .go {
            currentValue = ""
        }
        
        switch button {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            currentValue = currentValue + String(button.rawValue)
        case .coma:
            currentValue = currentValue + "."
        case .removeOne:
            currentValue = String(currentValue.dropLast())
            if currentValue == "" {
                currentValue = "0"
            }
        case .removeAll:
            currentValue = "0"
        case .replace:
            let cur1Raw = selectedCurrencyFrom.rawValue
            let replaceCurrency = DataConstants.Currency(rawValue: cur1Raw)!
            selectedCurrencyFrom = selectedCurrencyTo
            selectedCurrencyTo = replaceCurrency
            
            countCurrency()
            print("")
        case .go:
            countCurrency()
        }
        
        selectedCurrencyFromValue = currentValue
    }
}

extension MainViewController: DisplayCurrencyViewControllerDelegate {
    func currencyFromLabelTapped() {
        guard currencyPickerTableViewController != nil else { return }
        present(currencyPickerTableViewController!, animated: true, completion: nil)
        isCurrency1Picking = true
        
    }
    
    func currencyToLabelTapped() {
        guard currencyPickerTableViewController != nil else { return }
        present(currencyPickerTableViewController!, animated: true, completion: nil)
        isCurrency2Picking = true
    }
    
}

extension MainViewController: CurrencyTableViewControllerDelegate {
    func currencyPicked(currency: DataConstants.Currency) {
        if isCurrency1Picking {
            selectedCurrencyFrom = currency
            isCurrency1Picking = false
            dismiss(animated: true, completion: nil)
        } else if isCurrency2Picking {
            selectedCurrencyTo = currency
            isCurrency2Picking = false
            dismiss(animated: true, completion: nil)
        }
    }
}

extension MainViewController: CurrencyTableViewControllerDataSource {
    func setupCurrencyPicker() {
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.CNY, currencyName: DataConstants.СurrencyTranslatedNames.CNY))
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.CZK, currencyName: DataConstants.СurrencyTranslatedNames.CZK))
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.EUR, currencyName: DataConstants.СurrencyTranslatedNames.EUR))
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.GBP, currencyName: DataConstants.СurrencyTranslatedNames.GBP))
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.PLN, currencyName: DataConstants.СurrencyTranslatedNames.PLN))
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.RUB, currencyName: DataConstants.СurrencyTranslatedNames.RUB))
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.TRY, currencyName: DataConstants.СurrencyTranslatedNames.TRY))
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.USD, currencyName: DataConstants.СurrencyTranslatedNames.USD))
        currencyDataToPresent.append(CurrencyTableViewControllerCellData(currency: DataConstants.Currency.UAH, currencyName: DataConstants.СurrencyTranslatedNames.UAH))
    }
}

