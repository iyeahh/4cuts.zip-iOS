//
//  NetworkRequestInterceptor.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/31/24.
//

import Foundation
import Alamofire

final class NetworkRequestInterceptor: RequestInterceptor {

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {

        var urlRequest = urlRequest
        urlRequest.setValue(Header.json.rawValue, forHTTPHeaderField: Header.contentType.rawValue)
        urlRequest.setValue(APIKey.sesacKey, forHTTPHeaderField: Header.sesacKey.rawValue)
        urlRequest.setValue(UserDefaultsManager.token, forHTTPHeaderField: Header.authorization.rawValue)

        completion(.success(urlRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
            completion(.doNotRetryWithError(error))
            return
        }

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
                            completion(.retry)
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
