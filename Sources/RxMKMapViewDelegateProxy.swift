//
//  RxMKMapViewDelegateProxy.swift
//  RxCocoa
//
//  Created by Spiros Gerokostas on 04/01/16.
//  Copyright © 2016 Spiros Gerokostas. All rights reserved.
//

import MapKit
import RxSwift
import RxCocoa

extension MKMapView: HasDelegate {
    public typealias Delegate = MKMapViewDelegate
}

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {

    /// Typed parent object.
    public weak private(set) var mapView: MKMapView?

    /// - parameter mapView: Parent object for delegate proxy.
    public init(mapView: ParentObject) {
        self.mapView = mapView
        super.init(parentObject: mapView, delegateProxy: RxMKMapViewDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        self.register { RxMKMapViewDelegateProxy(mapView: $0) }
    }
}

class RxMapViewAnnotationViewBuilderDelegate<A: MKAnnotation>: NSObject, MKMapViewDelegate {
    typealias AnnotationViewBuilder = (MKMapView, A) -> MKAnnotationView
    private let annotationViewBuilder: AnnotationViewBuilder
    init(annotationViewBuilder: @escaping AnnotationViewBuilder) {
        self.annotationViewBuilder = annotationViewBuilder
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let typedAnnotation = annotation as? A else {
            // Just let the system handle this
            return nil
        }
        return annotationViewBuilder(mapView, typedAnnotation)
    }
}
