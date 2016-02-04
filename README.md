RxMKMapView
===

RxMKMapView is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper for MKMapView (MapKit) `delegate`.

[![Version](https://img.shields.io/cocoapods/v/RxMKMapView.svg?style=flat)](http://cocoapods.org/pods/RxMKMapView)
[![License](https://img.shields.io/cocoapods/l/RxMKMapView.svg?style=flat)](http://cocoapods.org/pods/RxMKMapView)
[![Platform](https://img.shields.io/cocoapods/p/RxMKMapView.svg?style=flat)](http://cocoapods.org/pods/RxMKMapView)

## Installation

RxMKMapView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "RxMKMapView"
```

## Example Usages

```swift

// MARK: Setup MKMapView

let mapView = MKMapView(frame: view.frame)
view.addSubview(mapView)

// MARK: Responding to Loading Events

mapView.rx_mapViewWillStartLoadingMap
.subscribeNext {
	print("rx_mapViewWillStartLoadingMap")
}.addDisposableTo(disposeBag)

mapView.rx_mapViewDidFinishLoadingMap
.subscribeNext { _ in
	print("rx_mapViewDidFinishLoadingMap")
}.addDisposableTo(disposeBag)

```

## Requirements

RxMKMapView requires Swift 2.0 and RxSwift (2.0.0).

## License

RxMKMapView is available under the MIT license. See the LICENSE file for more info.

