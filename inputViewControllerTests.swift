//
//  inputViewControllerTests.swift
//  fertilityApp
//
//  Created by Blake Robinson on 10/4/16.
//  Copyright © 2016 Blake Robinson. All rights reserved.
//

import XCTest
@testable import fertilityApp

class inputViewControllerTests: XCTestCase {
    var vc: InputTableViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateViewController(withIdentifier: "Input") as! InputTableViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testValidateInputs() {
        XCTAssert(true)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
