//
//  NetworkManager.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import UIKit
import Alamofire
import RxSwift

enum NetworkError: Error {
    case invaildURL
    case unknownResponse
}

final class NetworkManager {
    
    static let shared = NetworkManager()

    private init() { }

    func createLogin(email: String, password: String) -> Single<Result<LoginModel, NetworkError>> {
        return Single.create { observer -> Disposable in
            var request: URLRequest

            do {
                let query = LoginQuery(email: email, password: password)
                request = try Router.login(query: query).asURLRequest()
            } catch {
                observer(.success(.failure(.invaildURL)))
                return Disposables.create()
            }

            AF.request(request)
                .responseDecodable(of: LoginModel.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure:
                        observer(.success(.failure(.unknownResponse)))
                    }
                }
            return Disposables.create()
        }
    }

    func fetchPostContent(category: PostCategory) -> Single<Result<PostContentModel, NetworkError>> {
        return Single.create { observer -> Disposable in
            var request: URLRequest

            do {
                request = try Router.fetchPostContent(category: category).asURLRequest()
            } catch {
                observer(.success(.failure(.invaildURL)))
                return Disposables.create()
            }

            AF.request(request)
                .responseDecodable(of: PostContentModel.self) { [weak self] response in
                    if response.response?.statusCode == 419 {
                        guard let self else { return }
                        print("리프레시 토큰 개시")
                        refreshToken()
                    }
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure:
                        observer(.success(.failure(.unknownResponse)))
                    }
                }
            return Disposables.create()
        }
    }

    func fetchShopping(query: String) -> Single<Result<ShoppingModel, NetworkError>> {
        return Single.create { observer -> Disposable in
            var request: URLRequest

            do {
                request = try Router.fetchShopping(query: query).asURLRequest()
            } catch {
                observer(.success(.failure(.invaildURL)))
                return Disposables.create()
            }

            AF.request(request)
                .responseDecodable(of: ShoppingModel.self) { [weak self] response in
                    if response.response?.statusCode == 419 {
                        guard let self else { return }
                        print("리프레시 토큰 개시")
                        refreshToken()
                    }
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure:
                        observer(.success(.failure(.unknownResponse)))
                    }
                }
            return Disposables.create()
        }
    }

    private func refreshToken() {
        do {
            let request = try Router.refresh.asURLRequest()

            AF.request(request)
                .responseDecodable(of: RefreshModel.self) { response in
                    if response.response?.statusCode == 418 {
                        print("리프레시 토큰 만료")
                        Coordinator.moveRoot(vc: LoginViewController())
                        UserDefaultsManager.removeAll()
                    } else {
                        switch response.result {
                        case .success(let success):
                            print("리프레시 토큰 성공")
                            UserDefaultsManager.token = success.accessToken
                            // fetchProfile()
                        case .failure:
                            print("리프레시 토큰 실패")
                        }
                    }
                }
        } catch {
            print("리프레시 토큰 invaildURL")
        }
    }

}
