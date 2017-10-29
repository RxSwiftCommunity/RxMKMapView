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

class RxMKMapViewDelegateProxy: DelegateProxy, MKMapViewDelegate, DelegateProxyType {

    class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let mapView: MKMapView = (object as? MKMapView)!
        return mapView.delegate
    }
    
    class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let mapView: MKMapView = (object as? MKMapView)!
        mapView.delegate = delegate as? MKMapViewDelegate
    }
    
}
