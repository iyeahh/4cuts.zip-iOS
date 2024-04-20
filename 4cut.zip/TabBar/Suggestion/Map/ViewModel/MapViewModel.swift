//
//  MapViewModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MapViewModel: BaseViewModel {

    let disposeBag = DisposeBag()
    let markList = [PhotoBooth]()
    let markListSubject = PublishSubject<[PhotoBooth]>()

    struct Input {
        let locationSubject: PublishSubject<(Double, Double)>
        let defaultSubject: PublishSubject<(Double, Double)>
    }

    struct Output {
        let markList: Observable<[PhotoBooth]>
        let locationSubject: PublishSubject<(Double, Double)>
    }

    func transform(input: Input) -> Output {
        callRequest(subject: input.locationSubject)
        callRequest(subject: input.defaultSubject)

        return Output(markList: markListSubject, locationSubject: input.locationSubject)
    }

    func callRequest(subject: PublishSubject<(Double, Double)>) {
        subject
        .flatMap { location -> Single<Result<MapModel, NetworkError>> in
            NetworkManager.shared.postCallRequestWithoutToken(router: .map(x: location.1, y: location.0))
        }
        .subscribe(with: self, onNext: { owner, value in
            switch value {
            case .success(let value):
                owner.markListSubject.onNext(value.documents)
            case .failure:
                print("맵 받아오기 실패")
            }
        })
        .disposed(by: disposeBag)
    }

}
