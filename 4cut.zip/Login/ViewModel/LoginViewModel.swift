//
//  LoginViewModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {

    let disposeBag = DisposeBag()

    struct Input {
        let emailTextFieldText: ControlProperty<String>
        let passwordTextFieldText: ControlProperty<String>
        let signInButtonTap: ControlEvent<Void>
    }

    struct Output {
        let validLogin: Observable<Bool>
    }

    func transform(input: Input) -> Output {

        let validLogin = PublishSubject<Bool>()

        input.signInButtonTap
            .withLatestFrom(Observable.combineLatest(input.emailTextFieldText, input.passwordTextFieldText))
            .flatMap { email, password in
                NetworkManager.shared.createLogin(email: email, password: password)
            }
            .subscribe(onNext: { value in
                switch value {
                case .success(let value):
                    UserDefaultsManager.token = value.access
                    UserDefaultsManager.refreshToken = value.refresh
                    validLogin.onNext(true)
                case .failure:
                    validLogin.onNext(false)
                }
            })
            .disposed(by: disposeBag)

        return Output(validLogin: validLogin)
    }

}
