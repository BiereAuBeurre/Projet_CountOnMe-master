//
//  Calculation.swift
//  CountOnMe
//
//  Created by Manon Russo on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

protocol CalculationDelegate: class {
    func calculationUpdated(_ calcul: String)
    func showAlert(_ message: String)
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
    
    // MARK: - Public methods
    
    func forbidDivisionbyZero() {
        if elements[1] == "÷" {
            guard noDivisionByZero() else {
                calculationDelegate?.showAlert("Division par zéro impossible.")
                clearText()
                return
            }
        }
    }
    
    func calculationButtonTapped(_ calculatingSymbol: String) {
        if canAddOperator() {
            calculationView.append(calculatingSymbol)
        } else {
            calculationDelegate?.showAlert("Un operateur est déja mis !")
        }
    }
    
    func addNumber(numbers: String) {
        if expressionHaveResult() {
            clearText()
        }
    calculationView.append(numbers)
    }
    
    func expressionIsCorrect() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.last != "."
    }
    func canAddOperator() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.last != "."
    }
    
    func expressionHaveEnoughElement() -> Bool {
        return elements.count >= 3
    }
    
    func noDivisionByZero() -> Bool {
        return elements[2] != "0"
    }
    
    func expressionHaveResult() -> Bool {
        return elements.contains("=")
    }
    
    func clearText() {
        calculationView = ""
    }
    func equalExecution() -> String? {
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
            while operationsToReduce.count > 1 {
                if let result = calculateAdditionAndSubtraction(operationsToReduce: operationsToReduce) {
                    operationsToReduce = result
                } else {
                    return nil
                }
            }
        }
        return operationsToReduce.first
    }
    // MARK: - Calcul methods
    
    func calculatingAndDiplayingResult() {
        if elements.count >= 3 {
            guard expressionIsCorrect() else {
                calculationDelegate?.showAlert("Entrez une expression correcte !")
                return
            }
            forbidDivisionbyZero()
            if let result: String = equalExecution() {
               calculationView.append(" = \(result)")
            }
            
        } else {
            calculationDelegate?.showAlert("Entrez un calcul correct")
            return
        }
    }
    
    
    //    calculate the priorities when the calcul contains a division and\or a multiplication
     func calculatePriorities(operationsToReduce: [String]) -> [String]? {
        var prioritiesCalculated: [String] = operationsToReduce
        // dès qu'un element du tableau correspond à x ou / , on retourne l'index en question
        // Ici l'index correspond à l'opérateur / ou ÷
        var priorityIndex: Int?
        for index in 0..<prioritiesCalculated.count {
            if prioritiesCalculated[index] == "×" || prioritiesCalculated[index] == "÷" {
                priorityIndex = index
            }
        }
        if let index = priorityIndex {
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

}

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
