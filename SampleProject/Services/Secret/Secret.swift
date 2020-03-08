//
//  Secret.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

final class Secret: SecretServiceProtocol {
    let kAuthCreated = "auth_created"
    let kSession = "session"
    let kRestore = "restore-session"
    let kLogin = "phonenumber"
    let kPassword = "password"
    let kUID = "uid"
    let kUserId = "cur_user_id"
    let kAuthSocial = "auth_social_login"
    let kAuthSocialType = "auth_social_type"
    let kAuthSocialToken = "auth_social_access_token"
    let kAuthSocialTokenId = "auth_social_token_id"
    let kAuthSocialExpire = "auth_social_expire"
    let defaults: UserDefaults

    init() {
        defaults = UserDefaults.standard
    }

    func erase() {
        let ids = [
            kUserId,
            Const.keys.ownAvatar
        ]
        for k in ids {
            defaults.set(nil, forKey: k)
        }
        isAuthCreated = false
        isSocialAuth = false
        session = ""
        restore = ""
        login = ""
        password = ""
        socialAuthExtra = NSDictionary()
        uid = ""
        defaults.synchronize()
    }

    var authorized: Bool {
        get {
            return isAuthCreated
        }
    }

    var isAuthCreated: Bool {
        get {
            return getBool(for: kAuthCreated)
        }
        set {
            save(value: newValue, for: kAuthCreated)
        }
    }

    var isSocialAuth: Bool {
        get {
            return getBool(for: kAuthSocial)
        }
        set {
            save(value: newValue, for: kAuthSocial)
        }
    }

    // MARK: social networks stuff

    var socialAuthType: String {
        get {
            return getString(for: kAuthSocialType)
        }
        set {
            save(value: newValue, for: kAuthSocialType)
        }
    }
    var socialAuthExtra: NSDictionary {
        get {
            return getDict(for: kAuthSocialTokenId)
        }
        set {
            save(value: newValue, for: kAuthSocialTokenId)
        }
    }
    var socialAuthToken: String {
        get {
            return getString(for: kAuthSocialToken)
        }
        set {
            save(value: newValue, for: kAuthSocialToken)
        }
    }
    var socialAuthExpire: Date? {
        get {
            return defaults.object(forKey: kAuthSocialExpire) as? Date
        }
        set {
            save(value: newValue, for: kAuthSocialExpire)
        }
    }

    // MARK: session and stuff

    var session: String {
        get {
            return getString(for: kSession)
        }
        set {
            save(value: newValue, for: kSession)
        }
    }
    var restore: String {
        get {
            return getString(for: kRestore)
        }
        set {
            save(value: newValue, for: kRestore)
        }
    }
    var login: String {
        get {
            return getString(for: kLogin)
        }
        set {
            save(value: newValue, for: kLogin)
        }
    }
    var password: String {
        get {
            return getString(for: kPassword)
        }
        set {
            save(value: newValue, for: kPassword)
        }
    }
    var uid: String {
        get {
            if let s = defaults.object(forKey: kUID) as? String {
                return s
            } else {
                return "X-X-X"
            }
        }
        set {
            defaults.set(newValue, forKey: kUID)
            defaults.synchronize()
        }
    }
    var currentUserId: Int {
        get {
            let uid: Int? = getValue(for: kUserId)
            if let id = uid {
                return id
            }
            return -1
        }
        set {
            save(value: newValue, for: kUserId)
        }
    }

    // MARK: - Private
    private func getValue<T>(for key: String) -> T? {
        if let v = defaults.object(forKey: key) as? T {
            return v
        }
        return nil
    }

    private func save<T>(value: T, for key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }

    private func getBool(for key: String) -> Bool {
        let b: Bool? = getValue(for: key)
        return b ?? false
    }

    private func getString(for key: String) -> String {
        let s: String? = getValue(for: key)
        return s ?? ""
    }

    private func getDict(for key: String) -> NSDictionary {
        let d: NSDictionary? = getValue(for: key)
        return d ?? NSDictionary()
    }
}
