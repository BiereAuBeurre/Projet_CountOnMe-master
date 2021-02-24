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
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculation.delegate = self
        calculation.clearText()
    }
}

private extension CalculationViewController {
    @IBAction func didTapDotButton(_ sender: UIButton) {
        guard let dot = sender.title(for: .normal) else {
            return
        }
        calculation.addNumber(numbers: dot)
    }
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        calculation.addNumber(numbers: numberText)
    }
    
    @IBAction func ACButtonTapped(_ sender: UIButton) {
        calculation.clearText()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        calculation.calculatingAndDiplayingResult()
    }
    
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
//        calculation.addSymbol(symbols: operatorSymbol)
        guard let operatorSymbol = sender.title(for: .normal) else {
            return
        }
        calculation.addCalculatingSymbol(" \(operatorSymbol) ")
    }
}

extension CalculationViewController: CalculationDelegate {
    func calculationUpdated(_ calcul: String) {
        textView.text = calcul
    }
    func showAlert(_ message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
