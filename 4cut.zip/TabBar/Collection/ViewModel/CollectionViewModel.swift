//
//  CollectionViewModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/27/24.
//

import Foundation
import RxSwift
import RxCocoa
import Kingfisher

final class CollectionViewModel: BaseViewModel {

    var realModel: [PhotoModel] = [PhotoModel(photo: "dkdkdkd", aspect: 0.5)]

    let disposeBag = DisposeBag()

    struct Input {
        let startTriggerSub: BehaviorRelay<PostCategory>
    }

    struct Output {
        let successData: BehaviorRelay<[PhotoModel]>
    }

    func transform(input: Input) -> Output {
        let successData = BehaviorRelay<[PhotoModel]>(value: [])

        input.startTriggerSub
            .flatMap { category -> Single<Result<PostContentModel, NetworkError>> in
                NetworkManager.shared.callRequestWithToken(router: .fetchPostContent(category: category))
            }
            .subscribe(onNext: { [weak self] value in
                guard let self else { return }

                switch value {
                case .success(let value):
                    var aarray: [PhotoModel] = []

                    let _ = value.data.map({ photo in
                        self.loadImageAndGetSize(url: photo.files.first!.url!) { size in
                            aarray.append(PhotoModel(photo: photo.files.first!, aspect: (size?.width ?? 100) / (size?.height ?? 0)))
                            successData.accept(aarray)
                            self.realModel = aarray
                        }
                    })
                case .failure:
                    print("사진 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)
        return Output(successData: successData)
    }

    func loadImageAndGetSize(url: URL, completion: @escaping (CGSize?) -> Void) {
        let resource = KF.ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource) { result in
            switch result {
            case .success(let value):
                let size = value.image.size
                completion(size)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }

}
