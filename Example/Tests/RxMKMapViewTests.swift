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
    
    func  test_rx_regionWillChangeAnimated() {
        let mapView = MKMapView()
        var changed = false
        
        autoreleasepool {
            
            _ = mapView.rx_regionWillChangeAnimated
                .subscribeNext {
                    changed = $0
                }
            
            mapView.delegate!.mapView!(mapView, regionWillChangeAnimated: true)
        }
        
        expect(changed).to(beTrue())
    }
    
    func test_rx_regionDidChangeAnimated() {
        let mapView = MKMapView()
        var changed = false
        
        autoreleasepool {
            
            _ = mapView.rx_regionDidChangeAnimated
                .subscribeNext {
                    changed = $0
                }
            
            mapView.delegate!.mapView!(mapView, regionDidChangeAnimated: true)
        }
        
        expect(changed).to(beTrue())
    }
    
    func test_rx_willStartLoadingMap() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx_willStartLoadingMap
                .subscribeNext {
                    called = true
                }
            
            mapView.delegate!.mapViewWillStartLoadingMap!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didFinishLoadingMap() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx_didFinishLoadingMap
                .subscribeNext {
                    called = true
                }
            
            mapView.delegate!.mapViewDidFinishLoadingMap!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didFailLoadingMap() {
        let mapView = MKMapView()
        var error: NSError?
        
        autoreleasepool {
            
            _ = mapView.rx_didFailLoadingMap
                .subscribeNext {
                    error = $0
                }
            
            mapView.delegate!.mapViewDidFailLoadingMap!(mapView, withError: dummyError)
        }
        
        expect(error).toNot(beNil())
        expect(error).to(equal(dummyError))
    }
    
    func test_rx_willStartRenderingMap() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx_willStartRenderingMap
                .subscribeNext {
                    called = true
                }
            
            mapView.delegate!.mapViewWillStartRenderingMap!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didFinishRenderingMap() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx_didFinishRenderingMap
                .subscribeNext {
                    called = $0
                }
            
            mapView.delegate!.mapViewDidFinishRenderingMap!(mapView, fullyRendered: true)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_willStartLocatingUser() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx_willStartLocatingUser
                .subscribeNext {
                    called = true
                }
            
            mapView.delegate!.mapViewWillStartLocatingUser!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didStopLocatingUser() {
        let mapView = MKMapView()
        var called = false
        
        autoreleasepool {
            
            _ = mapView.rx_didStopLocatingUser
                .subscribeNext {
                    called = true
                }
            
            mapView.delegate!.mapViewDidStopLocatingUser!(mapView)
        }
        
        expect(called).to(beTrue())
    }
    
    func test_rx_didUpdateUserLocation() {
        let mapView = MKMapView()
        var userLocation:MKUserLocation?
        
        autoreleasepool {
            
            _ = mapView.rx_didUpdateUserLocation
                .subscribeNext {
                    userLocation = $0
                }
            let location = MKUserLocation()
            
            mapView.delegate!.mapView!(mapView, didUpdateUserLocation: location)
        }
        
        expect(userLocation).toNot(beNil())
        expect(userLocation).to(equal(userLocation))
    }
    
    func test_rx_didFailToLocateUserWithError() {
        let mapView = MKMapView()
        var error:NSError?
        
        autoreleasepool {
            
            _ = mapView.rx_didFailToLocateUserWithError
                .subscribeNext {
                    error = $0
                }
            
            mapView.delegate!.mapView!(mapView, didFailToLocateUserWithError: dummyError)
        }
        
        expect(error).toNot(beNil())
        expect(error).to(equal(dummyError))
    }
    
    func test_rx_didChangeUserTrackingMode() {
        let mapView = MKMapView()
        var resultTrakingMode: MKUserTrackingMode?
        var animated: Bool?
        let trakingMode = MKUserTrackingMode.Follow
        
        autoreleasepool {
            
            _ = mapView.rx_didChangeUserTrackingMode
                .subscribeNext {
                    resultTrakingMode = $0.mode
                    animated = $0.animated
                }
            mapView.delegate!.mapView!(mapView, didChangeUserTrackingMode: trakingMode, animated: true)
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
            _ = mapView.rx_didAddAnnotationViews
                .subscribeNext {
                    resultViews = $0
                }
            mapView.delegate!.mapView!(mapView, didAddAnnotationViews: views)
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
            _ = mapView.rx_annotationViewCalloutAccessoryControlTapped
                .subscribeNext {
                    resultView = $0.view
                    resultControl = $0.control
                }
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
            _ = mapView.rx_didSelectAnnotationView
                .subscribeNext {
                    resultView = $0
            }
            mapView.delegate!.mapView!(mapView, didSelectAnnotationView: view)
        }
        
        expect(resultView).toNot(beNil())
        expect(resultView).to(equal(view))
    }
    
    func test_rx_didDeselectAnnotationView() {
        let mapView = MKMapView()
        var resultView: MKAnnotationView?
        
        let view = MKAnnotationView()
        
        autoreleasepool {
            _ = mapView.rx_didDeselectAnnotationView
                .subscribeNext {
                    resultView = $0
            }
            mapView.delegate!.mapView!(mapView, didDeselectAnnotationView: view)
        }
        
        expect(resultView).toNot(beNil())
        expect(resultView).to(equal(view))
    }
    
    func test_rx_didAddOverlayRenderers() {
        let mapView = MKMapView()
        var resultView: [MKOverlayRenderer]?
        
        let overlayRenders = [MKOverlayRenderer()]
        
        autoreleasepool {
            _ = mapView.rx_didAddOverlayRenderers
                .subscribeNext {
                    resultView = $0
            }
            mapView.delegate!.mapView!(mapView, didAddOverlayRenderers: overlayRenders)
        }
        
        expect(resultView).toNot(beNil())
        expect(resultView).to(equal(overlayRenders))
    }
    
}
