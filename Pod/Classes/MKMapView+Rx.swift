//
//  MKMapView+Rx.swift
//  RxCocoa
//
//  Created by Spiros Gerokostas on 04/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import MapKit
import RxSwift
import RxCocoa

// Taken from RxCococa until marked as public
func castOrThrow<T>(_ resultType: T.Type, _ object: AnyObject) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

extension Reactive where Base: MKMapView {
    
    /**
     Reactive wrapper for `delegate`.
     
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var delegate: DelegateProxy {
        return RxMKMapViewDelegateProxy.proxyForObject(self.base)
    }
    
    
    // MARK: Responding to Map Position Changes
    
    public var regionWillChangeAnimated: ControlEvent<Bool> {
        
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:regionWillChangeAnimated:)))
            .map { try castOrThrow(Bool.self, $0[1]) }
        
        return ControlEvent(events: source)
    }
    
    public var regionDidChangeAnimated: ControlEvent<Bool> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { try castOrThrow(Bool.self, $0[1]) }
        return ControlEvent(events: source)
    }
    
    
    // MARK: Loading the Map Data
    
    public var willStartLoadingMap: ControlEvent<Void>{
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapViewWillStartLoadingMap(_:)))
            .map { _ in () }
        
        return ControlEvent(events: source)
    }
    
    public var didFinishLoadingMap: ControlEvent<Void>{
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapViewDidFinishLoadingMap(_:)))
            .map { _ in () }
        
        return ControlEvent(events: source)
    }
    
    public var didFailLoadingMap: Observable<NSError>{
        return delegate
            .observe(#selector(MKMapViewDelegate.mapViewDidFailLoadingMap(_:withError:)))
            .map { try castOrThrow(NSError.self, $0[1]) }
    }
    
    // MARK: Responding to Rendering Events
    
    public var willStartRenderingMap: ControlEvent<Void>{
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapViewWillStartRenderingMap(_:)))
            .map { _ in () }
        
        return ControlEvent(events: source)
    }
    
    public var didFinishRenderingMap: ControlEvent<Bool> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapViewDidFinishRenderingMap(_:fullyRendered:)))
            .map { try castOrThrow(Bool.self, $0[1]) }
        
        return ControlEvent(events: source)
    }
    
    // MARK: Tracking the User Location
    
    public var willStartLocatingUser: ControlEvent<Void> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapViewWillStartLocatingUser(_:)))
            .map { _ in () }
        
        return ControlEvent(events: source)
    }
    
    public var didStopLocatingUser: ControlEvent<Void> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapViewDidStopLocatingUser(_:)))
            .map { _ in () }
        
        return ControlEvent(events: source)
    }
    
    public var didUpdateUserLocation: ControlEvent<MKUserLocation> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didUpdate:)))
            .map { try castOrThrow(MKUserLocation.self, $0[1]) }
        
        return ControlEvent(events: source)
    }
    
    public var didFailToLocateUserWithError: Observable<NSError> {
        return delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didFailToLocateUserWithError:)))
            .map { try castOrThrow(NSError.self, $0[1])  }
    }
    
    public var didChangeUserTrackingMode:
        ControlEvent<(mode: MKUserTrackingMode, animated: Bool)> {
        
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didChange:animated:)))
            .map { (mode: try castOrThrow(Int.self, $0[1]), animated: try castOrThrow(Bool.self, $0[2])) }
            .map { (mode, animated) in (mode: MKUserTrackingMode(rawValue: mode)!, animated: animated) }
        
        return ControlEvent(events: source)
    }
    
    // MARK: Responding to Annotation Views
    
    
    
    public var didAddAnnotationViews: ControlEvent<[MKAnnotationView]> {
        
        let source =  delegate
            // FIXME: how to handle the forced unwrap of the optional function?
            .observe(#selector(MKMapViewDelegate.mapView(_:didAdd:)! as (MKMapViewDelegate) -> (MKMapView, [MKAnnotationView]) -> Void))
            .map { try castOrThrow([MKAnnotationView].self, $0[1]) }
        
        return ControlEvent(events: source)
    }
    
    public var annotationViewCalloutAccessoryControlTapped:
        ControlEvent<(view: MKAnnotationView, control: UIControl)> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:annotationView:calloutAccessoryControlTapped:)))
            .map { a in
                return (view: try castOrThrow(MKAnnotationView.self, a[1]),
                        control: try castOrThrow(UIControl.self, a[2]))
        }
        return ControlEvent(events: source)
    }
    
    // MARK: Selecting Annotation Views
    
    public var didSelectAnnotationView: ControlEvent<MKAnnotationView> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didSelect:)))
            .map { a in
                return try castOrThrow(MKAnnotationView.self, a[1])
        }
        return ControlEvent(events: source)
    }
    
    public var didDeselectAnnotationView: ControlEvent<MKAnnotationView> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didDeselect:)))
            .map { a in
                return try castOrThrow(MKAnnotationView.self, a[1])
        }
        return ControlEvent(events: source)
    }
    
    public var didChangeState:
        ControlEvent<(view: MKAnnotationView, newState: MKAnnotationViewDragState, oldState: MKAnnotationViewDragState)> {
        let source = delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:annotationView:didChange:fromOldState:)))
            .map { a in
                (view: try castOrThrow(MKAnnotationView.self, a[1]),
                 newState: try castOrThrow(UInt.self, a[2]),
                 oldState: try castOrThrow(UInt.self, a[3]))
            }
            .map { (view, newState, oldState) in
                (view: view,
                 newState: MKAnnotationViewDragState(rawValue: newState)!,
                 oldState: MKAnnotationViewDragState(rawValue: oldState)!)
        }
        return ControlEvent(events: source)
    }
    
    // MARK: Managing the Display of Overlays
    
    public var didAddOverlayRenderers: ControlEvent<[MKOverlayRenderer]> {
        
        let source =  delegate
            // FIXME: how to handle the forced unwrap of the optional function?
            .observe(#selector(MKMapViewDelegate.mapView(_:didAdd:)! as (MKMapViewDelegate) -> (MKMapView, [MKOverlayRenderer]) -> Void))
            .map { try castOrThrow([MKOverlayRenderer].self, $0[1]) }
        
        return ControlEvent(events: source)
    }
    
    
}
