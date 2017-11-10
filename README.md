RxMKMapView
===

RxMKMapView is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper for MKMapView (MapKit) `delegate`.

[![CircleCI](https://circleci.com/gh/RxSwiftCommunity/RxMKMapView.svg?style=svg)](https://circleci.com/gh/RxSwiftCommunity/RxMKMapView)
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

// MARK: Respond to Loading Events
mapView.rx.willStartLoadingMap
       .asDriver()
       .drive(onNext: {
           print("map started loadedloading)
       })
       .disposed(by: disposeBag)

mapView.rx.didFinishLoadingMap
       .asDriver()
       .drive(onNext: {
           print("map finished loading")
       })
       .disposed(by: disposeBag)
```

## Requirements

RxMKMapView requires Swift 4.0 and RxSwift (4.0).

## License

RxMKMapView is available under the MIT license. See the LICENSE file for more info.

