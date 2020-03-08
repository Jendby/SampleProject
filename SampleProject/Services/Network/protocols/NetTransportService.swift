//
//  NetTransport.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

protocol NetTransportService {
    // GET
    func getQuery<T>(url: String,
                     params: [String: Any]?,
                     success: ((T) -> Void)?,
                     failure: ((NSError) -> Void)?)

    func getCustomURLQuery<T>(url: String,
                              params: [String: Any]?,
                              success: ((T) -> Void)?,
                              failure: ((NSError) -> Void)?)
    // GET-raw (e.g. for loading images)
    func getRawQuery(url: String,
                     success: ((Data) -> Void)?,
                     failure: ((NSError) -> Void)?)

    // POST query as json
    func postQuery<T>(url: String,
                      data: Data,
                      success: ((T) -> Void)?,
                      failure: ((NSError) -> Void)?)

    // GET as form-data
    func xgetQuery<T>(url: String,
                      success: ((T) -> Void)?,
                      failure: ((NSError) -> Void)?)

    // POST as form-data
    func xpostQuery<T>(url: String,
                       parameters: [String:Any],
                       success: ((T) -> Void)?,
                       failure: ((NSError) -> Void)?)
}
