//
//  MapViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/30/24.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation
import NMapsMap

final class MapViewController: BaseViewController {

    let disposeBag = DisposeBag()
    let viewModel = MapViewModel()
    let locationSubject = PublishSubject<(Double, Double)>()

    let locationManager = CLLocationManager()
    lazy var naverMapView = NMFNaverMapView(frame: view.frame)

    override func configureView() {
        naverMapView.showLocationButton = true

        locationManager.delegate = self
        view.addSubview(naverMapView)
        checkDeviceLocationAutorization()
    }

    override func bind() {
        let input = MapViewModel.Input(locationSubject: locationSubject)

        let output = viewModel.transform(input: input)

        output.markList
            .subscribe(with: self) { owner, value in
                value.forEach { photoBooth in
                    let marker = NMFMarker()
                    owner.makeMarker(photoBooth)
                }
            }
            .disposed(by: disposeBag)

        output.locationSubject
            .subscribe(with: self) { owner, value in
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: value.0, lng: value.1))
                owner.naverMapView.mapView.moveCamera(cameraUpdate)
            }
            .disposed(by: disposeBag)
    }

    func makeMarker(_ photoBooth: PhotoBooth) {
        let marker = NMFMarker()

        let x = Double(photoBooth.x)!
        let y = Double(photoBooth.y)!

        marker.captionRequestedWidth = 50
        marker.captionText = photoBooth.place_name
        marker.captionColor = Constant.Color.accent
        marker.iconTintColor = Constant.Color.accent
        marker.position = NMGLatLng(lat: y, lng: x)
        let image = UIImage(systemName: "camera.circle")!
        marker.iconImage = NMFOverlayImage(image: image)
        marker.mapView = naverMapView.mapView
    }

    func checkDeviceLocationAutorization() {

        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization()
        } else {
            print("위치 서비스가 꺼져 있어서, 위치 권한 요청을 할 수 없어요")
        }
    }

    func checkCurrentLocationAuthorization() {
        var status: CLAuthorizationStatus

        if #available(iOS 14.0, *) {
            status = locationManager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }

        switch status {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .denied:
            view.makeToast("아이폰 설정앱에서 위치 서비스를 켜주세요.")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print(status)
        }
    }

}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            Observable.just(coordinate)
                .subscribe(with: self) { owner, location in
                    owner.locationSubject.onNext((location.latitude, location.longitude))
                }
                .disposed(by: disposeBag)
        }
        locationManager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAutorization()
    }

}
