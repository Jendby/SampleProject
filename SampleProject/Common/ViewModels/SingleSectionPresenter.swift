//
//  SingleSectionPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

protocol SingleSectionInteractorInput: class {
    func loadModels(with theme: Theme)
}

protocol SingleSectionInteractorOutput: class {
    func fetched(models: [CellAnyModel])
}

open class SingleSectionPresenter:
   CommonViewModel,
   SingleSectionInteractorOutput {
    // data source
    weak var source: SingleSectionInteractorInput?

    // MARK: SingleSectionInteractorOutput

    func fetched(models: [CellAnyModel]) {
        self.models = models
        busy.accept(false)
        updateData.accept(true)
    }

    // MARK: CommonViewModel

    func getContents() {
        if busy.value || source == nil { return }
        busy.accept(true)
        source?.loadModels(with: theme)
    }

    func refreshContents() {
        getContents()
    }

    func selected(indexPath: IndexPath) {
    }

    func model(for indexPath: IndexPath) -> Any {
        if indexPath.row < models.count {
            return models[indexPath.row]
        }
        // shouldn't happen, but shit always pops up:
        return EmptyTableModel()
    }

    func modelsCount(for section: Int) -> Int {
        return models.count
    }

    func title(for section: Int) -> String {
        return ""
    }

    func sectionsCount() -> Int {
        return 1
    }

    // MARK: useful functions
    internal func findModelWith(id: String) -> (CellAnyModel?, Int) {
        for (i, m) in models.enumerated() {
            if m.id == id {
                return (m, i)
            }
        }
        return (nil, -1)
    }

    // MARK: members of CommonViewModel protocol
    var theme: Theme! {
        didSet {
//            getContents()
        }
    }
    var updateItems = BehaviorRelay<IIndexPathCount?> (value: nil)
    var updateData = BehaviorRelay<Bool> (value: false)
    var scrollTo = BehaviorRelay<IMovePath?> (value: nil)
    var removeKeyboard = BehaviorRelay<Bool> (value: false)
    var busy = BehaviorRelay<Bool> (value: false)


    // MARK: other members
    internal var models = [CellAnyModel]()
}

