//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var operatorButton: [UIButton]!
    
    let calculation = Calculation()
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculation.calculationDelegate = self
        calculation.clearText()
    }
    
    private func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func calculationButtonTapped(calculatingSymbol: String) {
        if calculation.canAddOperator(elements) {
            calculation.calculationView.append(calculatingSymbol)
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
    }

    @IBAction func dotButtonTapped(_ sender: UIButton) {
        guard let dot = sender.title(for: .normal) else {
            return
        }
        if calculation.expressionHaveResult(elements) {
            calculation.clearText()
        }
        calculation.calculationView.append(dot)
    }
    
    private func forbidDivisionbyZero() {
        if elements[1] == "÷" {
            guard calculation.noDivisionByZero(elements) else {
                showAlert(message: "Erreur : division par zéro impossible !")
                viewDidLoad()
                return
            }
        }
    }
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if calculation.expressionHaveResult(elements) {
            calculation.clearText()
        }
        calculation.calculationView.append(numberText)
    }
    
    @IBAction func ACButtonTapped(_ sender: UIButton) {
        calculation.clearText()

    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        if elements.count >= 3 {
            guard calculation.expressionIsCorrect(elements) else {
                showAlert(message: "Entrez une expression correcte !")
                return
            }
            forbidDivisionbyZero()
            if let result: String = calculation.equalExecution(elements) {
                textView.text.append(" = \(result)")
            }
        } else {
            showAlert(message: "Entrez un calcul correct")
            return
        }
    }
    
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        guard let operatorSymbol = sender.title(for: .normal) else {
            return
        }
        calculationButtonTapped(calculatingSymbol: " \(operatorSymbol) ")
    }
    
}

extension ViewController: CalculationDelegate {
    func calculationUpdated(_ calcul: String) {
        textView.text = calcul
    }
}
