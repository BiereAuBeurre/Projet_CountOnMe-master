//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class SimpleCalcTests: XCTestCase {
    var calculation: Calculation?
    override func setUp() {
        calculation = Calculation()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        calculation = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddition() {
        // Given
        let a = 3
        let b = 4
        // When
        let result = calculation?.addition(firstNumber: a, secondNumber: b)
        // Then
        XCTAssertEqual(result, "7")
    }
    
    func testSoustraction() {
        let firstNumber = 20
        let secondNumber = 15
        let result = calculation?.soustraction(firstNumber: firstNumber, secondNumber: secondNumber)
        XCTAssertEqual(result, "5")
    }

}
