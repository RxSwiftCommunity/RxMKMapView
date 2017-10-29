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
import RxMKMapView

let dummyError = NSError(domain: "com.RxMKMapView.dummyError", code: 0, userInfo: nil)

class RxMKMapViewTests: XCTestCase {
    
    func test_rx_didChangeState() {
        let mapView = MKMapView()
        var resultView: MKAnnotationView?
        var resultNewState: MKAnnotationViewDragState?
        var resultOldState: MKAnnotationViewDragState?
        
        
        autoreleasepool {
            _ = mapView.rx.didChangeState
                .subscribe(onNext: { (view, newState, oldState) -> Void in
                    resultView = view
                    resultNewState = newState
                    resultOldState = oldState
                })
            
            let newState = MKAnnotationViewDragState.starting
            let oldState = MKAnnotationViewDragState.dragging
            
            mapView.delegate!.mapView!(mapView,
                annotationView: MKAnnotationView(),
                didChange: newState,
                fromOldState: oldState)
            
            expect(resultView).toNot(beNil())
            expect(resultNewState).to(equal(newState))
            expect(resultOldState).to(equal(oldState))
        }
        
    }
    
    func  test_rx_regionWillChangeAnimated() {
        let mapView = MKMapView()
        var changed = false
        
        autoreleasepool {
            
            _ = mapView.rx.regionWillChangeAnimated
                .subscribe(onNext: {
                    changed = $0
                })
            
            mapView.delegate!.mapView!(mapView, regionWillChangeAnimated: true)
        }
        
        expect(changed).to(beTrue())
    }
    
    func test_rx_regionDidChangeAnimated() {
        let mapView = MKMapView()
        var changed = false
        
        autoreleasepool {
            
            _ = mapView.rx.regionDidChangeAnimated
                .subscribe(onNext: {
                    changed = $0
                })
            
            mapView.delegate!.mapView!(mapView, regionDidChangeAnimated: true)
        }
        
        expect(changed).to(beTrue())
    }
    
    func test_rx_willStartLoadingMap() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx.willStartLoadingMap
                .subscribe(onNext: {
                    called = true
                })
            
            mapView.delegate!.mapViewWillStartLoadingMap!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didFinishLoadingMap() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx.didFinishLoadingMap
                .subscribe(onNext: {
                    called = true
                })
            
            mapView.delegate!.mapViewDidFinishLoadingMap!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didFailLoadingMap() {
        let mapView = MKMapView()
        var error: NSError?
        
        autoreleasepool {
            
            _ = mapView.rx.didFailLoadingMap
                .subscribe(onNext: {
                    error = $0
                })
            
            mapView.delegate!.mapViewDidFailLoadingMap!(mapView, withError: dummyError)
        }
        
        expect(error).toNot(beNil())
        expect(error).to(equal(dummyError))
    }
    
    func test_rx_willStartRenderingMap() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx.willStartRenderingMap
                .subscribe(onNext: {
                    called = true
                })
            
            mapView.delegate!.mapViewWillStartRenderingMap!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didFinishRenderingMap() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx.didFinishRenderingMap
                .subscribe(onNext: {
                    called = $0
                })
            
            mapView.delegate!.mapViewDidFinishRenderingMap!(mapView, fullyRendered: true)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_willStartLocatingUser() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx.willStartLocatingUser
                .subscribe(onNext: {
                    called = true
                })
            
            mapView.delegate!.mapViewWillStartLocatingUser!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didStopLocatingUser() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx.didStopLocatingUser
                .subscribe(onNext: {
                    called = true
                })
            
            mapView.delegate!.mapViewDidStopLocatingUser!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didUpdateUserLocation() {
        let mapView = MKMapView()
        var userLocation:MKUserLocation?
        
        autoreleasepool {
            
            _ = mapView.rx.didUpdateUserLocation
                .subscribe(onNext: {
                    userLocation = $0
                })
            
            let location = MKUserLocation()
            
            mapView.delegate!.mapView!(mapView, didUpdate: location)
        }
        
        expect(userLocation).toNot(beNil())
        expect(userLocation).to(equal(userLocation))
    }
    
    func test_rx_didFailToLocateUserWithError() {
        let mapView = MKMapView()
        var error:NSError?
        
        autoreleasepool {
            
            _ = mapView.rx.didFailToLocateUserWithError
                .subscribe(onNext: {
                    error = $0
                })
            
            mapView.delegate!.mapView!(mapView, didFailToLocateUserWithError: dummyError)
        }
        
        expect(error).toNot(beNil())
        expect(error).to(equal(dummyError))
    }
    
