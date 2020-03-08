//
//  NetAuthService.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

protocol NetAuthService {
    func socialAuth(type: String,
                    token: String,
                    success: ((NSDictionary) -> Void)?,
                    failure: ((NSError) -> Void)?)
    func auth(login: String,
              password: String,
              success: ((NSDictionary) -> Void)?,
              failure: ((NSError) -> Void)?)
    func logout(success: (() -> Void)?,
                failure: ((NSError) -> Void)?)
}
