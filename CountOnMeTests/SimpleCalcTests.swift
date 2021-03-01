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

    var calculation: Calculation!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        calculation = Calculation()
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        calculation = nil
    }
    func testGivenFirstNumberIs3AndSecondNumberIs5_WhenAdditioning_ThenResultIs8() {
        // Given
        calculation.addNumber("3")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("5")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "8.0")
    }
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenSubstracting_ThenResultIs5() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" - ")
        calculation.addNumber("5")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "5.0")
    }
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenDividing_ThenResultIs2() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("5")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "2.0")
    }
    
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenMultiplicating_ThenResultIs50() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" × ")
        calculation.addNumber("5")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "50.0")
    }
    func testGivenFirstNumberIs10AndSecondNumberIs15_WhenAdditionating_AndDividingBy3_ThenResultIs15() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("15")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("3")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "15.0")
    }
    
    func testGivenFirstNumberIsMinus2SecondNumberIs2_WhenAdditionnatingg_ThenResutltIsZero() {
        // Given
        calculation.addCalculatingSymbol(" - ")
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("2")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "0.0")
    }
    
    func testGivenFirstNumberIs2SecondNumberIs0_WhenDividing_ThenNoResult() {
        // Given
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("0")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "") 
    }
    
    func testGivenAdditionatingFirstNumberIs10AndSecondNumberIs15_WhenMultiplicatingBy2_AndDividingBy10_ThenResultIs13() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("15")
        calculation.addCalculatingSymbol(" × ")
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("20")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" - ")
        calculation.addNumber("20")
        calculation.addCalculatingSymbol(" × ")
        calculation.addNumber("2")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "2.0")
    }
    
    func testGivenis2dividedByZeroPlus3by0_WhenCalculating_ThenResultIsEmpty() {
        // Given
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("0")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("3")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("0")
        calculation.addCalculatingSymbol(" - ")
        calculation.addNumber("20")
        calculation.addCalculatingSymbol(" × ")
        calculation.addNumber("2")
        // When
        calculation.calculatingAndDiplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "")
    }
}
