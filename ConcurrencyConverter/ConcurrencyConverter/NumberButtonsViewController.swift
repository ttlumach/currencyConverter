//
//  NumberButtonsViewController.swift
//  ConcurrencyConverter
//
//  Created by Anton Melnychuk on 30.05.2021.
//

import UIKit

enum Button: Int {
    case zero, one, two, three, four, five, six, seven, eight, nine, coma, removeOne, replace, removeAll, go
}

protocol NumberButtonsViewControllerDelegate: class {
    func buttonPressed(button: Button)
}

class NumberButtonsViewController: UIViewController {
    
    weak var delegate: NumberButtonsViewControllerDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let pressedButton = Button(rawValue: sender.tag) else { return }
        delegate?.buttonPressed(button: pressedButton)
    }
}
