//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.

import XCTest
@testable import CountOnMe

final class SimpleCalcTests: XCTestCase {
    
    private var calculation: Calculation!
    
    override func setUp() {
        /// This method is called before the invocation of each test method in the class.
        calculation = Calculation()
    }
    
    override func tearDown() {
        /// This method is called after the invocation of each test method in the class.
        calculation = nil
    }
    
    func testGivenFirstNumberIs3AndSecondNumberIs5_WhenAdditioning_ThenResultIs8() {
        // Given
        calculation.addNumber("3")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("5")
        // When
        calculation.displayResult()
        XCTAssertEqual(calculation.displayableCalculText, "3 + 5 = 8")
    }
    
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenDividing_ThenResultIs2() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("5")
        // When
        calculation.displayResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "10 ÷ 5 = 2")
    }
    
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenMultiplicating_ThenResultIs50() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" × ")
        calculation.addNumber("5")
        // When
        calculation.displayResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "10 × 5 = 50")
    }
    
    func testGivenFirstNumberIs10AndSecondNumberIs15_WhenAdditionating_AndDividingBy3_ThenResultIs15() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("15")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("3")
        // When
        calculation.displayResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "10 + 15 ÷ 3 = 15")
    }
    
    func testGivenFirstNumberIsMinus2SecondNumberIs2_WhenAdditionnating_ThenResutltIsZero() {
        // Given
        calculation.addCalculatingSymbol(" - ")
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("2")
        // When
        calculation.displayResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, " - 2 + 2 = 0")
    }
    
    func testGivenFirstNumberIs2SecondNumberIs0_WhenDividing_ThenNoResult() {
        // Given
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("0")
        // When
        calculation.displayResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "= div by zero")
    }
    
    func testGivenLongCalculOfSevenValues_WhenUsingDifferentOperandInDifferentOrder_ThenCalculIsPrioritizedAndResultIs2() {
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
        calculation.displayResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "10 + 15 × 2 + 20 ÷ 10 - 20 × 2 = 2")
    }
    
    func testLongCalculOfSevenValuesWithADivisionby0_WhenCalculating_ThenErrorMessageIsShown() {
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
        calculation.displayResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "= div by zero")
    }
    
    func testGivenOnlyOneValueIs2_WhenAdditionnatingTwice_ThenExpressionHasEnoughElementFalseAndErrorMessageIsShown() {
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" + ")
        calculation.addCalculatingSymbol(" + ")
        XCTAssertEqual(calculation.displayableCalculText, "= extra operand")
    }
    
    func testGivenExpressionHasResultTrue_WhenTypingANewNumber_ThenPreviousCalculIsCleared() {
        calculation.displayableCalculText = "2 + 4 = 6"
        calculation.addNumber("2")
        XCTAssertEqual(calculation.displayableCalculText, "2")
    }
    
    func testGivenExpressionHasResultTrue_WhenTypingANewOperand_ThenPreviousCalculIsCleared() {
        // Décomposer en 3 lignes
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("4")
        calculation.displayResult()
        calculation.addCalculatingSymbol("+")
        // Corrigerle resultat à 6 +
        XCTAssertEqual(calculation.displayableCalculText, "6+")
    }
    
    func testGivenIs5and2_WhenDividing_ThenResultShowDecimalNumber() {
        calculation.addNumber("5")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("2")
        calculation.displayResult()
        XCTAssertEqual(calculation.displayableCalculText, "5 ÷ 2 = 2.5")
    }
    
    func testGivenTwoValuesOnOnly_WhenEqualTapped_ThenMissingElementPrintOnScreen() {
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.displayResult()
        XCTAssertEqual(calculation.displayableCalculText, "= missing element")
    }
    
}
