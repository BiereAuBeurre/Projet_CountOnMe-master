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
    var firstNumber: Float!
    var secondNumber: Float!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        calculation = Calculation()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        calculation = nil
        firstNumber = nil
        secondNumber = nil
    }

//    func testGivenFirstNumberIs3AndSecondNumberIs5_WhenAdditionating_ThenResultIs7() {
//        // Given
//        firstNumber = 3
//        secondNumber = 4
//        // When
//        let result = calculation?.addition(firstNumber: firstNumber, secondNumber: secondNumber)
//        // Then
//        XCTAssertEqual(result, "7")
//    }
//
//    func testGivenFirstNumberIs20AndSecondNumberIs15_WhenSubstracting_ThenResultIs5() {
//        firstNumber = 20
//        secondNumber = 15
//        let result = calculation?.soustraction(firstNumber: firstNumber, secondNumber: secondNumber)
//        XCTAssertEqual(result, "5")
//    }
//
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenDividing_ThenResultIs2() {
        firstNumber = 10
        secondNumber = 5
        let result = calculation?.divide(firstNumber: firstNumber, secondNumber: secondNumber)
        XCTAssertEqual(result, "\(2)")
    }
    
    func testGivenFirstNumberIs5AndSecondNumberIs3_WhenMultiplicating_ThenResultIs15() {
        firstNumber = 5
        secondNumber = 3
        let result = calculation?.multiplication(firstNumber: firstNumber, secondNumber: secondNumber)
        XCTAssertEqual(result, "\(15)")
    }

}
