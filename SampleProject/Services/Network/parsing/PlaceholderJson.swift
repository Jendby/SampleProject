//
//  PlaceholderJson.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation

func parseJsonPlaceholder(from dd: [NSDictionary]) -> [PostFromJsonPlaceholder] {
    var out = [PostFromJsonPlaceholder]()
    for item in dd {
        out.append(parseSingleJsonPlaceholder(from: item))
    }
    return out
}

private func parseSingleJsonPlaceholder(from d:NSDictionary) -> PostFromJsonPlaceholder {
    let userId = parseInt(d, key: "userId")
    let id = parseInt(d, key: "id")
    let title = parseString(d, for: "title")
    let body = parseString(d, for: "body")
    return PostFromJsonPlaceholder(userId: userId,
                                   id: id,
                                   title: title,
                                   body: body)
}
