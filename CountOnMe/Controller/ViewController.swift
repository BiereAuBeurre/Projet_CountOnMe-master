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
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveResult: Bool {
        return textView.text.firstIndex(of: "=") != nil
    }
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.text = ""
    }
    
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if expressionHaveResult {
            textView.text = ""
        }
        textView.text.append(numberText)
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Zéro!", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func calculationButtonTapped(calculatingSymbol: String) {
        if canAddOperator {
            textView.text.append(calculatingSymbol)
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        if sender == operatorButton[0] {
            calculationButtonTapped(calculatingSymbol: " + ")
        } else if sender == operatorButton[1] {
            // Code for multiplication
        } else if sender == operatorButton[2] {
            // Code for divison
        } else if sender == operatorButton[3] {
            calculationButtonTapped(calculatingSymbol: " - ")
        } else if sender == operatorButton[4] {
            guard expressionIsCorrect else {
                showAlert(message: "Entrez une expression correcte !")
                return
            }
            
            guard expressionHaveEnoughElement else {
                showAlert(message: "Démarrez un nouveau calcul !")
                return
            }
            
            // Create local copy of operations
            var operationsToReduce = elements
            
            // Iterate over operations while an operand still here
            while operationsToReduce.count > 1 {
                let left = Int(operationsToReduce[0])!
                let operand = operationsToReduce[1]
                let right = Int(operationsToReduce[2])!
                let result: String
                
                switch operand {
                case "+": result = calculation.addition(firstNumber: left, secondNumber: right)
                case "-": result = calculation.soustraction(firstNumber: left, secondNumber: right)
                default: fatalError("Unknown operator !")
                }
                // Making the operation programaticly
                operationsToReduce = Array(operationsToReduce.dropFirst(3))
                operationsToReduce.insert("\(result)", at: 0)
            }
            // Then update the view with the result
            textView.text.append(" = \(operationsToReduce.first!)")
        }
    }
}
