//
//  SimpleCalcUITests.swift
//  SimpleCalcUITests
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest

class CountOnMeUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNumbersAndACButtons() throws {
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["7"].tap()
        app.buttons["8"].tap()
        app.buttons["9"].tap()
        app.buttons["0"].tap()
        app.buttons["AC"].tap()
        let textView = app.textViews.firstMatch
        XCTAssertEqual(textView.value as? String, "") /// Value is "any" type, that's why we specify it's a string.
    }
    
    func testAllSymbolsButtons() throws {
        app.buttons["1"].tap()
        app.buttons["+"].tap()
        app.buttons["3"].tap()
        app.buttons["÷"].tap()
        app.buttons["5"].tap()
        app.buttons["×"].tap()
        app.buttons["2"].tap()
        app.buttons["-"].tap()
        app.buttons["1"].tap()
        app.buttons["="].tap()
        // result : 1.2
        let textView = app.textViews.firstMatch
        XCTAssertEqual(textView.value as? String, "1 + 3 ÷ 5 × 2 - 1 = 1.2")
    }
    
    func testUIAlert() throws {
        app.buttons["3"].tap()
        app.buttons["÷"].tap()
        app.buttons["0"].tap()
        app.buttons["="].tap()
        XCTAssertEqual(app.alerts.element.label, "Erreur")
        XCTAssert(app.alerts.element.staticTexts["Division par zéro impossible"].exists)
    }
    
}
