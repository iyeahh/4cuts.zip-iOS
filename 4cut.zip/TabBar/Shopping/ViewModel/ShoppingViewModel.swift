//
//  ShoppingViewModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/28/24.
//

import Foundation
import RxSwift
import RxCocoa
import iamport_ios

final class ShoppingViewModel: BaseViewModel {

    let disposeBag = DisposeBag()

    struct Input {
        let viewDidLoad: Observable<[ShoppingCategory]>
        let payTap: PublishSubject<(String, Int?)>
    }

    struct Output {
        let shoppingList: Observable<[Observable<[PostContent]>]>
        let payment: Observable<(IamportPayment, String)>
    }

    func transform(input: Input) -> Output {
        let shoppingList = PublishSubject<[Observable<[PostContent]>]>()
        let outputPayment = PublishSubject<(IamportPayment, String)>()

        input.viewDidLoad
            .flatMap { category in
                NetworkManager.shared.fetchShopping(query: category)
            }
            .subscribe(onNext: { value in
                switch value {
                case .success(let value):
                    let array = value.map { items in
                        Observable.just(items)
                    }
                    
                    shoppingList.onNext(array)

                case .failure:
                    print("쇼핑 받아오기 실패")
                }
            })
            .disposed(by: disposeBag)

        input.payTap
            .subscribe(with: self) { owner, value in
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"),
                    merchant_uid: "ios_\(APIKey.sesacKey)_\(Int(Date().timeIntervalSince1970))",
                    amount: "\(value.1!)").then {
                        $0.pay_method = PayMethod.card.rawValue
                        $0.name = "4cut.zip"
                        $0.buyer_name = "양보라"
                        $0.app_scheme = "sesac"
                    }
                outputPayment.onNext((payment, value.0))
            }
            .disposed(by: disposeBag)

        return Output(shoppingList: shoppingList, payment: outputPayment)
    }

}
