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

    struct Input {
        let locationSubject: PublishSubject<(Double, Double)>
    }

    struct Output {
        let markList: Observable<[PhotoBooth]>
        let locationSubject: PublishSubject<(Double, Double)>
    }

    func transform(input: Input) -> Output {
        let markList = PublishSubject<[PhotoBooth]>()

        input.locationSubject
            .flatMap { location -> Single<Result<MapModel, NetworkError>> in
                NetworkManager.shared.postCallRequestWithoutToken(router: .map(x: location.0, y: location.1))
            }
            .subscribe(onNext: { value in
                switch value {
                case .success(let value):
                    markList.onNext(value.documents)
                case .failure:
                    print("맵 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)

        return Output(markList: markList, locationSubject: input.locationSubject)
    }
    
}
