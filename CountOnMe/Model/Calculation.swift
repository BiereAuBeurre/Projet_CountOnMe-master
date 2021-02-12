//
//  Calculation.swift
//  CountOnMe
//
//  Created by Manon Russo on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

protocol CalculationDelegate: class {
    func calculationUpdated(_ calcul: String)
}

import Foundation

class Calculation {
    // MARK: -Model properties
    var calculationDelegate: CalculationDelegate?
    var calculationView: String = "" {
        didSet {
            calculationDelegate?.calculationUpdated(calculationView)
        }
    }
    var elements: [String] {
        return calculationView.split(separator: " ").map { "\($0)" }
    }
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }

    var noDivisionByZero: Bool {
        return elements[2] != "\(0)"
    }
    
    var expressionHaveResult: Bool {
        return calculationView.firstIndex(of: "=") != nil
    }
    
    // MARK: - Calcul methods
    func addition(firstNumber: Int, secondNumber: Int) -> String {
        let result = firstNumber + secondNumber
        return "\(result)"
    }
    
    func soustraction(firstNumber: Int, secondNumber: Int) -> String {
        let result = firstNumber - secondNumber
        return "\(result)"
    }
    
    func divide (firstNumber: Int, secondNumber:Int) -> String {
        let result = firstNumber / secondNumber
        return "\(result)"
        
    }
    
    func multiplication(firstNumber:Int, secondNumber: Int) -> String {
        let result = firstNumber * secondNumber
        return "\(result)"
    }
    
    func equalExecution() /*-> [String]*/ {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            let result: String
            
            switch operand {
            case "+": result = addition(firstNumber: left, secondNumber: right)
            case "-": result = soustraction(firstNumber: left, secondNumber: right)
            case "/": result = divide(firstNumber: left, secondNumber: right)
            case "x": result = multiplication(firstNumber: left, secondNumber: right)
            default: fatalError("Unknown operator !")
            }
            
            // Making the operation programaticly and cleaning the calcul for the result only (preventing additionals calculation tapped by user before tapping equal button)
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
            
            // Then update the textView with the result
            calculationView.append(" = \(operationsToReduce.first!)")
        }
    }
}
