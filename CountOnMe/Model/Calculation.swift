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
    
    // Error check computed variables
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
}

