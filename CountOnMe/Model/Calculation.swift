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
    var displayableCalculText: String = "" {
        didSet {
            delegate?.calculationUpdated(displayableCalculText)
        }
    }
    var calculationResult: String = ""

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
    private func forbidStartingByXOrDivide() {
        if elements.first != "×" || elements.first != "÷" {
            delegate?.showAlert("Impossible de commencer par une mutliplication ou division. Merci de renseigner un  calcul correct.")
            clearText()
            return
        }
    }
    
    private func expressionIsCorrect() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×"
    }
    private func expressionHaveEnoughElement() -> Bool {
        return elements.count >= 3
    }
    private func expressionHaveResult() -> Bool {
        return elements.contains("=")
    }
    private func splitNumberStartingByOperandPlusOrMinus(_ negativeValue: [String]) -> [String]? {
        var operationsToReduce = negativeValue
        if operationsToReduce[0].contains("-") || operationsToReduce[0].contains("+") {
            operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
            operationsToReduce.remove(at: 1)
        }
        return operationsToReduce
    }
    
    private func equalExecution() -> String? {
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            operationsToReduce = splitNumberStartingByOperandPlusOrMinus(operationsToReduce)!
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
    
    func calculateDivisionAndMultiplicationInOrder(_ operationsToReduce: [String]) -> [String]? {
        var elementsOfCalculation: [String] = operationsToReduce
        for element in elementsOfCalculation {
            if element == "×" || element == "÷" {
                guard let left: Float = Float(elementsOfCalculation[elementsOfCalculation.firstIndex(of: element)!-1]) else {
                    return nil
                }
                let operand = elementsOfCalculation[elementsOfCalculation.firstIndex(of: element)!]
                guard let right = Float(elementsOfCalculation[elementsOfCalculation.firstIndex(of: element)!+1]) else {
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
                elementsOfCalculation.remove(at: elementsOfCalculation.firstIndex(of: element)!+1); elementsOfCalculation.remove(at: elementsOfCalculation.firstIndex(of: element)!-1); elementsOfCalculation.insert("\(result)", at: elementsOfCalculation.firstIndex(of: element)!); elementsOfCalculation.remove(at: elementsOfCalculation.firstIndex(of: element)!)
                return elementsOfCalculation
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
    func addNumber(_ numbers: String) {
        if expressionHaveResult() {
            clearText()
        }
        displayableCalculText.append(numbers)
    }
    func addCalculatingSymbol(_ calculatingSymbol: String) {
        //rajouter condition if expression haveresult pour clearText si calcul précédent terminé
        if expressionHaveResult() {
            clearText()
        }
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
            forbidStartingByXOrDivide()
            if let result: String = equalExecution() {
                displayableCalculText.append(" = \(result)")
                calculationResult = result
            }
        } else {
            delegate?.showAlert("Entrez un calcul correct")
            return
        }
    }
    
}
