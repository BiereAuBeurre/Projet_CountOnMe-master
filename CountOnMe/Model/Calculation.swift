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
    
    func expressionIsCorrect(_ elements: [String]) -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×"
    }
    func canAddOperator(_ elements: [String]) -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×"
    }
    
    func expressionHaveEnoughElement(elements: [String]) -> Bool {
        return elements.count >= 3
    }
    
    func noDivisionByZero(_ elements: [String]) -> Bool {
        return elements[2] != "0"
    }
    
    func expressionHaveResult(_ elements: [String]) -> Bool {
        return elements.contains("=")
    }
    
    func clearText() {
        calculationView = ""
    }
    
    // MARK: - Calcul methods
    //    func addition(firstNumber: Int, secondNumber: Int) -> String {
    //        let result = firstNumber + secondNumber
    //        return "\(result)"
    //    }
    //
    //    func soustraction(firstNumber: Int, secondNumber: Int) -> String {
    //        let result = firstNumber - secondNumber
    //        return "\(result)"
    //    }
     func calculateAdditionAndSubtraction(operationsToReduce: [String]) -> [String]? {
        var additionAndSubtraction: [String] = operationsToReduce
        guard let left: Float = Float(additionAndSubtraction[0]) else {
            return nil
        }
        let operand = additionAndSubtraction[1]
        guard let right: Float = Float(additionAndSubtraction[2]) else {
            return nil
        }
        let result: Float
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        default: return nil
        }
        additionAndSubtraction = Array(additionAndSubtraction.dropFirst(3))
        additionAndSubtraction.insert("\(result)", at: 0)
        return additionAndSubtraction
    }
    
//    func divide (firstNumber: Float, secondNumber:Float) -> String {
//        let result = firstNumber / secondNumber
//        return "\(result)"
//    }
//    
//    func multiplication(firstNumber:Float, secondNumber: Float) -> String {
//        let result = firstNumber * secondNumber
//        return "\(result)"
//    }
    
    func forbidDivisionbyZero (elements: [String]) -> Bool {
        return elements[1] == "÷"
    }
    
    @objc func equalExecution( _ elements: [String]) -> String? {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            //        if the first index is a subtraction operator than it's a negative number so it
            //        merges the first and the second index
            if operationsToReduce[0] == "-" {
                operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
                operationsToReduce.remove(at: 1)
            }
            while operationsToReduce.contains("×") || operationsToReduce.contains("÷") {
                if let result = calculatePriorities(operationsToReduce: operationsToReduce) {
                    operationsToReduce = result
                } else {
                    return nil
                }
            }
            while expressionHaveEnoughElement(elements: operationsToReduce) {
                if let result = calculateAdditionAndSubtraction(operationsToReduce: operationsToReduce) {
                    operationsToReduce = result
                } else {
                    return nil
                }
            }
        }
        
        return operationsToReduce.first
    }
    
    //    calculate the priorities when the calcul contains a division and\or a multiplication
     func calculatePriorities(operationsToReduce: [String]) -> [String]? {
        var prioritiesCalculated: [String] = operationsToReduce
        if let index = prioritiesCalculated.firstIndex(where: { $0 == "×" || $0 == "÷"}) {
            guard let left: Float = Float(prioritiesCalculated[index - 1]) else {
                return nil
            }
            let operand = prioritiesCalculated[index]
            guard let right: Float = Float(prioritiesCalculated[index + 1]) else {
                return nil
            }
            let result: Float
            switch operand {
            case "×":
                result = left * right
            case "÷":
                if right == 0 {
                    return nil
                } else {
                    result = left / right
                }
            default:
                return nil
            }
            prioritiesCalculated[index - 1] = "\(result)"
            prioritiesCalculated.remove(at: index)
            prioritiesCalculated.remove(at: index)
        }
        return prioritiesCalculated
    }
}
    //        while operationsToReduce.count > 1 {
    //            let left = Int(operationsToReduce[0])!
    //            let operand = operationsToReduce[1]
    //            let right = Int(operationsToReduce[2])!
    //            let result: String
    //            // Modifier le result en guard let/if let qui appelera la method du model qui organise la priorisation des calculs
    //            switch operand {
    //            case "+": result = addition(firstNumber: left, secondNumber: right)
    //            case "-": result = soustraction(firstNumber: left, secondNumber: right)
    //            case "/": result = divide(firstNumber: left, secondNumber: right)
    //            case "x": result = multiplication(firstNumber: left, secondNumber: right)
    //            default: fatalError("Unknown operator !")
    //            }
    //
    //            // Making the operation programaticly and cleaning the calcul for the result only (preventing additionals calculation tapped by user before tapping equal button)
    //            operationsToReduce = Array(operationsToReduce.dropFirst(3))
    //            operationsToReduce.insert("\(result)", at: 0)
    //
    //            // Then update the textView with the result
    //            calculationView.append(" = \(operationsToReduce.first!)")
    //        }
