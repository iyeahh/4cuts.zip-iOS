//
//  NetworkManager.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()

    private init() { }

    func createLogin(email: String, password: String) {
            do {
                let query = LoginQuery(email: email, password: password)
                let request = try Router.login(query: query).asURLRequest()

                AF.request(request)
                .responseDecodable(of: LoginModel.self) { response in
                    switch response.result {
                    case .success(let success):
                        print("Login OK", success)
                        UserDefaultsManager.token = success.access
                        UserDefaultsManager.refreshToken = success.refresh
                    case .failure(let failure):
                        print("Login Fail", failure)
                    }
                }
            } catch {
                print(error)
            }
        }

}
