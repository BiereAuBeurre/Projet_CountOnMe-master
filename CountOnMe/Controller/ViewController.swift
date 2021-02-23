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
    let calculation = Calculation()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculation.calculationDelegate = self
        calculation.clearText()
    }
    
//    private func forbidDivisionbyZero() {
//        if calculation.elements[1] == "÷" {
//            guard calculation.noDivisionByZero() else {
//                showAlert("Division par zéro impossible.")
//                viewDidLoad()
//                return
//            }
//        }
//    }
    
//    private func calculationButtonTapped(calculatingSymbol: String) {
//        if calculation.canAddOperator() {
//            calculation.calculationView.append(calculatingSymbol)
//        } else {
//            showAlert("Un operateur est déja mis !")
//        }
//    }

    @IBAction func dotButtonTapped(_ sender: UIButton) {
        guard let dot = sender.title(for: .normal) else {
            return
        }
        if calculation.expressionHaveResult() {
            calculation.clearText()
        }
        calculation.calculationView.append(dot)
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
        guard let operatorSymbol = sender.title(for: .normal) else {
            return
        }
        calculation.calculationButtonTapped(" \(operatorSymbol) ")
    }
}

extension ViewController: CalculationDelegate {
    func calculationUpdated(_ calcul: String) {
        textView.text = calcul
    }
    func showAlert(_ message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
