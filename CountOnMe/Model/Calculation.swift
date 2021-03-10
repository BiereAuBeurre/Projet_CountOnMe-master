//
//  Calculation.swift
//  CountOnMe
//
//  Created by Manon Russo on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

final class Calculation {
    // MARK: - Properties
//    weak var delegate: CalculationDelegate?
    var displayableCalculText: String = "" {
        didSet {
            notifyUpdate()
        }
    }
    
    var calculationResult: String = ""
    
    private var elements: [String] {
        return displayableCalculText.split(separator: " ").map { "\($0)" }
    }
    // MARK: - Private methods
    private func notifyUpdate() {
        let notificationName = Notification.Name("update")
        let notification = Notification(name: notificationName)
        NotificationCenter.default.post(notification)
    }
    
    private func notifyDivisionAlert() {
        let notificationName = Notification.Name("alert")
        let notification = Notification(name: notificationName)
        NotificationCenter.default.post(notification)
    }
    
//    private func noDivisionByZero() -> Bool {
//        return elements[2] != "0"
//    }
//    private func forbidDivisionByZero() {
//        if elements[1] == "÷" {
//            guard noDivisionByZero() else {
//                notifyDivisionAlert()
//                displayableCalculText = "= div by zero"
//                return
//            }
//        }
//    }
    
    private func canAddOperator() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.first != "÷" && elements.first != "×"
    }
    
//    private func expressionIsCorrect() -> Bool {
//        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.first != "÷" && elements.first != "×"
//    }
    
    private func expressionHasEnoughElement() -> Bool {
        return elements.count >= 3
    }
    
    private func expressionHaveResult() -> Bool {
        return elements.contains("=")
    }
    
    private func splitNumberStartingByOperandPlusOrMinus(_ valueToSplit: [String]) -> [String]? {
        var operationsToReduce = valueToSplit
        if operationsToReduce[0].contains("-") || operationsToReduce[0].contains("+") {
            operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
            operationsToReduce.remove(at: 1)
        }
        return operationsToReduce
    }
    
    private func equalExecution() -> String? {
        /// Execute in order the multiplication and divison to handle first, then execute the addition and substraction of the result of the first operation
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            operationsToReduce = splitNumberStartingByOperandPlusOrMinus(operationsToReduce)!
            while operationsToReduce.contains("×") || operationsToReduce.contains("÷") {
                guard let result = calculateDivisionAndMultiplicationInOrder(operationsToReduce) else { return nil }
                operationsToReduce = result
            }
            while operationsToReduce.count > 1 {
                guard let result = calculateAdditionAndSubstraction(operationsToReduce) else { return nil }
                operationsToReduce = result
            }
        }
        return operationsToReduce.first
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
        /// If a pervious calcul and its result is displayed before typing this symbol, we'll clear text.
        if expressionHaveResult() {
            clearText()
        }
        /// Checking in the last element typed isn't already an operator.
        if canAddOperator() {
            displayableCalculText.append(calculatingSymbol)
        } else {
            displayableCalculText = "extra operand"
        }
    }
    
    func calculatingAndDisplayingResult() {
        if expressionHasEnoughElement() {
//            guard expressionIsCorrect() else {
//                displayableCalculText = "missing element"
//                return
//            }
//            forbidDivisionByZero()
            /// Attributing the obtain result in equalExecution() in the let result value we'll show on screen once all calculated.
            if let result: String = equalExecution() {
                displayableCalculText.append(" = \(result)")
                calculationResult = result
            }
        } else {
            displayableCalculText = "missing element"
            return
        }
    }
    // MARK: - Calcul methods
    func calculateDivisionAndMultiplicationInOrder(_ operationsToReduce: [String]) -> [String]? {
        var elementsOfCalculation: [String] = operationsToReduce
        for element in elementsOfCalculation {
            if element == "×" || element == "÷" {
                guard let left: Float = Float(elementsOfCalculation[elementsOfCalculation.firstIndex(of: element)!-1]) else { return nil }
                let operand = elementsOfCalculation[elementsOfCalculation.firstIndex(of: element)!]
                guard let right = Float(elementsOfCalculation[elementsOfCalculation.firstIndex(of: element)!+1]) else { return nil }
                let result : Float
                switch operand {
                case "×":
                    result = left * right
                case "÷":
                    if right == 0 {
                        notifyDivisionAlert()
                        displayableCalculText = "= div by zero"
                        return nil
                    } else {
                        result = left / right
                    }
                default: return nil
                }
                elementsOfCalculation.remove(at: elementsOfCalculation.firstIndex(of: element)!+1)
                elementsOfCalculation.remove(at: elementsOfCalculation.firstIndex(of: element)!-1)
                elementsOfCalculation.insert("\(result)", at: elementsOfCalculation.firstIndex(of: element)!)
                elementsOfCalculation.remove(at: elementsOfCalculation.firstIndex(of: element)!)
                return elementsOfCalculation
            }
        }
        return elementsOfCalculation
    }
    
    func calculateAdditionAndSubstraction(_ operationsToReduce: [String]) -> [String]? {
        var additionAndSubstraction: [String] = operationsToReduce
        guard let left = Float(additionAndSubstraction[0]) else { return nil }
        let operand = additionAndSubstraction[1]
        guard let right = Float(additionAndSubstraction[2]) else { return nil }
        let result: Float
        switch operand {
        case "+": result = left + right
        case "-": result = left - right
        default: return nil
        }
        additionAndSubstraction = Array(additionAndSubstraction.dropFirst(3)); additionAndSubstraction.insert("\(result)", at: 0)
        return additionAndSubstraction
    }
    
}
