//
//  NetFun+Auth.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

extension NetFun: NetAuthService {
    func auth(login: String,
              password: String,
              success: ((NSDictionary) -> Void)?,
              failure: ((NSError) -> Void)?) {
        netmanager.auth(login: login,
                        password: password,
                        success: success,
                        failure: failure)
    }

    func socialAuth(type: String,
                    token: String,
                    success: ((NSDictionary) -> Void)?,
                    failure: ((NSError) -> Void)?) {
        netmanager.socialAuth(type: type,
                              token: token,
                              success: success,
                              failure: failure)
    }

    func logout(success: (() -> Void)?,
                failure: ((NSError) -> Void)?) {
        netmanager.logout(success: success, failure: failure)
    }
}
