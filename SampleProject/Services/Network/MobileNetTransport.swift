//
//  MobileNetTransport.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import UIKit
import Alamofire

final class MobileNetTransport {
    let sessionManager: SessionManager
    private let kTimeout: TimeInterval = 30
    private let secret: SecretServiceProtocol

    init(config: NetworkConfig, secret: SecretServiceProtocol) {
        cfg = config
        self.secret = secret
        sessionManager = SessionManager()
        let s = ProcessInfo().operatingSystemVersion
        osVersion = "\(s.majorVersion).\(s.minorVersion).\(s.patchVersion)"
        appVersion = applicationVersion()
    }

    // MARK: - Private

    private func getCommonQuery<T>(url: String,
                                   params: Parameters?,
                                   success: ((T) -> Void)?,
                                   failure: ((NSError) -> Void)?) {
        // .validate()
        sessionManager.request(url,
                               method: .get,
                               parameters: params,
                               encoding: URLEncoding.queryString,
                               headers: nil)
            .responseJSON { [unowned self] response in
                self.commonParsingResponse(response, success: { json in
                    if let s = success as? ((Array<Any>) -> Void)? {
                        s?(json)
                    } else if let s = success as? ((NSDictionary) -> Void)? {
                        s?(json[0])
                    }
                }, failure: failure)
        }
    }

    private func getCustomQuery<T>(url: String,
                                params: Parameters?,
                                success: ((T) -> Void)?,
                                failure: ((NSError) -> Void)?) {
        sessionManager.request(url,
                               method: .get,
                               parameters: params,
                               encoding: URLEncoding.queryString,
                               headers: nil)
            .responseJSON { (response) in
                self.commonParsingResponse(response, success: { json in
                    if let s = success as? ((Array<Any>) -> Void)? {
                        s?(json)
                    } else if let s = success as? ((NSDictionary) -> Void)? {
                        
                        s?(json[0])
                    } else if let s = success as? (([NSDictionary]) -> Void)? {
                        
                        s?(json)
                    }
                }, failure: failure)
        }
    }
    
    private func commonHeaders() -> [String: String] {
        var d = [String:String]()
        d["os"] = Const.os
        d["app-version"] = appVersion
        d["os-version"] = osVersion
        d["Accept"] = "application/json"
        return d
    }

    private func setCommonHeaders(to request: inout URLRequest) {
        let headers = commonHeaders()
        for (k, v) in headers {
            request.setValue(v, forHTTPHeaderField: k)
        }
    }

    private func postCommonQuery<T>(url: String,
                                    data: Data,
                                    success: ((T) -> Void)?,
                                    failure: ((NSError) -> Void)?) {
        let u = URL(string: url)!
        var request = URLRequest(url: u)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        setCommonHeaders(to: &request)
        request.httpBody = data
        request.timeoutInterval = kTimeout
        let upload = sessionManager.request(request)//.validate()
        upload.responseJSON { [unowned self] response in
            self.commonParsingResponse(response, success: { json in
                if let s = success as? ((Array<NSDictionary>) -> Void)? {
                    s?(json)
                } else {
                    if let s = success as? ((NSDictionary) -> Void)? {
                        if json.count > 0 {
                            s?(json[0])
                        } else {
                            s?([:])
                        }
                    }
                }
            }, failure: { [unowned self] err in
                if err.code == Const.err.kNetAuth && self.secret.isAuthCreated {
                    self.handleAuthProblemsOf(upload: upload, err: err) { error in
                        if let e = error {
                            failure?(e)
                        } else {
                            self.postCommonQuery(url: url,
                                                 data: data,
                                                 success: success,
                                                 failure: failure)
                        }
                    }
                } else {
                    failure?(err)
                }
            })
        }
    }

