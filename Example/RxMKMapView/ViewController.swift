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

        let points = loadPointsOfInterest()

        let mapView = MKMapView(frame: view.frame)
        mapView.delegate = self
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

        mapView.rx.regionDidChangeAnimated
            .map { _ in mapView.region }
            .observeOn(MainScheduler.instance)
            .map { region -> [MKAnnotation] in
                return points.filter(region.contains(poi:))
            }.bind(to: mapView.rx.annotations)
            .disposed(by: disposeBag)
    }
}

extension ViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        view.tintColor = .green
        view.canShowCallout = true
        return view
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            view.alpha = 0
        }
        UIView.animate(withDuration: 0.4, animations: {
            for view in views {
                view.alpha = 1
            }
        })
    }
}

class PointOfInterest: NSObject, MKAnnotation {

    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

func loadPointsOfInterest() -> [PointOfInterest] {
    print("Loading POIs...")
    if let path = Bundle.main.path(forResource: "simplemaps-worldcities-basic", ofType: "csv") {
        // Just read the whole chunk, it should be small enough for the example.
        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            let cities = lines.flatMap { line -> PointOfInterest? in
                let csv = line.components(separatedBy: ",")
                guard csv.count > 3,
                    let lat = Double(csv[2]),
                    let lon = Double(csv[3]),
                    let population = Double(csv[4]) else {
                        return nil
                }
                let name = csv[0]
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let subtitle = "Population \(population)"
                return PointOfInterest(title: name, subtitle: subtitle, coordinate: coord)
            }
            print("Found \(cities.count) POIs:")
            return cities
        } catch {
            print(error)
            abort()
        }
    }

    return []
}

extension MKCoordinateRegion {

    func contains(poi: PointOfInterest) -> Bool {
        return abs(self.center.latitude - poi.coordinate.latitude) <= self.span.latitudeDelta / 2.0
            && abs(self.center.longitude - poi.coordinate.longitude) <= self.span.longitudeDelta / 2.0
    }
}
