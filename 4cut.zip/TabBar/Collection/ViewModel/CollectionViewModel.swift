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
        let isNextCursor: ControlEvent<[IndexPath]>
    }

    struct Output {
        let successData: BehaviorRelay<[PhotoModel]>
    }

    func transform(input: Input) -> Output {
        let successData = BehaviorRelay<[PhotoModel]>(value: [])
        var next = BehaviorRelay(value: "")

        input.startTriggerSub
            .flatMap { category -> Single<Result<PostContentModel, NetworkError>> in
                NetworkManager.shared.callRequestWithToken(router: .fetchPostContent(category: category, next: next.value))
            }
            .subscribe(onNext: { [weak self] value in
                guard let self else { return }

                switch value {
                case .success(let value):
                    next.accept(value.next_cursor)

                    var array: [PhotoModel] = []

                    let _ = value.data.map({ photo in
                        self.loadImageAndGetSize(url: photo.files.first!.url!) { size in
                            array.append(PhotoModel(photo: photo.files.first!, aspect: (size?.width ?? 100) / (size?.height ?? 0)))
                            successData.accept(array)
                            self.realModel = array
                        }
                    })
                case .failure:
                    print("사진 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)


        input.isNextCursor
            .map({ item in
                item.last?.item == self.realModel.count - 8 && next.value != "0"
            })
            .filter({ value in
                value == true
            })
            .flatMap { category -> Single<Result<PostContentModel, NetworkError>> in
                NetworkManager.shared.callRequestWithToken(router: .fetchPostContent(category: .photo, next: next.value))
            }
            .subscribe(onNext: { [weak self] value in
                guard let self else { return }
                switch value {
                        case .success(let value):
                            var photoModel: [PhotoModel] = []
                            let dispatchGroup = DispatchGroup()

                            value.data.forEach { photo in
                                dispatchGroup.enter()
                                self.loadImageAndGetSize(url: photo.files.first!.url!) { size in
                                    photoModel.append(PhotoModel(photo: photo.files.first!, aspect: (size?.width ?? 10) / (size?.height ?? 10)))
                                    dispatchGroup.leave()
                                }
                            }

                            dispatchGroup.notify(queue: .main) {
                                self.realModel.append(contentsOf: photoModel)
                                successData.accept(self.realModel)
                                print(self.realModel)
                            }
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
