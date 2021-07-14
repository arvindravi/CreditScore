//
//  HomePresenterTests.swift
//  CreditScoreTests
//
//  Created by Arvind Ravi on 07/07/2021.
//

import CreditKit
import XCTest
@testable import CreditScore

class HomePresenterTests: XCTestCase {
    
    // MARK: - Mock Objects -
    
    private let mockCreditKit: MockCreditKit = .init()
    private let mockHomePresenterView: MockHomePresenterView = .init()
    
    // MARK: - SUT -
    
    private var subject: HomePresenter!
    
    // MARK: - Overrides -
    
    override func setUp() {
        super.setUp()
        subject = HomePresenter(service: mockCreditKit)
        subject.view = mockHomePresenterView
    }
    
    // MARK: - Tests -
    
    func test_fetchCreditInformationSuccessfully() {
        mockCreditKit.mockedSuccessResult = .mock(score: 35)
        
        subject.fetchCreditScore()
        
        XCTAssertEqual(mockCreditKit.capturedEvents, [.fetchCreditScore, .fetchCreditScoreSuccess(score: 35)])
        XCTAssertEqual(mockHomePresenterView.capturedEvents, [.didSuccessfullyFetchCreditInformation(withScore: 35)])
    }
    
    func test_fetchCreditInformationWithFailure_invalidResponse() {
        mockCreditKit.mockedFailureResult = .invalidResponse
        
        subject.fetchCreditScore()
        
        XCTAssertEqual(mockCreditKit.capturedEvents, [.fetchCreditScore, .fetchCreditScoreFailed(error: .invalidResponse)])
        XCTAssertEqual(mockHomePresenterView.capturedEvents, [.didFailToFetchCreditInformationWith(error: "Error Fetching Data: Invalid Response.")])
    }
    
    func test_fetchCreditInformationWithFailure_failedToDecodeData() {
        mockCreditKit.mockedFailureResult = .failedToDecodeData
        
        subject.fetchCreditScore()
        
        XCTAssertEqual(mockCreditKit.capturedEvents, [.fetchCreditScore, .fetchCreditScoreFailed(error: .failedToDecodeData)])
        XCTAssertEqual(mockHomePresenterView.capturedEvents, [.didFailToFetchCreditInformationWith(error: "Error Fetching Data: Failed to decode data.")])
    }
}
