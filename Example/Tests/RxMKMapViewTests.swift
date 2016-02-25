//
//  RxMKMapViewTests.swift
//  RxMKMapView
//
//  Created by Spiros Gerokostas on 04/01/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import MapKit
import Nimble
import RxSwift
import RxCocoa

class RxMKMapViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_rx_didChangeState() {
        let mapView = MKMapView()
        var resultView: MKAnnotationView?
        var resultNewState: MKAnnotationViewDragState?
        var resultOldState: MKAnnotationViewDragState?
        
        
        autoreleasepool {
            _ = mapView.rx_didChangeState
                .subscribeNext { (view, newState, oldState) -> Void in
                    resultView = view
                    resultNewState = newState
                    resultOldState = oldState
                }
            
            let newState = MKAnnotationViewDragState.Starting
            let oldState = MKAnnotationViewDragState.Dragging
            
            mapView.delegate!.mapView!(mapView,
                annotationView: MKAnnotationView(),
                didChangeDragState: newState,
                fromOldState: oldState)
            
            expect(resultView).toNot(beNil())
            expect(resultNewState).to(equal(newState))
            expect(resultOldState).to(equal(oldState))
        }
        
    }
    
}
