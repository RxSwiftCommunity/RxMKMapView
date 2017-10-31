//
//  ViewController.swift
//  RxMKMapView
//
//  Created by Spiros Gerokostas on 01/04/2016.
//  Copyright (c) 2016 RxSwift Community. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxMKMapView

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapView = MKMapView(frame: view.frame)
        view.addSubview(mapView)

        mapView.rx.willStartLoadingMap
            .asDriver()
            .drive(onNext: {
                print("map started loaded")
            })
            .disposed(by: disposeBag)

        mapView.rx.didFinishLoadingMap
            .asDriver()
            .drive(onNext: {
                print("map finished loaded")
            })
            .disposed(by: disposeBag)

        mapView.rx.regionDidChangeAnimated
            .asDriver()
            .drive(onNext: { _ in
                print("map region changed")
            })
            .disposed(by: disposeBag)
    }
}
