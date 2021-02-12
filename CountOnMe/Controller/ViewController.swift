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
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func calculationButtonTapped(calculatingSymbol: String) {
        if calculation.canAddOperator(elements: elements) {
            calculation.calculationView.append(calculatingSymbol)
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    func forbidDivisionbyZero() {
        if elements[1] == "/" {
            guard calculation.noDivisionByZero(elements: elements) else {
                showAlert(message: "Division par zéro impossible !")
                viewDidLoad()
                return
            }
        }
    }
//    @IBAction func tappedNumberButton(_ sender: UIButton) {
//        guard let numberText: String = sender.title(for: .normal) else {
//            return
//        }
//        if calculator.expressionHasResult(elements: elements) {
//            textView.text = ""
//        }
//        textView.text.append(numberText)
//    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if calculation.expressionHaveResult(elements: elements) {
            calculation.clearText()
        }
        calculation.calculationView.append(numberText)
    }
    
    @IBAction func ACButton(_ sender: UIButton) {
        calculation.clearText()
    }
    
    
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        if sender == operatorButton[0] {
            calculationButtonTapped(calculatingSymbol: " + ")
        } else if sender == operatorButton[1] {
            calculationButtonTapped(calculatingSymbol: " x ")
            // Ajouter notion de priorisation du calcul égale à la division
        } else if sender == operatorButton[2] {
            calculationButtonTapped(calculatingSymbol: " / ")
            // Ajouter notion de priorisation du calcul égale à la multiplication
        } else if sender == operatorButton[3] {
            calculationButtonTapped(calculatingSymbol: " - ")
        } else if sender == operatorButton[4] {
            
            if elements.count >= 3 {
                guard calculation.expressionIsCorrect(elements: elements) else {
                    showAlert(message: "Entrez une expression correcte !")
                    return
                }
                forbidDivisionbyZero()
                if let result: String = calculation.equalExecution(elements: /*calculation.*/elements) {
                    textView.text.append(" = \(result)")
                }
            } else {
                showAlert(message: "Entrez un calcul correct")
                return
            }
        }
    }
}

extension ViewController: CalculationDelegate {
    func calculationUpdated(_ calcul: String) {
        textView.text = calcul
    }
}
