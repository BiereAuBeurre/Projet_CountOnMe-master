//
//  Calculation.swift
//  CountOnMe
//
//  Created by Manon Russo on 10/02/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculation {
    
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

