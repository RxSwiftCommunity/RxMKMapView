//
//  ViewController.swift
//  RxMKMapView
//
//  Created by Spiros Gerokostas on 01/04/2016.
//  Copyright (c) 2016 Spiros Gerokostas. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import RxMKMapView

class ViewController: UIViewController {

    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

