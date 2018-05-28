//
//  RxMapViewDataSourceType.swift
//  RxMKMapView
//
//  Created by Mikko Välimäki on 08/08/2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import MapKit
import RxSwift

public protocol RxMapViewDataSourceType {
    /// Type of elements that can be bound to table view.
    associatedtype Element

    /// New observable sequence event observed.
    ///
    /// - parameter mapView: Bound map view.
    /// - parameter observedEvent: Event
    func mapView(_ mapView: MKMapView, observedEvent: Event<[Element]>)
}
