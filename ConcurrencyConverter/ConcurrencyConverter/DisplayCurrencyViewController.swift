//
//  DisplayCurrencyViewController.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 30.05.2021.
//

import UIKit

protocol DisplayCurrencyViewControllerDelegate: class {
    func currencyFromLabelTapped()
    func currencyToLabelTapped()
}

class DisplayCurrencyViewController: UIViewController {
    @IBOutlet weak var currency1StackView: UIStackView!
    @IBOutlet weak var currency2StackView: UIStackView!
    
    @IBOutlet weak var currency1NameLabel: UILabel!
    @IBOutlet weak var currency2NameLabel: UILabel!
    
    @IBOutlet weak var currency1ValueLabel: UILabel!{
        didSet {
            currency1ValueLabel.adjustsFontSizeToFitWidth = true
            currency1ValueLabel.minimumScaleFactor = 0.5
        }
    }
    
    @IBOutlet weak var currency2ValueLabel: UILabel! {
        didSet {
            currency2ValueLabel.adjustsFontSizeToFitWidth = true
            currency2ValueLabel.minimumScaleFactor = 0.5
        }
    }
    
    
    weak var delegate: DisplayCurrencyViewControllerDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(currency1Tapped))
        currency1StackView.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(currency2Tapped))
        currency2StackView.addGestureRecognizer(tap2)
    }
    
    func setCurrencyValues(currency1Name: String, currency1Value: String, currency2Name: String, currency2Value: String) {
        currency1NameLabel.text = currency1Name
        currency1ValueLabel.text = currency1Value
        currency2NameLabel.text = currency2Name
        currency2ValueLabel.text = currency2Value
    }

    @objc func currency1Tapped(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.currencyFromLabelTapped()
    }
    
    @objc func currency2Tapped(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.currencyToLabelTapped()
    }
}
