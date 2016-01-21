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

extension MKMapView {

    /**
     Reactive wrapper for `delegate`.

     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var rx_delegate:DelegateProxy {
        return proxyForObject(RxMKMapViewDelegateProxy.self, self)
    }

    // MARK: Responding to Map Position Changes

    public var rx_regionWillChangeAnimated: Observable<Bool!> {
        return rx_delegate.observe("mapView:regionWillChangeAnimated:")
            .map { a in
                return a[1] as? Bool
            }
    }

    public var rx_regionDidChangeAnimated: Observable<Bool!> {
        return rx_delegate.observe("mapView:regionDidChangeAnimated:")
            .map { a in
                return a[1] as? Bool
        }
    }

    // MARK: Loading the Map Data

    public var rx_willStartLoadingMap: Observable<Void>{
        return rx_delegate.observe("mapViewWillStartLoadingMap:")
            .map { _ in
                return()
        }
    }

    public var rx_didFinishLoadingMap: Observable<Void>{
        return rx_delegate.observe("mapViewDidFinishLoadingMap:")
            .map { _ in
                return()
        }
    }

    public var rx_didFailLoadingMap: Observable<NSError!>{
        return rx_delegate.observe("mapViewDidFailLoadingMap:withError:")
            .map { a in
                return a[1] as? NSError
        }
    }

    // MARK: Responding to Rendering Events

    public var rx_willStartRenderingMap: Observable<Void>{
        return rx_delegate.observe("mapViewWillStartRenderingMap:")
            .map { _ in
                return()
        }
    }

    public var rx_didFinishRenderingMap: Observable<Bool!> {
        return rx_delegate.observe("mapViewDidFinishRenderingMap:fullyRendered:")
            .map { a in
                return a[1] as? Bool
        }
    }

    // MARK: Tracking the User Location

    public var rx_willStartLocatingUser: Observable<Void> {
        return rx_delegate.observe("mapViewWillStartLocatingUser:")
            .map { _ in
                return()
        }
    }

    public var rx_didStopLocatingUser: Observable<Void> {
        return rx_delegate.observe("mapViewDidStopLocatingUser:")
            .map { _ in
                return()
        }
    }

    public var rx_didUpdateUserLocation: Observable<MKUserLocation!> {
        return rx_delegate.observe("mapView:didUpdateUserLocation:")
            .map { a in
                return a[1] as? MKUserLocation
        }
    }

    public var rx_didFailToLocateUserWithError: Observable<NSError!> {
        return rx_delegate.observe("mapView:didFailToLocateUserWithError:")
            .map { a in
                return a[1] as? NSError
        }
    }

    // MARK: Responding to Annotation Views

    public var rx_didAddAnnotationViews: Observable<[MKAnnotationView]!> {
        return rx_delegate.observe("mapView:didAddAnnotationViews:")
            .map { a in
                return a[1] as? [MKAnnotationView]
        }
    }

    public var rx_annotationViewCalloutAccessoryControlTapped: Observable<Void> {
        return rx_delegate.observe("mapView:annotationView:calloutAccessoryControlTapped:")
            .map { _ in
                return()
        }
    }

    // MARK: Selecting Annotation Views

    public var rx_didSelectAnnotationView: Observable<MKAnnotationView!> {
        return rx_delegate.observe("mapView:didSelectAnnotationView:")
            .map { a in
                return a[1] as? MKAnnotationView
        }
    }

    public var rx_didDeselectAnnotationView: Observable<MKAnnotationView!> {
        return rx_delegate.observe("mapView:didDeselectAnnotationView:")
            .map { a in
                return a[1] as? MKAnnotationView
        }
    }

    public var rx_didChangeState: Observable<(view: MKAnnotationView!, newState: MKAnnotationViewDragState, oldState: MKAnnotationViewDragState)> {
        return rx_delegate.observe("mapView:annotationView:didChangeDragState:fromOldState:")
            .map { a in
                return (view: a[1] as? MKAnnotationView, newState: a[2] as! MKAnnotationViewDragState, oldState: a[3] as! MKAnnotationViewDragState)
        }
    }
}
