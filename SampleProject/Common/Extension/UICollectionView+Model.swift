//
//  UICollectionView+Model.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

extension UICollectionView {
    func dequeueReusableCell(withModel model: CellAnyModel,
                             for indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = String(describing: type(of: model).CellAnyType)
        let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        model.setupAny(cell: cell)
        return cell
    }

    func dequeueReusableSupplementaryView(ofKind kind: String,
                                          withModel model: CellAnyModel,
                                          for indexPath: IndexPath) -> UICollectionReusableView {
        let identifier = String(describing: type(of: model).CellAnyType)
        let cell = dequeueReusableSupplementaryView(ofKind: kind,
                                                    withReuseIdentifier: identifier,
                                                    for: indexPath)
        model.setupAny(cell: cell)
        return cell
    }
}
