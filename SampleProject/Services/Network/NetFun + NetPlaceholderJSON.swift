//
//  NetFun + NetPlaceholderJSON.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

extension NetFun: NetPlaceholderJSON {
    func searchPosts(success: (([PostFromJsonPlaceholder]) -> Void)?,
                     failure: ((NSError) -> Void)?) {
        getWithParams(url: "https://jsonplaceholder.typicode.com/posts",
                      params: nil,
                      success: { (ans: [NSDictionary]) in
                        let res = parseJsonPlaceholder(from: ans)
                        success?(res)
        },
                      failure: { e in
                        failure?(e)
        })

    }
}
