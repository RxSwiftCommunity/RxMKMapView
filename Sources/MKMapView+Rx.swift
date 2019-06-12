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
func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
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
    public var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: base)
    }

    // MARK: Responding to Map Position Changes

    public var regionWillChangeAnimated: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionWillChangeAnimated:)))
            .map { a in
                return try castOrThrow(Bool.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var regionDidChangeAnimated: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map { a in
                return try castOrThrow(Bool.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var region: Observable<MKCoordinateRegion> {
        return regionDidChangeAnimated
                .map { [base] _ in base.region }
                .startWith(base.region)
    }

    // MARK: Loading the Map Data

    public var willStartLoadingMap: ControlEvent<Void> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapViewWillStartLoadingMap(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var didFinishLoadingMap: ControlEvent<Void> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapViewDidFinishLoadingMap(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var didFailLoadingMap: Observable<NSError> {
        return delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapViewDidFailLoadingMap(_:withError:)))
            .map { a in
                return try castOrThrow(NSError.self, a[1])
            }
    }

    // MARK: Responding to Rendering Events

    public var willStartRenderingMap: ControlEvent<Void> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapViewWillStartRenderingMap(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var didFinishRenderingMap: ControlEvent<Bool> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapViewDidFinishRenderingMap(_:fullyRendered:)))
            .map { a in
                return try castOrThrow(Bool.self, a[1])
            }
        return ControlEvent(events: source)
    }

    // MARK: Tracking the User Location

    public var willStartLocatingUser: ControlEvent<Void> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapViewWillStartLocatingUser(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var didStopLocatingUser: ControlEvent<Void> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapViewDidStopLocatingUser(_:)))
            .map { _ in
                return()
            }
        return ControlEvent(events: source)
    }

    public var didUpdateUserLocation: ControlEvent<MKUserLocation> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:didUpdate:)))
            .map { a in
                return try castOrThrow(MKUserLocation.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var didFailToLocateUserWithError: Observable<NSError> {
        return delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:didFailToLocateUserWithError:)))
            .map { a in
                return try castOrThrow(NSError.self, a[1])
            }
    }

    public var didChangeUserTrackingMode: ControlEvent<(mode: MKUserTrackingMode, animated: Bool)> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:didChange:animated:)))
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

    public var didAddAnnotationViews: ControlEvent<[MKAnnotationView]> {
        let source = delegate
            .methodInvoked(#selector(
                (MKMapViewDelegate.mapView(_:didAdd:))!
                    as (MKMapViewDelegate) -> (MKMapView, [MKAnnotationView]) -> Void
                )
            )
            .map { a in
                return try castOrThrow([MKAnnotationView].self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var annotationViewCalloutAccessoryControlTapped:
        ControlEvent<(view: MKAnnotationView, control: UIControl)> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:annotationView:calloutAccessoryControlTapped:)))
            .map { a in
                return (view: try castOrThrow(MKAnnotationView.self, a[1]),
                    control: try castOrThrow(UIControl.self, a[2]))
            }
        return ControlEvent(events: source)
    }

    // MARK: Selecting Annotation Views

    public var didSelectAnnotationView: ControlEvent<MKAnnotationView> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:didSelect:)))
            .map { a in
                return try castOrThrow(MKAnnotationView.self, a[1])
            }
        return ControlEvent(events: source)
    }

    public var didDeselectAnnotationView: ControlEvent<MKAnnotationView> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:didDeselect:)))
            .map { a in
                return try castOrThrow(MKAnnotationView.self, a[1])
            }
        return ControlEvent(events: source)
    }

    #if swift(>=4.2)
        public typealias AnnotationViewDragState = MKAnnotationView.DragState
    #else
        public typealias AnnotationViewDragState = MKAnnotationViewDragState
    #endif

    public var didChangeState: ControlEvent<(view: MKAnnotationView, newState: AnnotationViewDragState, oldState: AnnotationViewDragState)> {
        let source = delegate
            .methodInvoked(#selector(MKMapViewDelegate.mapView(_:annotationView:didChange:fromOldState:)))
            .map { a in
                return (view: try castOrThrow(MKAnnotationView.self, a[1]),
                    newState: try castOrThrow(UInt.self, a[2]),
                    oldState: try castOrThrow(UInt.self, a[3]))
            }
            .map { (view, newState, oldState) in
                return (view: view,
                    newState: AnnotationViewDragState(rawValue: newState)!,
                    oldState: AnnotationViewDragState(rawValue: oldState)!)
            }
        return ControlEvent(events: source)
    }

    // MARK: Managing the Display of Overlays

    public var didAddOverlayRenderers: ControlEvent<[MKOverlayRenderer]> {
        let source = delegate
            .methodInvoked(#selector(
                (MKMapViewDelegate.mapView(_:didAdd:))!
                    as (MKMapViewDelegate) -> (MKMapView, [MKOverlayRenderer]) -> Void
                )
            )
            .map { a in
                return try castOrThrow([MKOverlayRenderer].self, a[1])
            }
        return ControlEvent(events: source)
    }

    // MARK: Binding annotation to the Map
    public func annotations<
        A: MKAnnotation,
        O: ObservableType>
        (_ source: O)
        -> Disposable
        where O.Element == [A] {
            return self.annotations(dataSource: RxMapViewReactiveAnnotationDataSource())(source)
    }

    public func annotations<
        DataSource: RxMapViewDataSourceType,
        O: ObservableType>
        (dataSource: DataSource)
        -> (_ source: O)
        -> Disposable
        where O.Element == [DataSource.Element],
        DataSource.Element: MKAnnotation {
            return { source in
                return source
                    .subscribe({ event in
                        dataSource.mapView(self.base, observedEvent: event)
                    })
            }
    }

  // MARK: Binding overlay to the Map
  public func overlays<
    A: MKOverlay,
    O: ObservableType>
    (_ source: O)
    -> Disposable
    where O.Element == [A] {
      return self.overlays(dataSource: RxMapViewReactiveOverlayDataSource())(source)
  }
  
  public func overlays<
    DataSource: RxMapViewDataSourceType,
    O: ObservableType>
    (dataSource: DataSource)
    -> (_ source: O)
    -> Disposable
    where O.Element == [DataSource.Element],
    DataSource.Element: MKOverlay {
      return { source in
        return source
          .subscribe({ event in
            dataSource.mapView(self.base, observedEvent: event)
          })
      }
  }
  
    /// Installs delegate as forwarding delegate on `delegate`.
    /// Delegate won't be retained.
    ///
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    ///
    /// - parameter delegate: Delegate object.
    /// - returns: Disposable object that can be used to unbind the delegate.
    public func setDelegate(_ delegate: MKMapViewDelegate)
        -> Disposable {
        return RxMKMapViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}