    private func xFormCommonQuery<T>(url: String,
                                     parameters: Parameters,
                                     success: ((T) -> Void)?,
                                     failure: ((NSError) -> Void)?) {
        var headers = commonHeaders()
        headers["Content-Type"] = "application/form-data"
        sessionManager.upload(multipartFormData: { multi in
            for (key, value) in parameters {
                if let d = value as? NSDictionary,
                    let type = d["type"] as? String {
                    if type.contains("image") {
                        if let im = d["data"] as? UIImage {
                            let data: Data
                            if type.contains("jpeg") {
                                let pq = parseDouble(d, key: "quality")
                                let q: CGFloat = pq > 0.01 ? CGFloat(pq) : 1
                                data = im.jpegData(compressionQuality: q) ?? Data()
                            } else { // png
                                data = im.pngData() ?? Data()
                            }
                            multi.append(data, withName: key, fileName: key, mimeType: type)
                        }
                    } else if type.contains("video") {
                        if let d = d["data"] as? Data {
                            multi.append(d, withName: key, fileName: key, mimeType: type)
                        }
                    }
                }
                else if let im = value as? UIImage, let data = im.jpegData(compressionQuality: 1) {
                    multi.append(data, withName: key, fileName: key, mimeType: "image/jpeg")
                } else {
                    multi.append("\(value)".data(using: String.Encoding.utf8) ?? Data(),
                                 withName: key)
                }
            }
        }, usingThreshold: 0,
           to: url,
           method: .post,
           headers: headers,
           queue: nil,
           encodingCompletion: { [unowned self] encoded in
            switch encoded {
            case .success(let upload, _, _):
                // validate().
                upload.responseJSON{ [unowned self] response in
                    self.commonParsingResponse(response, success: { json in
                        if let s = success as? ((Array<NSDictionary>) -> Void)? {
                            s?(json)
                        } else {
                            if let s = success as? ((NSDictionary) -> Void)? {
                                if json.count > 0 {
                                    s?(json[0])
                                } else {
                                    s?([:])
                                }
                            }
                        }
                    }, failure: { err in
                        if err.code == Const.err.kNetAuth {
                            self.handleAuthProblemsOf(upload: upload,
                                                      err: err) { error in
                                                        if let e = error {
                                                            failure?(e)
                                                        } else {
                                                            self.xFormCommonQuery(url: url,
                                                                                  parameters: parameters,
                                                                                  success: success,
                                                                                  failure: failure)
                                                        }
                            }
                        } else {
                            failure?(err)
                        }
                    })
                }
            case .failure(let err):
                failure?(err as NSError)
            }
        })
    }

    private func handleAuthProblemsOf(upload: Request,
                                      err: NSError,
                                      retryClosure: @escaping ((NSError?) -> Void)) {
        sessionManager.retrier?.should(self.sessionManager,
                                       retry: upload,
                                       with: err,
                                       completion: { (shouldRetry, timeDelay) in
                                        if shouldRetry {
                                            delay(timeDelay) {
                                                retryClosure(nil)
                                            }
                                        } else {
                                            retryClosure(err)
                                        }
        })
    }

    private func checkStatusCode(_ status: Int) -> NSError? {
        let error: NSError?
        switch (status) {
        case 200:
            error = nil
        case 401:
            error = NSError(domain: Const.domain,
                            code: Const.err.kNetAuth,
                            userInfo: [NSLocalizedDescriptionKey: "Authorization failure".localized])
        default:
            error = NSError(domain: Const.domain,
                            code: Const.err.kNet,
                            userInfo: [NSLocalizedDescriptionKey: "Network failure".localized])
        }
        return error
    }

    private func handle(failure: ((NSError) -> Void)?, descr: String) {
        if let f = failure {
            let error = NSError(domain: Const.domain,
                                code: Const.err.kNet,
                                userInfo: [NSLocalizedDescriptionKey: descr])
            f(error)
        }
    }

    private let cfg: NetworkConfig
    private let osVersion: String
    private let appVersion: String
}

extension MobileNetTransport: MobileNetTransportService {
    func getCustomURLQuery<T>(url: String,
                              params: [String : Any]?,
                              success: ((T) -> Void)?,
                              failure: ((NSError) -> Void)?) {
        getCustomQuery(url: url,
                       params: params,
                       success: success,
                       failure: failure)
    }
    
    func getRawQuery(url: String, success: ((Data) -> Void)?, failure: ((NSError) -> Void)?) {
        sessionManager.request(url).validate().responseData() { [unowned self] resp in
            if let response = resp.response {
                if let err = self.checkStatusCode(response.statusCode) {
                    failure?(err)
                } else {
                    if let d = resp.data {
                        if let s = success {
                            s(d)
                        }
                    } else {
                        self.handle(failure: failure,
                                    descr: "No Data was returned".localized)
                    }
                }
            }
            else {
                self.handle(failure: failure,
                            descr: "Network failure".localized)
            }
        }
    }

