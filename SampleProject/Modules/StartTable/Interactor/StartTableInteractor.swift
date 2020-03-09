//
//  StartTableInteractor.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit

final class StartTableInteractor {
    weak var output: StartTableInteractorOutput?
    private let netPlaceholder: NetPlaceholderJSON
    
    init(netPlaceholder: NetPlaceholderJSON){
        self.netPlaceholder = netPlaceholder
    }
}

// MARK: - StartTableInteractorInput
extension StartTableInteractor: StartTableInteractorInput  {
    func loadModels(with theme: Theme) {
        netPlaceholder.searchPosts(
            success: { [weak self] (ans: [PostFromJsonPlaceholder]) in
                guard let `self` = self else { return }
                var mm = [StartTableModel]()
                for item in ans {
                    mm.append(StartTableModel(id: "\(item.id)",
                        about: item.title,
                        body: item.body,
                        theme: theme))
                }
                self.output?.fetched(models: mm)
            }, failure: { [weak self] e in
                self?.output?.handle(err: e)
                print("ee")
        })
    }
}

