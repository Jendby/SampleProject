//
//  NetPlaceholderJSON.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 08/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//
import Foundation

protocol NetPlaceholderJSON {
    func searchPosts(success: (([PostFromJsonPlaceholder]) -> Void)?,
                     failure: ((NSError) -> Void)?)
}
