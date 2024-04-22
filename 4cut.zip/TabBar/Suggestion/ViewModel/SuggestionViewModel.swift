//
//  SuggestionViewModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SuggestionViewModel: BaseViewModel {

    let disposeBag = DisposeBag()

    var postContentList: [PostContent] = []
    let postList = PublishSubject<[PostContent]>()

    struct Input {
        let categoryTap: Observable<PostCategory>
        let newButtonTap: Observable<PostCategory>
        let backgroudButtonTap: Observable<PostCategory>
        let poseButtonTap: Observable<PostCategory>
        let cellTap: Observable<(ControlEvent<PostContent>.Element, ControlEvent<IndexPath>.Element)>
        let followButtonTap: Observable<String>
    }

    struct Output {
        let postList: Observable<[PostContent]>
        let nextVCObservable: Observable<(PostContent, IndexPath)>
    }

    func transform(input: Input) -> Output {
        let nextVCSubject = PublishSubject<(PostContent, IndexPath)>()

        callRequest(category: input.categoryTap)
        callRequest(category: input.newButtonTap)
        callRequest(category: input.poseButtonTap)
        callRequest(category: input.backgroudButtonTap)

        input.cellTap
            .subscribe(with: self) { owner, value in
                nextVCSubject.onNext(value)
            }
            .disposed(by: disposeBag)

        input.followButtonTap
            .flatMap { postId -> Single<Result<PostContentModel, NetworkError>> in
                NetworkManager.shared.callRequestWithToken(router: .removePost(id: postId))
            }
            .subscribe(onNext: { value in

                switch value {
                case .success:
                    print("삭제 성공")
                case .failure:
                    print("추천글 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)


        return Output(postList: postList, nextVCObservable: nextVCSubject)
    }

    private func callRequest(category: Observable<PostCategory>) {
        category
            .flatMap { category -> Single<Result<PostContentModel, NetworkError>> in
                NetworkManager.shared.callRequestWithToken(router: .fetchPostContent(category: category, next: ""))
            }
            .subscribe(onNext: { [weak self] value in
                guard let self else { return }

                switch value {
                case .success(let value):
                    postContentList = value.data
                    postList.onNext(postContentList)
                case .failure:
                    print("추천글 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)
    }

}