    func test_rx_didChangeUserTrackingMode() {
        let mapView = MKMapView()
        var resultTrakingMode: MKUserTrackingMode?
        var animated: Bool?
        let trakingMode = MKUserTrackingMode.follow
        
        autoreleasepool {
            
            _ = mapView.rx.didChangeUserTrackingMode
                .subscribe(onNext: {
                    resultTrakingMode = $0.mode
                    animated = $0.animated
                })
            
            mapView.delegate!.mapView!(mapView, didChange: trakingMode, animated: true)
        }
        
        expect(resultTrakingMode).toNot(beNil())
        expect(resultTrakingMode).to(equal(trakingMode))
        expect(animated).to(beTrue())
    }
    
    func test_rx_didAddAnnotationViews() {
        let mapView = MKMapView()
        var resultViews:[MKAnnotationView]?
        
        let views = [MKAnnotationView()]
        autoreleasepool {
            _ = mapView.rx.didAddAnnotationViews
                .subscribe(onNext: {
                    resultViews = $0
                })
            
            mapView.delegate!.mapView!(mapView, didAdd: views)
        }
        
        expect(resultViews).toNot(beNil())
        expect(resultViews).to(equal(views))
    }
    
    func test_rx_annotationViewCalloutAccessoryControlTapped() {
        let mapView = MKMapView()
        var resultView: MKAnnotationView?
        var resultControl: UIControl?
        
        let view = MKAnnotationView()
        let control = UIControl()
        
        autoreleasepool {
            _ = mapView.rx.annotationViewCalloutAccessoryControlTapped
                .subscribe(onNext: {
                    resultView = $0.view
                    resultControl = $0.control
                })
            
            mapView.delegate!.mapView!(mapView,
                annotationView: view,
                calloutAccessoryControlTapped: control)
        }
        
        expect(resultView).toNot(beNil())
        expect(resultView).to(equal(view))
        expect(resultControl).toNot(beNil())
        expect(resultControl).to(equal(control))
    }
    
    func test_rx_didSelectAnnotationView() {
        let mapView = MKMapView()
        var resultView: MKAnnotationView?
        
        let view = MKAnnotationView()
        
        autoreleasepool {
            _ = mapView.rx.didSelectAnnotationView
                .subscribe(onNext: {
                    resultView = $0
            })
            
            mapView.delegate!.mapView!(mapView, didSelect: view)
        }
        
        expect(resultView).toNot(beNil())
        expect(resultView).to(equal(view))
    }
    
    func test_rx_didDeselectAnnotationView() {
        let mapView = MKMapView()
        var resultView: MKAnnotationView?
        
        let view = MKAnnotationView()
        
        autoreleasepool {
            _ = mapView.rx.didDeselectAnnotationView
                .subscribe(onNext: {
                    resultView = $0
            })
            
            mapView.delegate!.mapView!(mapView, didDeselect: view)
        }
        
        expect(resultView).toNot(beNil())
        expect(resultView).to(equal(view))
    }
    
    func test_rx_didAddOverlayRenderers() {
        let mapView = MKMapView()
        var resultView: [MKOverlayRenderer]?
        
        let overlayRenders = [MKOverlayRenderer()]
        
        autoreleasepool {
            _ = mapView.rx.didAddOverlayRenderers
                .subscribe(onNext: {
                    resultView = $0
            })
            
            mapView.delegate!.mapView!(mapView, didAdd: overlayRenders)
        }
        
        expect(resultView).toNot(beNil())
        expect(resultView).to(equal(overlayRenders))
    }
    
    func test_rx_annotationsArrayBinding() {
        let mapView = MKMapView()
        
        let annotation1 = MKPointAnnotation()
        annotation1.title = "title1"
        annotation1.subtitle = "subtitle1"
        
        let annotation2 = MKPointAnnotation()
        annotation2.title = "title2"
        annotation2.subtitle = "subtitle2"
        
        let annotations = [annotation1, annotation2]
        
        _ = Observable.from(annotations)
            .bind(to: mapView.rx.annotations)
        
        expect(mapView.annotations as? [MKPointAnnotation]).to(contain(annotations))
    }
    
    func test_rx_annotationsBinding() {
        let mapView = MKMapView()
        
        let annotation1 = MKPointAnnotation()
        annotation1.title = "title1"
        annotation1.subtitle = "subtitle1"
        
        let annotation2 = MKPointAnnotation()
        annotation2.title = "title2"
        annotation2.subtitle = "subtitle2"
        
        let annotations: [MKAnnotation] = [annotation1, annotation2]
        
         _ = Observable.of(annotations)
            .bind(to: mapView.rx.annotations)
        
        let exp = self.expectation(description: "wait for annotation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expect(mapView.annotations).to(haveCount(2))
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 0.2, handler: nil)
    }
    
    func test_rx_annotationsClosureBinding() {
        let mapView = MKMapView()
        
        let titles: [String] = ["title1" , "title2"]
        
        _ = Observable.of(titles)
            .bind(to: mapView.rx.annotations) { title in
                let annotation = MKPointAnnotation()
                annotation.title = title
                return annotation
            }
        
        expect(mapView.annotations).to(haveCount(2))
    }
}

