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

    struct Input {
        let photoButtonTap: ControlEvent<Void>
        let uploadButtonTap: Observable<(UIImage?, String?)>
    }

    struct Output {
        let photoButtonTap: ControlEvent<Void>
        let popNavi: Observable<Bool>
    }
    
    func transform(input: Input) -> Output {
        let popNavi = BehaviorSubject(value: false)

        input.uploadButtonTap
            .subscribe(with: self) { owner, contentValue in
                do {
                    AF.upload(multipartFormData: { multipartFormData in
                        print(contentValue)
                        if let image = contentValue.0,
                           let convertedImage = image.jpegData(compressionQuality: 0.1) {
                            multipartFormData.append(convertedImage, withName: "files", fileName: "test.png", mimeType: "image/png")
                        }
                    }, with: try Router.uploadPhoto.asURLRequest())
                    .responseDecodable(of: PhotoListModel.self) { response in
                        switch response.result {
                        case .success(let value):
                            Observable.just(value)
                                .flatMap { photo -> Single<Result<PostContent, NetworkError>> in
                                    NetworkManager.shared.callRequestWithToken(router: .postContent(content: Content(content: contentValue.1!, product_id: "4cut_booth", files: photo.files)))
                                }
                                .subscribe(onNext: { value in
                                    switch value {
                                    case .success:
                                        popNavi.onNext(true)
                                    case .failure:
                                        print("글 업로드 실패")
                                    }
                                })
                                .disposed(by: owner.disposeBag)
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
    
}
