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

    struct Input {
        let categoryTap: BehaviorSubject<PostCategory>
    }

    struct Output {
        let postList: Observable<[PostContent]>
    }

    func transform(input: Input) -> Output {
        let postList1 = PublishSubject<[PostContent]>()

        input.categoryTap
            .flatMap { category in
                NetworkManager.shared.fetchPostContent(category: category)
            }
            .subscribe(onNext: { value in
                switch value {
                case .success(let value):
                    postList1.onNext(value.data)
                case .failure:
                    print("추천글 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)

        return Output(postList: postList1)
    }

}
