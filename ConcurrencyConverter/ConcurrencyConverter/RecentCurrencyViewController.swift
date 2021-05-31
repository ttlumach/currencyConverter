//
//  RecentCurrencyViewController.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 30.05.2021.
//

import UIKit
import Foundation

class RecentCurrencyViewController: UIViewController {

    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var currencyFrom: String = "" {
        didSet {
            update()
        }
    }
    var currencyTo: String = "" {
        didSet {
            update()
        }
    }
    
    var rate: Double = 0 {
        didSet {
            update()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    func update() {
        reloadDate()
        setCurrencyLabel()
    }
    
    func reloadDate() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        
        dateTimeLabel.text = dateFormatter.string(from: date)
    }
    
    func setCurrencyLabel() {
        currencyLabel.text = "1 \(currencyFrom) = \(rate) \(currencyTo)"
    }

    @IBAction func reloadButtonTapped(_ sender: UIButton) {
        update()
    }
}
