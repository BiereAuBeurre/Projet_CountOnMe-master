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

final class Calculation {
    // MARK: -Model properties
    var delegate: CalculationDelegate?
    private var displayableCalculText: String = "" {
        didSet {
            delegate?.calculationUpdated(displayableCalculText)
        }
    }
    private var elements: [String] {
        return displayableCalculText.split(separator: " ").map { "\($0)" }
    }
    
    // MARK: - Private methods
    private func noDivisionByZero() -> Bool {
        return elements[2] != "0"
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
    func expressionIsCorrect() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×"
    }
    private func expressionHaveEnoughElement() -> Bool {
        return elements.count >= 3
    }
    private func expressionHaveResult() -> Bool {
        return elements.contains("=")
    }
    private func equalExecution() -> String? {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            /// If the 1st element is a "-"" operator then it's gonna be a negative number, so it merges the 1st and the 2nd index in a unique value at index [0].
            if operationsToReduce[0].contains("-") {
                operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
                operationsToReduce.remove(at: 1)
            }
            while operationsToReduce.contains("×") || operationsToReduce.contains("÷") {
                guard let result = calculateDivisionAndMultiplicationInOrder(operationsToReduce) else {
                    return nil
                }
                operationsToReduce = result
            }
            while operationsToReduce.count > 1 {
                guard let result = calculateAdditionAndSubstraction(operationsToReduce) else {
                    return nil
                }
                operationsToReduce = result
            }
        }
        return operationsToReduce.first
    }
    // MARK: - Calcul methods
    
    func definingLeftOperandRightValuesForPriorities(_ elementsOfCalculation: [String], _ element: String) -> [String]? {
        var values = elementsOfCalculation
        guard let left: Float = Float(values[values.firstIndex(of: element)!-1]) else {
            return nil
        }
        let operand = values[values.firstIndex(of: element)!]
        guard let right = Float(values[values.firstIndex(of: element)!+1]) else {
            return nil
        }
        let result : Float
        switch operand {
        case "×":
            result = left * right
        case "÷":
            if right == 0 {
                delegate?.showAlert("Division par zéro impossible.")
                clearText()
                return nil
            } else {
                forbidDivisionbyZero()
                result = left / right
            }
        default:
            return nil
        }
        values.remove(at: values.firstIndex(of: element)!+1); values.remove(at: values.firstIndex(of: element)!-1); values.insert("\(result)", at: values.firstIndex(of: element)!); values.remove(at: values.firstIndex(of: element)!)
        return values
    }
    
    func calculateDivisionAndMultiplicationInOrder(_ operationsToReduce: [String]) -> [String]? {
        var elementsOfCalculation: [String] = operationsToReduce
        for element in elementsOfCalculation {
            if element == "×" || element == "÷" {
                elementsOfCalculation = definingLeftOperandRightValuesForPriorities(operationsToReduce, element)!
            }
        }
        return elementsOfCalculation
    }
    
    func calculateAdditionAndSubstraction(_ operationsToReduce: [String]) -> [String]? {
        var additionAndSubstraction: [String] = operationsToReduce
        guard let left = Float(additionAndSubstraction[0]) else {
            return nil
        }
        let operand = additionAndSubstraction[1]
        guard let right = Float(additionAndSubstraction[2]) else {
            return nil
        }
        let result: Float
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        default: return nil
        }
        additionAndSubstraction = Array(additionAndSubstraction.dropFirst(3)); additionAndSubstraction.insert("\(result)", at: 0)
        return additionAndSubstraction
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
