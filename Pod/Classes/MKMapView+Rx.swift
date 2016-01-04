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
    
    // MARK: Responding to Region Events
    
    /**
    Reactive wrapper for `delegate` message.
    */
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
    
    // MARK: Responding to Loading Events
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_mapViewWillStartLoadingMap: Observable<Void>{
        return rx_delegate.observe("mapViewWillStartLoadingMap:")
            .map { _ in
                return()
        }
    }
    
    public var rx_mapViewDidFinishLoadingMap: Observable<Void>{
        return rx_delegate.observe("mapViewDidFinishLoadingMap:")
            .map { _ in
                return()
        }
    }
    
    public var rx_mapViewDidFailLoadingMap: Observable<NSError!>{
        return rx_delegate.observe("mapViewDidFailLoadingMap:withError:")
            .map { a in
                return a[1] as? NSError
        }
    }
    
    // MARK: Responding to Rendering Events
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_mapViewWillStartRenderingMap: Observable<Void>{
        return rx_delegate.observe("mapViewWillStartRenderingMap:")
            .map { _ in
                return()
        }
    }

    public var rx_mapViewDidFinishRenderingMap: Observable<Bool!> {
        return rx_delegate.observe("mapViewDidFinishRenderingMap:fullyRendered:")
            .map { a in
                return a[1] as? Bool
        }
    }
    
    // MARK: Responding to Annotation Views
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_mapViewDidAddAnnotationViews: Observable<[MKAnnotationView]!> {
        return rx_delegate.observe("mapView:didAddAnnotationViews:")
            .map { a in
                return a[1] as? [MKAnnotationView]
        }
    }
    
    public var rx_mapViewAnnotationViewCalloutAccessoryControlTapped: Observable<Void> {
        return rx_delegate.observe("mapView:annotationView:calloutAccessoryControlTapped:")
            .map { _ in
                return()
        }
    }
    
    public var rx_mapViewDidSelectAnnotationView: Observable<MKAnnotationView!> {
        return rx_delegate.observe("mapView:didSelectAnnotationView:")
            .map { a in
                return a[1] as? MKAnnotationView
        }
    }
    
    public var rx_mapViewDidDeselectAnnotationView: Observable<MKAnnotationView!> {
        return rx_delegate.observe("mapView:didDeselectAnnotationView:")
            .map { a in
                return a[1] as? MKAnnotationView
        }
    }
    
    public var rx_mapViewDidChangeState: Observable<(view: MKAnnotationView!, newState: MKAnnotationViewDragState, oldState: MKAnnotationViewDragState)> {
        return rx_delegate.observe("mapView:annotationView:didChangeDragState:fromOldState:")
            .map { a in
                return (view: a[1] as? MKAnnotationView, newState: a[2] as! MKAnnotationViewDragState, oldState: a[3] as! MKAnnotationViewDragState)
        }
    }
    
    // MARK: Responding to Location User Events
    
    /**
    Reactive wrapper for `delegate` message.
    */
    public var rx_mapViewWillStartLocatingUser: Observable<Void> {
        return rx_delegate.observe("mapViewWillStartLocatingUser:")
            .map { _ in
                return()
        }
    }
    
    public var rx_mapViewDidStopLocatingUser: Observable<Void> {
        return rx_delegate.observe("mapViewDidStopLocatingUser:")
            .map { _ in
                return()
        }
    }
    
    public var rx_mapViewDidUpdateUserLocation: Observable<MKUserLocation!> {
        return rx_delegate.observe("mapView:didUpdateUserLocation:")
            .map { a in
                return a[1] as? MKUserLocation
        }
    }
    
    public var rx_mapViewDidFailToLocateUserWithError: Observable<NSError!> {
        return rx_delegate.observe("mapView:didFailToLocateUserWithError:")
            .map { a in
                return a[1] as? NSError
        }
    }
}
