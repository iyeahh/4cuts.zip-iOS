//
//  PostViewModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/31/24.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class PostViewModel: BaseViewModel {

    let disposeBag = DisposeBag()
    let popNavi = BehaviorSubject(value: false)

    struct Input {
        let photoButtonTap: ControlEvent<Void>
        let uploadButtonTap: Observable<([UIImage], ControlProperty<String>.Element, String?)>
    }

    struct Output {
        let photoButtonTap: ControlEvent<Void>
        let popNavi: Observable<Bool>
    }

    func transform(input: Input) -> Output {
        input.uploadButtonTap
            .subscribe(with: self) { owner, contentValue in
                do {
                    AF.upload(multipartFormData: { multipartFormData in
                        contentValue.0.forEach { image in
                                if let convertedImage = image.jpegData(compressionQuality: 0.1) {
                                multipartFormData.append(convertedImage, withName: "files", fileName: "test.png", mimeType: "image/png")
                            }
                        }
                    }, with: try Router.uploadPhoto.asURLRequest())
                    .responseDecodable(of: PhotoListModel.self) { [weak self] response in
                        guard let self else { return }
                        switch response.result {
                        case .success(let value):
                            Observable.just(value)
                                .flatMap { photo -> Single<Result<PostContent, NetworkError>> in
                                    if let id = contentValue.2 {
                                        NetworkManager.shared.callRequestWithToken(router: .editPost(id: id, content: Content(content: contentValue.1, product_id: "4cut_booth", files: photo.files)))
                                    } else {
                                        NetworkManager.shared.callRequestWithToken(router: .postContent(content: Content(content: contentValue.1, product_id: "4cut_booth", files: photo.files)))
                                    }
                                }
                                .subscribe(onNext: { value in
                                    switch value {
                                    case .success:
                                        self.popNavi.onNext(true)
                                    case .failure:
                                        print("글 업로드 실패")
                                    }
                                })
                                .disposed(by: self.disposeBag)
                        case .failure:
                            print("사진 업로드 실패")
                        }
                    }
                } catch {
                }

            }
            .disposed(by: disposeBag)
        return Output(photoButtonTap: input.photoButtonTap, popNavi: popNavi)
    }

    private func post(content: String, imageList: [UIImage], id: String?) {
    }

}
