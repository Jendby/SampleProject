//
//  MobileNetTransportService.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 07/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation
import Alamofire

protocol MobileNetTransportService: NetTransportService {
    var sessionManager: SessionManager { get }
    func commonParsingResponse(_ response: DataResponse<Any>,
                               success: ([NSDictionary]) -> Void,
                               failure: ((NSError) -> Void)?)
}
