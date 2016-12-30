RxMKMapView
===

RxMKMapView is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper for MKMapView (MapKit) `delegate`.

[![Build Status](https://travis-ci.org/RxSwiftCommunity/RxMKMapView.svg?branch=master)](https://travis-ci.org/RxSwiftCommunity/RxMKMapView)
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

mapView.rx.willStartLoadingMap
    .subscribe(onNext: {
        print("rx.willStartLoadingMap")
    })
    .addDisposableTo(disposeBag)

mapView.rx.didFinishLoadingMap
    .subscribe(onNext { _ in
        print("rx.didFinishLoadingMap")
    })
    .addDisposableTo(disposeBag)

```

## Requirements

RxMKMapView requires Swift 3.0 and RxSwift (3.0.0-beta.2).

## License

RxMKMapView is available under the MIT license. See the LICENSE file for more info.

