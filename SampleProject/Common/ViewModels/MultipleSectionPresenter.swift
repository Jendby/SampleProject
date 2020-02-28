//
//  MultipleSectionPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

protocol MultipleSectionInteractorInput: class {
    func loadModels(with theme: Theme, section: Int)
}

protocol MultipleSectionInteractorOutput: class {
    func fetched(models: [CellAnyModel], section: Int)
}

open class MultipleSectionPresenter:
    CommonViewModel,
    MultipleSectionInteractorOutput {
    // data source
    weak var source: MultipleSectionInteractorInput?

    init(titles: [String]) {
        self.titles = titles
    }

    // MARK: MultipleSectionInteractorOutput

    func fetched(models: [CellAnyModel], section: Int) {
        self.models[section] = models
        updateData.accept(true)
    }

    // MARK: CommonViewModel

    func getContents() {
        for s in titles.indices {
            source?.loadModels(with: theme, section: s)
        }
    }

    func refreshContents() {
        models.removeAll()
        getContents()
    }

    func selected(indexPath: IndexPath) {
    }

    func model(for indexPath: IndexPath) -> Any {
        return (models[indexPath.section])![indexPath.row]
    }

    func modelsCount(for section: Int) -> Int {
        return (models[section])!.count
    }

    func title(for section: Int) -> String {
        return titles[section]
    }

    func sectionsCount() -> Int {
        return models.count
    }

    // MARK: useful functions
    internal func findModelWith(id: String) -> (CellAnyModel?, IndexPath?) {
        for (k, mm) in models {
            for (i, m) in mm.enumerated() {
                if m.id == id {
                    let ind = IndexPath(row: i, section: k)
                    return (m, ind)
                }
            }
        }
        return (nil, nil)
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
    internal var titles: [String]
    internal var models = [Int:[CellAnyModel]]()
}
