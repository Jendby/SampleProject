//
//  AuthHandler.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation
import Alamofire

final class AuthHandler: RequestRetrier {
    init(transport: MobileNetTransportService,
         secret: SecretServiceProtocol,
         cfg: NetworkConfig) {
        self.transport = transport
        self.secret = secret
        self.cfg = cfg
        self.base = cfg.baseUrl + cfg.prefix

        refreshToken = ""
    }

    // MARK: authorization part
    private func handleAuthWith(result: NSDictionary?,
                                error: NSError?,
                                completion: @escaping ((NSDictionary?, NSError?) -> Void)) {
        if let json = result {
            if let (_, _) = self.extractTokensFrom(json) {
                self.authErrors = 0
                completion(json, nil)
            }
            else {
                self.handleProblemsIn(json, completion: completion)
            }
            return
        }
        if let e = error {
            self.secret.erase()
            completion(nil, e)
        }
    }

//    func register(user: User,
//                  completion: @escaping ((NSDictionary?, NSError?) -> Void)) {
//        let reg = RegisterInfo(type: "password",
//                               scope: "*",
//                               name: user.login,
//                               email: user.email,
//                               password: user.password,
//                               clientId: cfg.clientId,
//                               clientSecret: cfg.clientSecret)
//        let d = try! JSONEncoder().encode(reg)
//        transport.postQuery(url: base + "/register", data: d,
//                            success: { [unowned self] (ans: NSDictionary) in
//            self.handleAuthWith(result: ans, error: nil,
//                                completion: { (res, err) in
//				if let e = err {
//					completion(nil, e)
//				} else {
//                	self.secret.login = user.login
//                	self.secret.password = user.password
//                	self.secret.isAuthCreated = true
//					completion(res, nil)
//				}
//            })
//        }, failure: { e in
//            completion(nil, e)
//        })
//    }

    func auth(login: String,
              password: String,
              completion: @escaping ((NSDictionary?, NSError?) -> Void)) {
        secret.login = login
        secret.password = password
        auth(refresh: false) { [unowned self] (res, err) in
            self.handleAuthWith(result: res, error: err,
                                completion: completion)
        }
    }

    func socialAuth(type: String,
                    token: String,
                    completion: @escaping ((NSDictionary?, NSError?) -> Void)) {
        secret.isSocialAuth = true
        secret.socialAuthType = type
        secret.socialAuthToken = token
        auth(refresh: false) { [unowned self] (res, err) in
            self.handleAuthWith(result: res, error: err,
                                completion: completion)
        }
    }


    // MARK: RequestRetrier

    func should(_ manager: SessionManager,
                retry request: Request,
                with error: Error,
                completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }

        if let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401 {
            secret.currentUserId = -1 // reset user-id (maybe we've switched the accounts who knows?)
            requestsToRetry.append(completion)

            if !isRefreshing {
                refreshTokens { [unowned self] succeeded, accessToken, refreshToken in
                    self.lock.lock() ; defer { self.lock.unlock() }
                    // notify all requests about success of the operation:
                    self.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    self.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }

    // MARK: - Private

    private func auth(refresh: Bool, result: @escaping ((NSDictionary?, NSError?) -> Void)) {
        let d: Data
//        if secret.isSocialAuth {
//            let s = SocialAuthInfo(provider: secret.socialAuthType,
//                                   token: secret.socialAuthToken,
//                                   clientId: cfg.clientId,
//                                   clientSecret: cfg.clientSecret)
//            var v = s.dictionary ?? [String: Any]()
//            v["extra"] = secret.socialAuthExtra
//            d = (v as NSDictionary).toJSONString()?.data(using: .utf8) ?? Data()
//        } else {
//            let a = AuthTokenInfo(type: refresh ? "refresh_token" : "password",
//                                  scope: "*",
//                                  username: secret.login,
//                                  password: secret.password,
//                                  accessToken: refresh ? secret.session : "",
//                                  refreshToken: refresh ? refreshToken : "",
//                                  clientId: cfg.clientId,
//                                  clientSecret: cfg.clientSecret)
//            d = try! JSONEncoder().encode(a)
//        }
//        transport.postQuery(url: base + "/auth/token", data: d,
//                            success: { [unowned self] (ans: NSDictionary) in
//            if let (_, _) = self.extractTokensFrom(ans) {
//                self.authErrors = 0
//				result(ans, nil)
//			} else {
//				self.handleProblemsIn(ans, completion: result)
//			}
//        }, failure: { err in
//            result(nil, err)
//        })
    }

    private func extractTokensFrom(_ json: NSDictionary) -> (String, String)? {
        if let accessToken = json["access_token"] as? String,
            let refreshToken = json["refresh_token"] as? String
        {
            secret.session = accessToken
            self.refreshToken = refreshToken
            return (accessToken, refreshToken)
        }
        return nil
    }

    private func refreshTokens(completion: @escaping RefreshCompletion) {
        lock.lock() ; defer { lock.unlock() }
        guard !isRefreshing else { return }

        isRefreshing = true
        auth(refresh: true) { [unowned self] (res, err) in
            self.lock.lock() ; defer { self.lock.unlock() }
            if let json = res,
                let (accessToken, refreshToken) = self.extractTokensFrom(json),
                accessToken.count > 0 {
                self.isRefreshing = false
                completion(true, accessToken, refreshToken)
            } else {
                self.auth(login: self.secret.login,
                          password: self.secret.password) { json, err in
                            self.lock.lock() ; defer { self.lock.unlock() }
                            self.isRefreshing = false
                            if let e = err {
                                print("!!error in re/auth: \(e.localizedDescription)")
                                completion(false, nil, nil)
                            } else {
                                self.authErrors = 0
                                completion(true, nil, nil)
                            }
                }
            }
        }
    }

    private func determineErrCode() -> Int {
        let code: Int
        lock.lock() ; defer { lock.unlock() }
        authErrors += 1
        if authErrors > const.maxErr {
            // we need a deauth
            code = Const.err.kNetAuth
            authErrors = 0
            secret.erase()
        } else {
            code = Const.err.kNet
        }
        return code
    }

    private func handleProblemsIn(_ json: NSDictionary,
                                  completion: @escaping ((NSDictionary?, NSError?) -> Void)) {
        let descr: String
        if let description = json["message"] as? String {
            descr = description
        }
        else {
            descr = "Network Auth Problems".localized
        }
        let error = NSError(domain: Const.domain,
                            code: determineErrCode(),
                            userInfo: [NSLocalizedDescriptionKey: descr])
        completion(nil, error)
    }

    private typealias RefreshCompletion =
        (_ succeeded: Bool,
        _ accessToken: String?,
        _ refreshToken: String?) -> Void
    private let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders

        return SessionManager(configuration: configuration)
    }()

    private let lock = NSRecursiveLock()

    private let transport: MobileNetTransportService
    private let base: String
    private let cfg: NetworkConfig
    private var secret: SecretServiceProtocol

    private var refreshToken: String

    private var authErrors = 0
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []

    private struct const {
        static let maxErr = 4
    }
}

extension AuthHandler: RequestAdapter {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(cfg.baseUrl) {
            var urlRequest = urlRequest
            if secret.session.count > 0 {
                urlRequest.setValue("Bearer " + secret.session,
                                    forHTTPHeaderField: "Authorization")
            }
            return urlRequest
        }
        return urlRequest
    }
}
