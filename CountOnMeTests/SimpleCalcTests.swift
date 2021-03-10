//
//  SimpleCalcTests.swift
//  SimpleCalcTests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

final class SimpleCalcTests: XCTestCase {
    
    private var calculation: Calculation!
    
    override func setUp() {
        // This method is called before the invocation of each test method in the class.
        calculation = Calculation()
    }
    
    override func tearDown() {
        // This method is called after the invocation of each test method in the class.
        calculation = nil
    }
    
    func testGivenFirstNumberIs3AndSecondNumberIs5_WhenAdditioning_ThenResultIs8() {
        // Given
        calculation.addNumber("3")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("5")
        // When
        calculation.calculatingAndDisplayingResult()
        XCTAssertEqual(calculation.calculationResult, "8.0")
    }
    
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenSubstracting_ThenResultIs5() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" - ")
        calculation.addNumber("5")
        // When
        calculation.calculatingAndDisplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "5.0")
    }
    
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenDividing_ThenResultIs2() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("5")
        // When
        calculation.calculatingAndDisplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "2.0")
    }
    
    func testGivenFirstNumberIs10AndSecondNumberIs5_WhenMultiplicating_ThenResultIs50() {
        // Given
        calculation.addNumber("10")
        calculation.addCalculatingSymbol(" × ")
        calculation.addNumber("5")
        // When
        calculation.calculatingAndDisplayingResult()
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
        calculation.calculatingAndDisplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "15.0")
    }
    
    func testGivenFirstNumberIsMinus2SecondNumberIs2_WhenAdditionnating_ThenResutltIsZero() {
        // Given
        calculation.addCalculatingSymbol(" - ")
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("2")
        // When
        calculation.calculatingAndDisplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "0.0")
    }
    
    func testGivenFirstNumberIsPlus2SecondNumberIs4_WhenAdditionnating_ThenResultIs6() {
        // Given
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" + ")
        calculation.addNumber("4")
        // When
        calculation.calculatingAndDisplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "6.0")
    }
    
    func testGivenFirstNumberIs2SecondNumberIs0_WhenDividing_ThenNoResult() {
        // Given
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addNumber("0")
        // When
        calculation.calculatingAndDisplayingResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "= div by zero")
    }
    
    func testGivenLongCalculOfSevenValues_WheUsingDifferentOperandInDifferentOrder_ThenCalculIsPrioritizeAndResultIs2() {
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
        calculation.calculatingAndDisplayingResult()
        // Then
        XCTAssertEqual(calculation.calculationResult, "2.0")
    }
    
    func testLongCalculOfSevenValuesWithADivisionby0_WhenCalculating_ThenResultIsEmpty() {
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
        calculation.calculatingAndDisplayingResult()
        // Then
        XCTAssertEqual(calculation.displayableCalculText, "= div by zero")
    }
    
    func testGivenOnlyOneValueIs2_WhenAdditionnatingTwice_ThenExpressionHasEnoughElementFalseAndErrorMessageISShown() {
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" + ")
        calculation.addCalculatingSymbol(" + ")

        XCTAssertEqual(calculation.displayableCalculText, "extra operand")
    }
    
    func testGivenOnlyOneValueIs2_WhenSubstractingTwice_ThenExpressionHasEnoughElementFalseAndErrorMessageISShown() {
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" - ")
        calculation.addCalculatingSymbol(" - ")

        XCTAssertEqual(calculation.displayableCalculText, "extra operand")
    }
    
    func testGivenOnlyOneValueIs2_WhenDividingTwice_ThenExpressionHasEnoughElementFalseAndErrorMessageISShown() {
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.addCalculatingSymbol(" ÷ ")

        XCTAssertEqual(calculation.displayableCalculText, "extra operand")
    }
    
    func testGivenExpressionHasResultTrue_WhenTypingANewNumber_ThenPreviousCalculIsCleared() {
        calculation.displayableCalculText = "2 + 4 = 6"
        calculation.addNumber("2")
        XCTAssertEqual(calculation.displayableCalculText, "2")
    }
    
    func testGivenExpressionHasResultTrue_WhenTypingANeOperand_ThenPreviousCalculIsCleared() {
        calculation.displayableCalculText = "2 + 4 = 6"
        calculation.addCalculatingSymbol("+")
        XCTAssertEqual(calculation.displayableCalculText, "+")
    }
    
    func testGivenTwoValuesOnOnly_WhenEqualTapped_ThenMissingElementPrintOnScreen() {
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.calculatingAndDisplayingResult()
        XCTAssertEqual(calculation.displayableCalculText, "missing element")
    }
    
    func testFullCalculatingAndDisplayingResult() {
        calculation.addCalculatingSymbol("+")
        calculation.addNumber("2")
        calculation.addCalculatingSymbol(" ÷ ")
        calculation.calculatingAndDisplayingResult()
        XCTAssertEqual(calculation.displayableCalculText, "missing element")

    }
    
}
