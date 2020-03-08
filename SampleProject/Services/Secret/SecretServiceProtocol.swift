//
//  SecretService.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

protocol SecretServiceProtocol {
    /// is it a social authorization?
    var isSocialAuth: Bool { get set }
    /// what kind of social network provider do we use?
    var socialAuthType: String { get set }
    /// social network access token
    var socialAuthToken: String { get set }
    /// social auth extra data (for every type could be different)
    var socialAuthExtra: NSDictionary { get set }
    /// social data expire date
    var socialAuthExpire: Date? { get set }

    /// means user is through security (like placed his finger on touch id, or entered his/her PIN)
    var authorized: Bool { get }
    /// means user entered his/her credentials
    var isAuthCreated: Bool { get set }
    /// current session id (like a token from oauth2)
    var session: String { get set }
    /// current refresh session id (like a refresh token from oauth2)
    var restore: String { get set }
    /// user's login
    var login: String { get set }
    /// user's password
    var password: String { get set }
    /// pushes id
    var uid: String { get set }
    /// current user's id (fetched from network if needed but once)
    var currentUserId: Int { get set }
    /// removes all saved data about user's credentials
    func erase()
}
