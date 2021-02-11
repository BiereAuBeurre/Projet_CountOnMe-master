//
//  Calculation.swift
//  CountOnMe
//
//  Created by Manon Russo on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculation {
    
    var elements: [String] {
        return textView.text.split(separator: " ").map { "\($0)" }
    }
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
    
    func equalExecution() -> [String] {
        
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            let result: String
            
            switch operand {
            case "+": result = addition(firstNumber: left, secondNumber: right)
            case "-": result = soustraction(firstNumber: left, secondNumber: right)
            default: fatalError("Unknown operator !")
            }
            // Making the operation programaticly and cleaning the calcul for the result only (preventing others operations tapped by user)
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
        }
        return operationsToReduce
    }
}
