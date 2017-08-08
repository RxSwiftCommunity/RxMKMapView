//
//  RxMapViewReactiveDataSource.swift
//  RxMKMapView
//
//  Created by Mikko Välimäki on 09/08/2017.
//  Copyright © 2017 RxSwiftCommunity. All rights reserved.
//

import Foundation
import MapKit
import RxSwift
import RxCocoa

public class RxMapViewReactiveDataSource: RxMapViewDataSourceType {
    
    public typealias Element = MKAnnotation
    
    var currentAnnotations: [MKAnnotation] = []
    
    public func mapView(_ mapView: MKMapView, observedEvent: Event<[MKAnnotation]>) {
        UIBindingObserver(UIElement: self) { (animator, newAnnotations) in
            DispatchQueue.main.async {
                mapView.removeAnnotations(self.currentAnnotations)
                self.currentAnnotations = newAnnotations
                mapView.addAnnotations(newAnnotations)
            }
        }.on(observedEvent)
    }
    
}
