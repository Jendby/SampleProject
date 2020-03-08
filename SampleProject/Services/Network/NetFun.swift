//
//  NetFun.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

final class NetFun {
    internal let netmanager: NetManagerService
    init(netmanager: NetManagerService) {
        self.netmanager = netmanager
    }

    // MARK: - Internal functions

    /// function get
    /// sends GET message without parameters
    /// T could be Array of JSONs or just a NSDictionary out of a single JSON
    internal func get<T>(url: String,
                         success: @escaping ((T) -> Void),
                         failure: @escaping ((NSError) -> Void)) {
        put { [weak self] in
            self?.netmanager.getQuery(url: url,
                                      params: nil,
                                      success: { (ans: T) in
                                        self?.s(ans, success)
                                        self?.executeNext()
            }, failure: { e in
                self?.f(e, failure)
                self?.executeNext()
            })
        }
    }

    /// function get
    /// sends GET message with parameters
    /// T could be Array of JSONs or just a NSDictionary out of a single JSON
    internal func getWithParams<T>(url: String,
                                   params: [String: Any]?,
                                   success: @escaping ((T) -> Void),
                                   failure: @escaping ((NSError) -> Void)) {
        put { [weak self] in
            self?.netmanager.getCustomURLQuery(url: url,
                                               params: params,
                                               success: {(ans: T) in
                                                   self?.s(ans, success)
                                                   self?.executeNext()
            }, failure: { e in
                self?.f(e, failure)
                self?.executeNext()
            })
        }
    }

    /// function post
    /// sends usual POST message with data as input
    /// T could be Array of JSONs or just a NSDictionary out of a single JSON
    internal func post<T>(url: String,
                          data: Data,
                          success: ((T) -> Void)?,
                          failure: ((NSError) -> Void)?) {
        put { [weak self] in
            self?.netmanager.postQuery(url: url,
                                       data: data,
                                       success: { (ans: T) in
                                        self?.s(ans, success)
                                        self?.executeNext()
            }, failure: { e in
                self?.f(e, failure)
                self?.executeNext()
            })
        }
    }

    /// function post
    /// sends POST message in form-data format
    internal func xpost<T>(url: String,
                           parameters: [String: Any],
                           success: ((T) -> Void)?,
                           failure: ((NSError) -> Void)?) {
        put { [weak self] in
            self?.netmanager.xpostQuery(url: url,
                                        parameters: parameters,
                                        success: { (ans: T) in
                                            self?.s(ans, success)
                                            self?.executeNext()
            }, failure: { e in
                self?.f(e, failure)
                self?.executeNext()
            })
        }
    }

    // sends GET query in form-data format
    internal func xget<T>(url: String,
                          success: ((T) -> Void)?,
                          failure: ((NSError) -> Void)?) {
        put { [weak self] in
            self?.netmanager.xgetQuery(url: url,
                                       success: { (ans: T) in
                                        self?.s(ans, success)
                                        self?.executeNext()
            }, failure: { e in
                self?.f(e, failure)
                self?.executeNext()
            })
        }
    }

    // MARK: - Private

    private func put(_ op: @escaping (() -> Void)) {
        lock.lock()
        operations.append(op)
        lock.unlock()
        executeNext()
    }

    private func s<T>(_ ans: T, _ success: ((T) -> Void)?) {
        DispatchQueue.main.async {
            success?(ans)
        }
    }

    private func f(_ err: NSError, _ failure: ((NSError) -> Void)?) {
        DispatchQueue.main.async {
            failure?(err)
        }
    }

    internal func errHandler(_ failure: ((NSError) -> Void)?) -> ((NSError) -> Void) {
        return { e in
            DispatchQueue.main.async {
                failure?(e)
            }
        }
    }

    private func executeNext() {
        queue.addOperation { [weak self] in
            let opp: (() -> Void)?
            self?.lock.lock()
            opp = self?.operations.popLast()
            self?.lock.unlock()
            if let op = opp {
                op()
            }
        }
    }

    private lazy var queue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "NetFun Queue"
        queue.qualityOfService = .userInitiated
        return queue
    }()
    private lazy var operations = [() -> Void]()
    internal var user = ""
    private let lock = NSLock()
}