    func getQuery<T>(url: String,
                     params: [String: Any]?,
                     success: ((T) -> Void)?,
                     failure: ((NSError) -> Void)?) {
        getCommonQuery(url: url,
                       params: params,
                       success: success,
                       failure: failure)
    }

    func postQuery<T>(url: String,
                      data: Data,
                      success: ((T) -> Void)?,
                      failure: ((NSError) -> Void)?) {
        postCommonQuery(url: url,
                        data: data,
                        success: success,
                        failure: failure)
    }

    func xgetQuery<T>(url: String,
                      success: ((T) -> Void)?,
                      failure: ((NSError) -> Void)?) {
        getCommonQuery(url: url,
                       params: nil,
                       success: success,
                       failure: failure)
    }

    func xpostQuery<T>(url: String,
                       parameters: [String:Any],
                       success: ((T) -> Void)?,
                       failure: ((NSError) -> Void)?) {
        xFormCommonQuery(url: url,
                         parameters: parameters,
                         success: success,
                         failure: failure)
    }

    func commonParsingResponse(_ response: DataResponse<Any>,
                               success: ([NSDictionary]) -> Void,
                               failure: ((NSError) -> Void)?) {
        var headerError: NSError?
        if let c = response.response?.statusCode {
            headerError = checkStatusCode(c)
        }
        if let result = response.result.value {
            if let json = result as? NSDictionary {
                var err: NSError? = nil
                let unwrap = { (json: NSDictionary, field: String) -> [NSDictionary]? in
                    if let res = json[field] as? NSDictionary {
                        return [res]
                    } else if let res = json[field] as? [NSDictionary] {
                        return res
                    } else if json[field] != nil { // it's a concrete data type (like Bool, String etc)
                        return [json]
                    } else {
                        return nil
                    }
                }
                let data = unwrap(json, "success")
                let statusOk: Bool
				// do we have any hints about error execution?
                if data == nil || headerError != nil {
					statusOk = false
                    let code: Int
                    let errData = unwrap(json, "data")
                    var errCode = ""
                    if let c = json["error"] as? String {
                        errCode = c
                    }
                    let errDescription: String
                    var defDescr = ""
                    if let d = json["message"] as? NSDictionary {
                        errDescription = localizedDescriptionFrom(dict: d)
                        defDescr = defaultDescriptionFrom(dict: d)
                    } else if let d = json["message"] as? String {
                        errDescription = d
                        defDescr = d
                    } else {
                        if let hdr = headerError {
                            errDescription = hdr.localizedDescription
                        } else {
                            errDescription = "Error description isn't provided".localized
                        }
                    }
                    // package header's code have a priority
                    // over the body's error code:
                    if let hdr = headerError {
                        code = hdr.code
                    }
                    else if errCode.count > 0 {
                        switch errCode {
                            // describe all other codes if needed
                        default:
                            code = Const.err.kNet
                        }
                    } else {
                        if defDescr.contains("authorization") {
                            code = Const.err.kNetAuth
                        } else {
                            code = Const.err.kNet
                        }
                    }
                    err = NSError(domain: Const.domain,
                                  code: code,
                                  userInfo: [
                                    Const.err.fields.data: errData as Any,
                                    Const.err.fields.kindOfErr: errCode,
                                    Const.err.fields.defDescr: defDescr,
                                    NSLocalizedDescriptionKey: errDescription
                        ])
                } else {
                    statusOk = true
                }
                if statusOk {
                    if let d = data {
                        success(d)
                    } else { // try to parse it somewhere else:
                        success([json])
                    }
                } else {
                    if let e = err {
                        failure?(e)
                    } else {
                        handle(failure: failure, descr: "Cannot parse json".localized)
                    }
                }
            }
            else if let jsonAr = result as? Array<NSDictionary> {
                // array of results? it looks like all ok and it's a result of execution,
                // so no status and we have to pass it further:
                success(jsonAr)
            } else {
                handle(failure: failure, descr: "Cannot parse json".localized)
            }
        } else {
            if let hdr = headerError {
                failure?(hdr)
            } else {
                handle(failure: failure, descr: "No Network Connection".localized)
            }
        }
    }
}
