#
# Be sure to run `pod lib lint RxMKMapView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxMKMapView'
  s.version          = '5.0.0'
  s.summary          = 'Reactive wrapper for MKMapView `delegate`'
  s.description      = <<-DESC
RxMKMapView is a Reactive wrapper for MKMapView `delegate`.

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

// MARK: Bind Annotations

requestForAnnotations() // Observable<MKAnnotation>
    .asDriver(onErrorJustReturn: [])
    .drive(mapView.rx.annotations)
    .disposed(by: disposeBag)

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
DESC

  s.homepage            = 'https://github.com/RxSwiftCommunity/RxMKMapView'
  s.license             = 'MIT'
  s.author              = { 'RxSwift Community' => 'community@rxswift.org' }
  s.source              = { :git => 'https://github.com/RxSwiftCommunity/RxMKMapView.git', :tag => s.version.to_s }
  s.platform            = :ios, '8.0'
  s.requires_arc        = true

  s.source_files        = 'Sources/**/*.swift'

  s.dependency 'RxCocoa', '~> 5.0'
  s.dependency 'RxSwift', '~> 5.0'
  s.frameworks = 'Foundation'
end
