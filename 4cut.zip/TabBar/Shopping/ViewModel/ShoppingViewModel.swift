//
//  ShoppingViewModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ShoppingViewModel: BaseViewModel {

    let disposeBag = DisposeBag()

    struct Input {
        let viewDidLoad: Observable<Void>
    }

    struct Output {
        let shoppingList: Observable<[Observable<[Item]>]>
    }

    func transform(input: Input) -> Output {
        let albumList = PublishSubject<[Item]>()
        let frameList = PublishSubject<[Item]>()
        let keyRingList = PublishSubject<[Item]>()

        input.viewDidLoad
            .flatMap { category in
                NetworkManager.shared.fetchShopping(query: "인생네컷 앨범")
            }
            .subscribe(onNext: { value in
                switch value {
                case .success(let value):
                    albumList.onNext(value.items)
                case .failure:
                    print("인생네컷 앨범 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)

        input.viewDidLoad
            .flatMap { category in
                NetworkManager.shared.fetchShopping(query: "인생네컷 액자")
            }
            .subscribe(onNext: { value in
                switch value {
                case .success(let value):
                    frameList.onNext(value.items)
                case .failure:
                    print("인생네컷 액자 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)

        input.viewDidLoad
            .flatMap { category in
                NetworkManager.shared.fetchShopping(query: "인생네컷 키링")
            }
            .subscribe(onNext: { value in
                switch value {
                case .success(let value):
                    keyRingList.onNext(value.items)
                case .failure:
                    print("인생네컷 키링 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)

        let shoppingList: Observable<[Observable<[Item]>]> = Observable.just([
                    albumList.asObservable(),
                    frameList.asObservable(),
                    keyRingList.asObservable()
                ])

        return Output(shoppingList: shoppingList)
    }

}
