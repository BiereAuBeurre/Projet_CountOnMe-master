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
    var delegate: CalculationDelegate?
    private var displayableCalculText: String = "" {
        didSet {
            delegate?.calculationUpdated(displayableCalculText)
        }
    }
    var elements: [String] {
        return displayableCalculText.split(separator: " ").map { "\($0)" }
    }
    
    // MARK: - Private methods
    func expressionIsCorrect() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.last != "."
    }
    private func expressionHaveEnoughElement() -> Bool {
        return elements.count >= 3
    }
    private func noDivisionByZero() -> Bool {
        return elements[2] != "0"
    }
    private func expressionHaveResult() -> Bool {
        return elements.contains("=")
    }
    private func forbidDivisionbyZero() {
        if elements[1] == "÷" {
            guard noDivisionByZero() else {
                delegate?.showAlert("Division par zéro impossible.")
                clearText()
                return
            }
        }
    }
    private func equalExecution() -> String? {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            /// If the 1st element is a "-"" operator then it's gonna be a negative number, so it merges the 1st and the 2nd index in a unique value at index [0].
            if operationsToReduce[0] == "-" {
                operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
                operationsToReduce.remove(at: 1)
            }
            while operationsToReduce.contains("×") || operationsToReduce.contains("÷") {
                guard let result = calculatePriorities(operationsToReduce: operationsToReduce) else {
                    return nil
                }
                operationsToReduce = result
            }
            while operationsToReduce.count > 1 {
                guard let result = calculateAdditionAndSubtraction(operationsToReduce: operationsToReduce) else {
                    return nil
                }
                operationsToReduce = result
            }
        }
        return operationsToReduce.first
    }
    // MARK: - Private calcul methods
    
    /// Calculate the priorities when the calcul contains  division and\or multiplication.
    func calculatePriorities(operationsToReduce: [String]) -> [String]? {
        var prioritiesCalculated: [String] = operationsToReduce        
        for element in prioritiesCalculated {
            if element == "×" {
                guard let left: Float = Float(prioritiesCalculated[prioritiesCalculated.firstIndex(of: element)!-1]) else {
                    return nil
                }
                let operand = prioritiesCalculated[prioritiesCalculated.firstIndex(of: element)!]
                guard let right = Float(prioritiesCalculated[prioritiesCalculated.firstIndex(of: element)!+1]) else {
                    return nil
                }
                let result: Float
                switch operand {
                case "×":
                    result = left * right
                default:
                    return nil
                }
                prioritiesCalculated.remove(at: prioritiesCalculated.firstIndex(of: element)!+1)
                prioritiesCalculated.remove(at: prioritiesCalculated.firstIndex(of: element)!-1)
                prioritiesCalculated.insert("\(result)", at: prioritiesCalculated.firstIndex(of: element)!)
//                prioritiesCalculated[prioritiesCalculated.firstIndex(of: element)!] = "\(result)"
                prioritiesCalculated.remove(at: prioritiesCalculated.firstIndex(of: element)!)
            }
            if element == "÷" {
                guard let left: Float = Float(prioritiesCalculated[prioritiesCalculated.firstIndex(of: element)!-1]) else {
                    return nil
                }
                let operand = prioritiesCalculated[prioritiesCalculated.firstIndex(of: element)!]
                guard let right = Float(prioritiesCalculated[prioritiesCalculated.firstIndex(of: element)!+1]) else {
                    return nil
                }
                let result: Float
                switch operand {
                case "÷":
                    if right == 0 {
                        delegate?.showAlert("Division par zéro impossible.")
                        clearText()
                        return nil
                    } else {
                        result = left / right
                    }
                default:
                    return nil
                }
                prioritiesCalculated.remove(at: prioritiesCalculated.firstIndex(of: element)!+1)
                prioritiesCalculated.remove(at: prioritiesCalculated.firstIndex(of: element)!-1)
                prioritiesCalculated.insert("\(result)", at: prioritiesCalculated.firstIndex(of: element)!)
//                prioritiesCalculated[prioritiesCalculated.firstIndex(of: element)!] = "\(result)"
                prioritiesCalculated.remove(at: prioritiesCalculated.firstIndex(of: element)!)
            }
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
    // MARK: - Public methods
    func clearText() {
        displayableCalculText = ""
    }
    func addNumber(numbers: String) {
        if expressionHaveResult() {
            clearText()
        }
        displayableCalculText.append(numbers)
    }
    func addCalculatingSymbol(_ calculatingSymbol: String) {
        if expressionIsCorrect() {
            displayableCalculText.append(calculatingSymbol)
        } else {
            delegate?.showAlert("Un operateur est déja mis !")
        }
    }
    
    func calculatingAndDiplayingResult() {
        if expressionHaveEnoughElement() {
            guard expressionIsCorrect() else {
                delegate?.showAlert("Entrez une expression correcte !")
                return
            }
            forbidDivisionbyZero()
            if let result: String = equalExecution() {
                displayableCalculText.append(" = \(result)")
            }
        } else {
            delegate?.showAlert("Entrez un calcul correct")
            return
        }
    }
}

