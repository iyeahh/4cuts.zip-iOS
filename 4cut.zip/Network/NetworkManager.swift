//
//  NetworkManager.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation
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
                .validate(statusCode: 200..<300)
                .responseDecodable(of: LoginModel.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(.success(value)))
                    case .failure(let error):
                        observer(.success(.failure(.unknownResponse)))
                    }
                }
            return Disposables.create()
        }
    }

}
