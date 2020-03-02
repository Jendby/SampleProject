//
//  CameraViewPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraViewPresenter {

    weak var view: CameraViewViewInput!
    var interactor: CameraViewInteractorInput!
    var router: CameraViewRouterInput!
    var retained: UIViewController? = nil
    let camConnectService: CamConnectService
    private var videoTracked = false
    
    init(camConnectService: CamConnectService) {
        self.camConnectService = camConnectService
    }
    
    private func toggleVideoTracked() {
        videoTracked = !videoTracked
        if !videoTracked {
            stopTrackingMotion()
        }
        view.setVideobtn(videoTracked: videoTracked)
    }
    
    private func stopTrackingMotion() {
        camConnectService.stopCameraFor(delegate: self)
    }
}

// MARK: - CameraViewModuleInput
extension CameraViewPresenter: CameraViewModuleInput {
	func present(from viewController: UIViewController) {
        self.view.present(from: viewController)
        retained = nil
	}
}

// MARK: - CameraViewViewOutput
extension CameraViewPresenter: CameraViewViewOutput {
    func stopTracking() {
        stopTrackingMotion()
    }
    
    func viewIsReady() {
        view.setVideobtn(videoTracked: videoTracked)
    }
    
    func videoFromCameraAttached() {
        toggleVideoTracked()
        view.hideBusyIndicator()
    }

    func navBtnTapped() {
        if videoTracked {
            view.detachVideolayer()
            toggleVideoTracked()
        } else {
            if let err = camConnectService.startCameraFor(delegate: self) {
                view.show(error: err)
            } else {
                // try to initialize window for that in view:
                view.attachVideoLayer()
            }
        }
    }
}

// MARK: - CameraViewInteractorOutput
extension CameraViewPresenter: CameraViewInteractorOutput {
}

extension CameraViewPresenter: CamConnectServiceListener {
    var nameForImageFromCamera: String {
        return String(describing: self)
    }
    
    func changed(layer: AVCaptureVideoPreviewLayer?) {
        if let layer = layer{
            view.changedlayer(layer: layer)
        }
    }
}
