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
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        calculation.calculationDelegate = self
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if calculation.expressionHaveResult {
            calculation.calculationView = ""
        }
        calculation.calculationView.append(numberText)
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func calculationButtonTapped(calculatingSymbol: String) {
        if calculation.canAddOperator {
            calculation.calculationView.append(calculatingSymbol)
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
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
            guard calculation.expressionIsCorrect else {
                showAlert(message: "Entrez une expression correcte !")
                return
            }
            guard calculation.expressionHaveEnoughElement else {
                showAlert(message: "Démarrez un nouveau calcul !")
                return
            }
            if calculation.elements[1] == "/" {
                guard calculation.noDivisionByZero else {
                    showAlert(message: "Division par zéro impossible !")
                    calculation.calculationView = ""
                    return
                }
            }
            calculation.equalExecution()
        }
    }
}

extension ViewController: CalculationDelegate {
    func calculationUpdated(_ calcul: String) {
        textView.text = calcul
    }
}
