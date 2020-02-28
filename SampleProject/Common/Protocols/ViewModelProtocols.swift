//
//  ViewModelProtocols.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit
import RxCocoa

protocol CommonViewModel {
    var theme: Theme! { get set }
    var updateItems: BehaviorRelay<IIndexPathCount?> { get }
    var updateData: BehaviorRelay<Bool> { get }
    var scrollTo: BehaviorRelay<IMovePath?> { get }
    var busy: BehaviorRelay<Bool> { get }
    var removeKeyboard: BehaviorRelay<Bool> { get }
    func getContents()
    func refreshContents()
    func selected(indexPath: IndexPath)
    func model(for indexPath: IndexPath) -> Any
    func modelsCount(for section: Int) -> Int
    func title(for section: Int) -> String
    func sectionsCount() -> Int
}

protocol SearchableViewModel {
    func searchFor(text: String)
}
