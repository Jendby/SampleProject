//
//  SingleImagePicker.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

protocol SingleImagePickerDelegate: class {
    func selected(image: UIImage)
}

final class SingleImagePicker: NSObject {
    lazy var imagePickerController: UIImagePickerController = {
        let controller = UIImagePickerController()
        controller.delegate = self
        return controller
    }()
    weak var delegate: SingleImagePickerDelegate? = nil
}

extension SingleImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            delegate?.selected(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
