//
//  NetworkConfig.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

struct NetworkConfig {
    var baseUrl: String
    var prefix: String
    var baseNeuroUrl: String
    var clientId: String
    var clientSecret: String

    init() {
        self.baseUrl = ""
        self.baseNeuroUrl = ""
        self.prefix = ""
        self.clientId = ""
        self.clientSecret = ""
    }

    static func getConfiguration(name: String) -> NetworkConfig {
        var out = NetworkConfig()
        guard let plistPath = Bundle.main.path(forResource: name, ofType: "plist") else {
            return out
        }
        let dict = NSDictionary(contentsOfFile: plistPath)!
        if let baseUrl = dict["server_base_url"] as? String {
            out.baseUrl = baseUrl
        }
        if let baseNUrl = dict["server_neuro_base_url"] as? String {
            out.baseNeuroUrl = baseNUrl
        }
        if let vprefix = dict["server_base_path"] as? String {
            out.prefix = vprefix
        }
        if let clientId = dict["client_id"] as? String {
            out.clientId = clientId
        }
        if let clientSecret = dict["client_secret"] as? String {
            out.clientSecret = clientSecret
        }
        return out
    }
}
