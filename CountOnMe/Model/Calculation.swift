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
    
    // MARK: - Private methods
    private func expressionIsCorrect() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.last != "."
    }
    func canAddOperator() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.last != "."
    }
    private func expressionHaveEnoughElement() -> Bool {
        return elements.count >= 3
    }
    private func divisionByZeroAsked() -> Bool {
        return elements[2] != "0"
    }
    private func expressionHaveResult() -> Bool {
        return elements.contains("=")
    }
    private func forbidDivisionbyZero() {
        if elements[1] == "÷" {
            guard divisionByZeroAsked() else {
                calculationDelegate?.showAlert("Division par zéro impossible.")
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
        /// As soon as an element in the pirioritiesCalculated array matches "x" or "÷", we return the index where its placed (there'll be an optionnal priorityIndex created and so the if let condition in line 97 will be executed).
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
                if divisionByZeroAsked() { /// anciennement : if right == 0, n'affichait pas d'erreur, stop juste l'appli
                    calculationDelegate?.showAlert("Division par zéro impossible.")
                    prioritiesCalculated.remove(at: index)
                    prioritiesCalculated.remove(at: index)
                    calculationView = "\(prioritiesCalculated.joined())"
                    /// fonctionne seulement le tableau apparait de façon brute
//                    clearText()
                    return prioritiesCalculated
                }
                else {
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
    // MARK: - Public methods
    func clearText() {
        calculationView = ""
    }
    func addNumber(numbers: String) {
        if expressionHaveResult() {
            clearText()
        }
        calculationView.append(numbers)
    }
    
    func calculationButtonTapped(_ calculatingSymbol: String) {
        if canAddOperator() {
            calculationView.append(calculatingSymbol)
        } else {
            calculationDelegate?.showAlert("Un operateur est déja mis !")
        }
    }
    
    func calculatingAndDiplayingResult() {
        if expressionHaveEnoughElement() {
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
}

