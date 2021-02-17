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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        calculation = Calculation()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        calculation = nil
    }
    func testGivenFirstNumberIs3AndSecondNumberIs5_WhenAdditionating_ThenResultIs7() {
        // Given & When
        let result = calculation?.calculateAdditionAndSubtraction(operationsToReduce: ["3", "+", "5"])
        // Then
        XCTAssertEqual(result, ["8.0"])
    }
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenSubstracting_ThenResultIs5() {
        // Given & When
        let result = calculation?.calculateAdditionAndSubtraction(operationsToReduce: ["10", "-", "5"])
        // Then
        XCTAssertEqual(result, ["5.0"])
    }
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenDividing_ThenResultIs2() {
        // Given & When
        let result = calculation?.calculatePriorities(operationsToReduce: ["10", "÷", "5"])
        // Then
        XCTAssertEqual(result, ["2.0"])
    }
    
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenMultiplicating_ThenResultIs50() {
        // Given & When
        let result = calculation?.calculatePriorities(operationsToReduce: ["10", "×", "5"])
        // Then
        XCTAssertEqual(result, ["50.0"])
    }
    func testGivenFirstNumberIs10AndSecondNumberIs15_WhenAdditionating_AndDividingBy3_ThenResultIs25() {
        // Given & When
        var result = calculation?.calculatePriorities(operationsToReduce: ["10", "+", "15", "÷", "3"])
        result = calculation?.calculateAdditionAndSubtraction(operationsToReduce: result!)
        // Then
        XCTAssertEqual(result, ["15.0"])
    }
}
