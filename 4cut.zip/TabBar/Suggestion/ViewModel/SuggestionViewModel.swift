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

    let postList = PublishSubject<[PostContent]>()

    struct Input {
        let categoryTap: Observable<PostCategory>
        let newButtonTap: Observable<PostCategory>
        let backgroudButtonTap: Observable<PostCategory>
        let poseButtonTap: Observable<PostCategory>
    }

    struct Output {
        let postList: Observable<[PostContent]>
    }

    func transform(input: Input) -> Output {
        callRequest(category: input.categoryTap)
        callRequest(category: input.newButtonTap)
        callRequest(category: input.poseButtonTap)
        callRequest(category: input.backgroudButtonTap)
        return Output(postList: postList)
    }

    private func callRequest(category: Observable<PostCategory>) {
        category
            .flatMap { category in
                NetworkManager.shared.fetchPostContent(category: category)
            }
            .subscribe(onNext: { [weak self] value in
                guard let self else { return }

                switch value {
                case .success(let value):
                    postList.onNext(value.data)
                case .failure:
                    print("추천글 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)
    }

}
