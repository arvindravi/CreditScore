//
//  CreditScoreUITests.swift
//  CreditScoreUITests
//
//  Created by Arvind Ravi on 06/07/2021.
//

import XCTest

class CreditScoreUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    // MARK: XCTestCase
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
    }
    
    // MARK: - Tests
    
    func testHomeScreen() {
        app.launch()
        
        XCTAssertTrue(app.isDisplayingHomeScreen)
    }
    
    func testCreditScoreLoadJourney() {
        app.launch()
        
        XCTAssertTrue(app.isDisplayingHomeScreen)
        XCTAssertTrue(app.isDisplayingCreditScoreLabel)
        
        sleep(5) // NB: Sleeping for such a long time to ensure the data is loaded. In a production scenario, the UITests would be configured with a mock server that returns pre-configured data.
        
        XCTAssertEqual(app.creditScoreLabelElement.label, "514")
    }
    
    func testDetailScreenJourney() {
        app.launch()
        
        XCTAssertTrue(app.isDisplayingHomeScreen)
        XCTAssertTrue(app.isDisplayingCreditScoreLabel)
        
        sleep(3) // NB: Sleeping for such a long time to ensure the data is loaded. In a production scenario, the UITests would be configured with a mock server that returns pre-configured data.
        
        app.creditScoreLabelElement.tap()
        
        XCTAssertTrue(app.isDisplayingCreditInformationView)
        XCTAssertTrue(app.isDisplayingCreditInformationList)
        
        let firstCell = CreditInformationCell(index: 0)
        let secondCell = CreditInformationCell(index: 1)
        
        sleep(3) // NB: Sleeping for such a long time to ensure the data is loaded. In a production scenario, the UITests would be configured with a mock server that returns pre-configured data.
        
        XCTAssertEqual(app.creditInformationCollectionElement.cells.count, 2)
        XCTAssertEqual(firstCell.title, "Persona Type")
        XCTAssertEqual(firstCell.value, "INEXPERIENCED")
        
        XCTAssertEqual(secondCell.title, "Dashboard Status")
        XCTAssertEqual(secondCell.value, "PASS")
    }
}

extension XCUIApplication {
    // Home Screen
    
    var isDisplayingHomeScreen: Bool {
        otherElements["HomeViewController"].exists
    }
    
    var isDisplayingCreditScoreLabel: Bool {
        staticTexts["CreditScoreLabel"].exists
    }
    
    var isDisplayingDonutView: Bool {
        otherElements["DonutView"].exists
    }
    
    var donutViewElement: XCUIElement {
        otherElements["DonutView"]
    }
    
    var creditScoreLabelElement: XCUIElement {
        staticTexts["CreditScoreLabel"]
    }
    
    // Credit Information View Screen
    
    var isDisplayingCreditInformationView: Bool {
        otherElements["CreditInformationViewController"].exists
    }
    
    var isDisplayingCreditInformationList: Bool {
        collectionViews["CreditInformationCollectionView"].exists
    }
    
    var creditInformationCollectionElement: XCUIElement {
        collectionViews["CreditInformationCollectionView"]
    }
}

private extension CreditScoreUITests {
    struct CreditInformationCell {
        let element: XCUIElement
        
        init(index: Int) {
            self.element = XCUIApplication().creditInformationCollectionElement.cells.element(boundBy: index)
            print(element.debugDescription)
        }
        
        var title: String {
            element.label
        }
        
        var value: String {
            element.value as? String ?? ""
        }
    }
}
