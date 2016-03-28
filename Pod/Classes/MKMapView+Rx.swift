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
func castOrThrow<T>(resultType: T.Type, _ object: AnyObject) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.CastingError(object: object, targetType: resultType)
    }
    return returnValue
}

extension MKMapView {

    /**
     Reactive wrapper for `delegate`.

     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var rx_delegate: DelegateProxy {
        return proxyForObject(RxMKMapViewDelegateProxy.self, self)
    }

    // MARK: Responding to Map Position Changes

    public var rx_regionWillChangeAnimated: ControlEvent<Bool> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:regionWillChangeAnimated:)))
            .map { a in
                return try castOrThrow(Bool.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var rx_regionDidChangeAnimated: ControlEvent<Bool> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { a in
                return try castOrThrow(Bool.self, a[1])
            }
        return ControlEvent(events: source)
    }

    // MARK: Loading the Map Data

    public var rx_willStartLoadingMap: ControlEvent<Void>{
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapViewWillStartLoadingMap(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var rx_didFinishLoadingMap: ControlEvent<Void>{
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapViewDidFinishLoadingMap(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var rx_didFailLoadingMap: Observable<NSError>{
        return rx_delegate
            .observe(#selector(MKMapViewDelegate.mapViewDidFailLoadingMap(_:withError:)))
            .map { a in
                return try castOrThrow(NSError.self, a[1])
            }
    }

    // MARK: Responding to Rendering Events

    public var rx_willStartRenderingMap: ControlEvent<Void>{
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapViewWillStartRenderingMap(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var rx_didFinishRenderingMap: ControlEvent<Bool> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapViewDidFinishRenderingMap(_:fullyRendered:)))
            .map { a in
                return try castOrThrow(Bool.self, a[1])
            }
        return ControlEvent(events: source)
    }

    // MARK: Tracking the User Location

    public var rx_willStartLocatingUser: ControlEvent<Void> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapViewWillStartLocatingUser(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var rx_didStopLocatingUser: ControlEvent<Void> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapViewDidStopLocatingUser(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var rx_didUpdateUserLocation: ControlEvent<MKUserLocation> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didUpdateUserLocation:)))
            .map { a in
                return try castOrThrow(MKUserLocation.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var rx_didFailToLocateUserWithError: Observable<NSError> {
        return rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didFailToLocateUserWithError:)))
            .map { a in
                return try castOrThrow(NSError.self, a[1])
            }
    }

    public var rx_didChangeUserTrackingMode:
        ControlEvent<(mode: MKUserTrackingMode, animated: Bool)> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didChangeUserTrackingMode:animated:)))
            .map { a in
                return (mode: try castOrThrow(Int.self, a[1]),
                    animated: try castOrThrow(Bool.self, a[2]))
            }
            .map { (mode, animated) in
                return (mode: MKUserTrackingMode(rawValue: mode)!,
                    animated: animated)
            }
        return ControlEvent(events: source)
    }

    // MARK: Responding to Annotation Views

    public var rx_didAddAnnotationViews: ControlEvent<[MKAnnotationView]> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didAddAnnotationViews:)))
            .map { a in
                return try castOrThrow([MKAnnotationView].self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var rx_annotationViewCalloutAccessoryControlTapped:
        ControlEvent<(view: MKAnnotationView, control: UIControl)> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:annotationView:calloutAccessoryControlTapped:)))
            .map { a in
                return (view: try castOrThrow(MKAnnotationView.self, a[1]),
                    control: try castOrThrow(UIControl.self, a[2]))
            }
        return ControlEvent(events: source)
    }

    // MARK: Selecting Annotation Views

    public var rx_didSelectAnnotationView: ControlEvent<MKAnnotationView> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didSelectAnnotationView:)))
            .map { a in
                return try castOrThrow(MKAnnotationView.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var rx_didDeselectAnnotationView: ControlEvent<MKAnnotationView> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didDeselectAnnotationView:)))
            .map { a in
                return try castOrThrow(MKAnnotationView.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var rx_didChangeState:
        ControlEvent<(view: MKAnnotationView, newState: MKAnnotationViewDragState, oldState: MKAnnotationViewDragState)> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:annotationView:didChangeDragState:fromOldState:)))
            .map { a in
                return (view: try castOrThrow(MKAnnotationView.self, a[1]),
                    newState: try castOrThrow(UInt.self, a[2]),
                    oldState: try castOrThrow(UInt.self, a[3]))
            }
            .map { (view, newState, oldState) in
                return (view: view,
                    newState: MKAnnotationViewDragState(rawValue: newState)!,
                    oldState: MKAnnotationViewDragState(rawValue: oldState)!)
            }
        return ControlEvent(events: source)
    }

    // MARK: Managing the Display of Overlays

    public var rx_didAddOverlayRenderers: ControlEvent<[MKOverlayRenderer]> {
        let source = rx_delegate
            .observe(#selector(MKMapViewDelegate.mapView(_:didAddOverlayRenderers:)))
            .map { a in
                return try castOrThrow([MKOverlayRenderer].self, a[1])
            }
        return ControlEvent(events: source)
    }
}
