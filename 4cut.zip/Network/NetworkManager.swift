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

    func callRequest<T: Decodable>(router: Router) -> Single<Result<T, NetworkError>> {
        return Single.create { observer -> Disposable in
            var request: URLRequest

            do {
                request = try router.asURLRequest()
            } catch {
                observer(.success(.failure(.invaildURL)))
                return Disposables.create()
            }

            AF.request(request)
                .responseDecodable(of: T.self) { response in
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

    func postCallRequestWithoutToken<T: Decodable>(router: Router) -> Single<Result<T, NetworkError>> {
        return Single.create { observer -> Disposable in
            var request: URLRequest

            do {
                request = try router.asURLRequest()
            } catch {
                observer(.success(.failure(.invaildURL)))
                return Disposables.create()
            }

            AF.request(request)
                .responseDecodable(of: T.self) { response in
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

    func callRequestWithToken<T: Decodable>(router: Router) -> Single<Result<T, NetworkError>>  {
        return Single.create { observer -> Disposable in
            var request: URLRequest

            do {
                request = try router.asURLRequest()
            } catch {
                observer(.success(.failure(.invaildURL)))
                return Disposables.create()
            }

            AF.request(request)
                .responseDecodable(of: T.self) { [weak self] response in
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

    func fetchShopping(query: [ShoppingCategory]) -> Single<Result<[[PostContent]], NetworkError>> {
        return Single.create { observer -> Disposable in

            let group = DispatchGroup()
            var shoppingList: [[PostContent]] = []

            query.forEach { category in

                group.enter()
                var request: URLRequest

                do {
                    request = try Router.fetchShopping(query: category.query).asURLRequest()
                } catch {
                    observer(.success(.failure(.invaildURL)))
                    return ()
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
                            shoppingList.append(value.data)
                            group.leave()
                        case .failure:
                            observer(.success(.failure(.unknownResponse)))
                            group.leave()
                        }
                    }
            }

            group.notify(queue: .main) {
                observer(.success(.success(shoppingList)))
            }

            return Disposables.create()
        }
    }

    func validPayment(impUid: String, postId: String, completion: @escaping (Result<PaymentModel, NetworkError>) -> Void) {

        var request: URLRequest

        do {
            let query = PaymentValidation(imp_uid: impUid, post_id: postId)
            request = try Router.validPay(query: query).asURLRequest()
        } catch {
            completion(.failure(.invaildURL))
            return
        }

        AF.request(request)
            .responseDecodable(of: PaymentModel.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure:
                    completion(.failure(.unknownResponse))
                }
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
