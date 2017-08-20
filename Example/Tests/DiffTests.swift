//
//  DiffTests.swift
//  RxMKMapView
//
//  Created by Mikko Välimäki on 13/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import RxMKMapView

class Item: NSObject {
    let id: String
    init(_ id: String? = nil) {
        self.id = id ?? UUID.init().uuidString
    }
}

class DiffTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyCase() {
        let diff = Diff<NSObjectProtocol>.calculateFrom(previous: [], next: [])
        XCTAssertEqual(diff.added.count, 0)
        XCTAssertEqual(diff.removed.count, 0)
    }
    
    func testAllRemoved() {
        let items = (1...10).map{ Item("\($0)") }
        let diff = Diff.calculateFrom(previous: items, next: [])
        XCTAssertEqual(diff.added.count, 0)
        XCTAssertEqual(diff.removed.count, 10)
    }
    
    func testOnlyNew() {
        let items = (1...10).map{ Item("\($0)") }
        let diff = Diff.calculateFrom(previous: [], next: items)
        XCTAssertEqual(diff.added.count, 10)
        XCTAssertEqual(diff.removed.count, 0)
    }
    
    func testPerformanceWhenNoChange() {
        
        let items = (1...40000).map{ Item("\($0)") }
        
        self.measure {
            let diff = Diff.calculateFrom(previous: items, next: items)
            XCTAssertEqual(diff.added.count, 0)
            XCTAssertEqual(diff.removed.count, 0)
        }
    }
    
    func testPerformanceWhenEverythingChanges() {
        
        let half = 20000
        let items = (1...(2*half)).map{ Item("\($0)") }
        let firstPart = Array(items[0..<half])
        let secondPart = Array(items[half..<2*half])
        
        self.measure {
            let diff = Diff<Item>.calculateFrom(previous: firstPart, next: secondPart)
            XCTAssertEqual(diff.added.count, half)
            XCTAssertEqual(diff.removed.count, half)
        }
    }
    
    func testPerformanceWhenSomeChange() {
        
        let quarter = 10000
        let items = (1...(4*quarter)).map{ Item("\($0)") }
        let firstPart = Array(items[0..<3*quarter])
        let secondPart = Array(items[quarter..<4*quarter])
        
        self.measure {
            let diff = Diff<Item>.calculateFrom(previous: firstPart, next: secondPart)
            XCTAssertEqual(diff.added.count, quarter)
            XCTAssertEqual(diff.removed.count, quarter)
        }
    }
    
}
