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

final class NetworkManager: RequestInterceptor {

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

            AF.request(request, interceptor: NetworkRequestInterceptor())
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
        .retry(3)
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

                AF.request(request, interceptor: NetworkRequestInterceptor())
                    .responseDecodable(of: PostContentModel.self) { response in
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
        .retry(3)
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

}
