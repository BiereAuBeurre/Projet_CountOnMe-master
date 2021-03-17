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
//    var calculationResult: String = ""
    
    private var elements: [String] {
        return displayableCalculText.split(separator: " ").map { "\($0)" }
    }
    
    private var noDivisionByZero: Bool {
        if displayableCalculText.contains("÷ 0") {
            displayableCalculText = "= div by zero"
            return false
        }
        return true
    }
    
    private var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "÷" && elements.last != "×" && elements.first != "÷" && elements.first != "×"
    }
    
    private var expressionHasEnoughElement: Bool {
        return elements.count >= 3
    }
    
    private var expressionHaveResult: Bool {
        return elements.contains("=")
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
    
    private func splitNumberStartingByOperandPlusOrMinus(_ valueToSplit: [String]) -> [String] {
        /// If calcul starts with "+" or "-" we'll split it as one unique value containing operand and the following number.
        var operationsToReduce = valueToSplit
        if operationsToReduce[0].contains("-") || operationsToReduce[0].contains("+") {
            operationsToReduce[0] = "\(operationsToReduce[0])\(operationsToReduce[1])"
            operationsToReduce.remove(at: 1)
        }
        return operationsToReduce
    }
    
    private func resolving() -> String {
        /// Handle the multiplication and divison first, then execute the addition and substraction of the result of the first operation.
        var operationsToReduce = elements
        while operationsToReduce.count > 1 {
            operationsToReduce = splitNumberStartingByOperandPlusOrMinus(operationsToReduce)
            var operandIndex = 1
            if let index = operationsToReduce.firstIndex(where: { $0.contains("×") || $0.contains("÷")}) {
                operandIndex = index
            }
            guard let left: Float = Float(operationsToReduce[operandIndex-1]),
                let right = Float(operationsToReduce[operandIndex+1]) else { return " out of range" }
            let operand = operationsToReduce[operandIndex]
            var result: Float
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "×": result = left * right
            case "÷": result = left / right
            default: return "unknown operand"
            }
            operationsToReduce.remove(at: operandIndex+1)
            operationsToReduce.remove(at: operandIndex-1)
            operationsToReduce.insert("\(result.removeZerosFromEnd())", at: operandIndex)
            operationsToReduce.remove(at: operandIndex-1)
        }
        guard let finalResult = operationsToReduce.first else { return " missing result" }
        return finalResult
    }
    
    // MARK: - Public methods
    func clearText() {
        displayableCalculText = ""
    }
    
    func addNumber(_ numbers: String) {
        if expressionHaveResult {
            clearText()
        }
        displayableCalculText.append(numbers)
    }
    
    func addCalculatingSymbol(_ calculatingSymbol: String) {
        /// If a previous calcul and its result are displayed before typing a new symbol, we'll clear text.
        if expressionHaveResult {
            clearText()
        }
        /// Checking the last element typed isn't already an operator.
        guard canAddOperator else { return displayableCalculText = "= extra operand" }
        displayableCalculText.append(calculatingSymbol)
    }
    
    func displayResult() {
        guard noDivisionByZero else { notifyDivisionAlert(); return }
        guard expressionHasEnoughElement else { return displayableCalculText = "= missing element" }
        displayableCalculText.append(" = \(resolving())")
    }
    
}


