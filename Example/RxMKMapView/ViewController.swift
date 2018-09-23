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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let points = loadPointsOfInterest()
                        .asObservable()
                        .share(replay: 1)

        /// Map region change and search into an array of Annotations
        /// and bind these annotations directly into the Map View.
        Observable
            .combineLatest(mapView.rx.region,
                           searchBar.rx.text.orEmpty)
            .withLatestFrom(points) { ($1, $0.0, $0.1) }
            .map { points, region, text -> [MKAnnotation] in
                let query = text.trimmingCharacters(in: .whitespaces)

                return points.filter { poi in
                    if !query.isEmpty {
                        guard let title = poi.title else { return false }
                        return title.contains(query) && region.contains(poi: poi)
                    } else {
                        return region.contains(poi: poi)
                    }
                }
            }
            .asDriver(onErrorJustReturn: [])
            .drive(mapView.rx.annotations)
            .disposed(by: disposeBag)

        /// Reactive extensions for MKMapViewDelegate's
        /// various delegate methods
        mapView.rx.willStartLoadingMap
            .asDriver()
            .drive(onNext: {
                print("Map started loading")
            })
            .disposed(by: disposeBag)

        mapView.rx.didFinishLoadingMap
            .asDriver()
            .drive(onNext: {
                print("Map finished loading")
            })
            .disposed(by: disposeBag)

        mapView.rx.regionDidChangeAnimated
            .subscribe(onNext: { _ in
                print("Map region changed")
            })
            .disposed(by: disposeBag)

        mapView.rx.region
            .subscribe(onNext: { region in
                print("Map region is now \(region)")
            })
            .disposed(by: disposeBag)

        // Install a forwarding delegate so we can use Rx Delegate Proxy
        // alongside our regular imperative delegate
        mapView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        searchBar.rx
                 .searchButtonClicked
                 .observeOn(MainScheduler.instance)
                 .subscribe(onNext: { [searchBar] in searchBar?.resignFirstResponder() })
                 .disposed(by: disposeBag)

        setupKeyboard()
    }

    func loadPointsOfInterest() -> Single<[PointOfInterest]> {
        print("Loading POIs...")
        guard let path = Bundle.main.path(forResource: "simplemaps-worldcities-basic", ofType: "csv") else {
            fatalError("Missing Sample Data")
        }

        do {
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            let cities = lines.compactMap { line -> PointOfInterest? in
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

            print("Found \(cities.count) POIs")
            return Single.just(cities)
        } catch let error {
            return Single.error(error)
        }
    }

    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Keyboard Setup
extension ViewController {
    @objc func keyBoardWillShow(notification: NSNotification) {
        let frame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = frame.height
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyBoardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - MKMapView Delegates
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        view.tintColor = .green
        view.canShowCallout = true
        return view
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0.0 }

        UIView.animate(withDuration: 0.4,
                       animations: {
                        views.forEach { $0.alpha = 1.0 }
                       })
    }
}

// MARK: - Map Annotation and Helpers
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

extension MKCoordinateRegion {
    func contains(poi: PointOfInterest) -> Bool {
        return abs(self.center.latitude - poi.coordinate.latitude) <= self.span.latitudeDelta / 2.0
            && abs(self.center.longitude - poi.coordinate.longitude) <= self.span.longitudeDelta / 2.0
    }
}
