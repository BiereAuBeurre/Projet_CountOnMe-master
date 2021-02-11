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
        textView.text = ""
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        if calculation.expressionHaveResult {
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
        if calculation.canAddOperator {
            textView.text.append(calculatingSymbol)
        } else {
            showAlert(message: "Un operateur est déja mis !")
        }
    }
    
    @IBAction func tappedOperatorButton(_ sender: UIButton) {
        if sender == operatorButton[0] {
            calculationButtonTapped(calculatingSymbol: " + ")
        } else if sender == operatorButton[1] {
            calculationButtonTapped(calculatingSymbol: " x ")
        } else if sender == operatorButton[2] {
            calculationButtonTapped(calculatingSymbol: " / ")
        } else if sender == operatorButton[3] {
            calculationButtonTapped(calculatingSymbol: " - ")
        } else if sender == operatorButton[4] {
            
            let operationsToReduce = calculation.equalExecution()
            // Then update the view with the result
            textView.text.append(" = \(operationsToReduce.first!)")
        }
    }
}
