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
    
    private func canAddOperator() -> Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.first != "÷" && elements.first != "×"
    }
    
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
            var operandIndex = 1
            if let index = operationsToReduce.firstIndex(where: { $0.contains("×") || $0.contains("÷")}) {
                operandIndex = index
            }
            guard let left: Float = Float(operationsToReduce[operandIndex-1]) else { return nil }
            let operand = operationsToReduce[operandIndex]
            
            guard let right = Float(operationsToReduce[operandIndex+1]) else { return nil }
            switch operand {
            case "+": calculationResult = "\(left + right)"
            case "-": calculationResult = "\(left - right)"
            case "×": calculationResult = "\(left * right)"
            case "÷":
                if right == 0 {
                    notifyDivisionAlert()
                    displayableCalculText = "= div by zero"
                    return nil
                } else {
                    calculationResult = "\(left / right)"
                }
            default: return nil
            }
            operationsToReduce.remove(at: operandIndex+1)
            operationsToReduce.remove(at: operandIndex-1)
            operationsToReduce.insert("\(calculationResult)", at: operandIndex)
            operationsToReduce.remove(at: operandIndex-1)
        }
        return calculationResult
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
        /// Checking the last element typed isn't already an operator.
        if canAddOperator() {
            displayableCalculText.append(calculatingSymbol)
        } else {
            displayableCalculText = "extra operand"
        }
    }
    
    func calculatingAndDisplayingResult() {
        if expressionHasEnoughElement() {
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
    
}
