//
//  NetManager.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation
import Alamofire

final class NetManager: NetManagerService {
    private let transport: MobileNetTransport
    private let cfg: NetworkConfig
    private let authHandler: AuthHandler
    private let sessionManager: SessionManager

    init(cfg: NetworkConfig,
         secret: SecretServiceProtocol,
         transport: MobileNetTransport) {
        self.cfg = cfg
        self.transport = transport
        self.sessionManager = transport.sessionManager
        self.authHandler = AuthHandler(transport: transport,
                                       secret: secret,
                                       cfg: cfg)
        base = cfg.baseUrl + cfg.prefix
        sessionManager.adapter = authHandler
        sessionManager.retrier = authHandler
    }

    func auth(login: String,
              password: String,
              success: ((NSDictionary) -> Void)?,
              failure: ((NSError) -> Void)?) {
        authHandler.auth(login: login, password: password) { (ok, err) in
            if let e = err {
                failure?(e)
            } else {
                success?(ok ?? NSDictionary())
            }
        }
    }

    func socialAuth(type: String,
                    token: String,
                    success: ((NSDictionary) -> Void)?,
                    failure: ((NSError) -> Void)?) {
        authHandler.socialAuth(type: type, token: token) { (ok, err) in
            if let e = err {
                failure?(e)
            } else {
                success?(ok ?? NSDictionary())
            }
        }
    }

//    func register(user: User, completion: @escaping ((NSDictionary?, NSError?) -> Void)) {
//        authHandler.register(user: user, completion: completion)
//    }

    func logout(success: (() -> Void)?, failure: ((NSError) -> Void)?) {
        // TODO: add me
    }

    func getQuery<T>(url: String, params: [String : Any]?, success: ((T) -> Void)?, failure: ((NSError) -> Void)?) {
        transport.getQuery(url: base + url, params: params, success: success, failure: failure)
    }
    
    func getCustomURLQuery<T>(url: String, params: [String : Any]?, success: ((T) -> Void)?, failure: ((NSError) -> Void)?) {
        transport.getCustomURLQuery(url: url, params: params, success: success, failure: failure)
    }

    func getRawQuery(url: String, success: ((Data) -> Void)?, failure: ((NSError) -> Void)?) {
        transport.getRawQuery(url: cfg.baseUrl + url, success: success, failure: failure)
    }

    func postQuery<T>(url: String, data: Data, success: ((T) -> Void)?, failure: ((NSError) -> Void)?) {
        transport.postQuery(url: base + url, data: data, success: success, failure: failure)
    }

    func xgetQuery<T>(url: String, success: ((T) -> Void)?, failure: ((NSError) -> Void)?) {
        transport.xgetQuery(url: base + url, success: success, failure: failure)
    }

    func xpostQuery<T>(url: String, parameters: [String : Any], success: ((T) -> Void)?, failure: ((NSError) -> Void)?) {
        transport.xpostQuery(url: base + url, parameters: parameters, success: success, failure: failure)
    }

    private let base: String
}
