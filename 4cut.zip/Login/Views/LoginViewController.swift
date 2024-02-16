//
//  LoginViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LoginViewController: BaseViewController {

    let viewModel = LoginViewModel()
    let disposeBag = DisposeBag()

    let emailTextField = BlackBorderTextField(placeholderText: Constant.Login.emailPlaceholder)
    let emailDescriptionLabel = RedColorLabel()
    let passwordTextField = BlackBorderTextField(placeholderText: Constant.Login.passwordPlaceholder)
    let passwordDescriptionLabel = RedColorLabel()
    let signInButton = BlackBackgroundButton(title: Constant.Login.buttonTitle)

    override func configureView() {
        view.backgroundColor = .white
    }

    override func configureHierarchy() {
        view.addSubview(emailTextField)
        view.addSubview(emailDescriptionLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordDescriptionLabel)
        view.addSubview(signInButton)
    }

    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        emailDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(5)
            make.leading.equalTo(emailTextField).offset(5)
        }

        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        passwordDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(5)
            make.leading.equalTo(passwordTextField).offset(5)
        }

        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    override func bind() {
        let input = LoginViewModel.Input(emailTextFieldText: emailTextField.rx.text.orEmpty,
                                         passwordTextFieldText: passwordTextField.rx.text.orEmpty,
                                         signInButtonTap: signInButton.rx.tap)

        let output = viewModel.transform(input: input)

        output.validLogin
            .bind(with: self) { owner, _ in
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let rootVC = TabBarViewController()
                sceneDelegate?.window?.rootViewController = rootVC
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
    }

}
