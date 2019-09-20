//
//  ClockInTests.swift
//  ClockInTests
//
//  Created by Arief Shaifullah Akbar on 17/09/19.
//  Copyright © 2019 Arief Shaifullah Akbar. All rights reserved.
//

import XCTest
import Foundation
@testable import ClockIn

class ClockInTests: XCTestCase {

    var clockTest: ViewController!
    
    func testClockTestHasExpected() {
        let welcome = clockTest.welcomeLabel.text
        XCTAssertEqual("welcome,", welcome)
        
    }
    
    func toDate(_ date: String, withFormat format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: date) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
    
    func testCalculateDegree(){
        let expectedDegree = 5.270894341022875
        
        let testdate = toDate("2019-09-19 03:04:27 +0000", withFormat: "yyyy-MM-dd HH:mm:ssZZZZ")
        let calculateDegree = clockTest.calculateDegree(testdate)
        
        XCTAssertEqual(calculateDegree, CGFloat(expectedDegree))
    }
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clockTest = ViewController()
    }
    
    override func tearDown() {
        clockTest = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
//
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
