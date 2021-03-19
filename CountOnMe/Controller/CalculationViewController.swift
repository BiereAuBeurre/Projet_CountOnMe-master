//
//  CalculationViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

final class CalculationViewController: UIViewController {
    @IBOutlet private weak var textView: UITextView!
    private let calculation = Calculation()
    
    /// View Life cycles.
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(calculationUpdated), name: Notification.Name("update"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showDivisionAlert), name: Notification.Name("alert"), object: nil)
        calculation.clearText()
    }
}

private extension CalculationViewController {
    /// View actions
    @IBAction func didTapNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculation.addNumber(numberText)
    }
    
    @IBAction func didTapACButton(_ sender: UIButton) {
        calculation.clearText()
    }
    
    @IBAction func didTapEqualButton(_ sender: UIButton) {
        calculation.displayResult()
    }
    
    @IBAction func didTapOperatorButton(_ sender: UIButton) {
        guard let operatorSymbol = sender.title(for: .normal) else {
            return
        }
        calculation.addCalculatingSymbol(" \(operatorSymbol) ")
    }
    
    @objc func calculationUpdated() {
        textView.text = calculation.displayableCalculText
    }
    
    @objc func showDivisionAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Division par zéro impossible", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }

}


