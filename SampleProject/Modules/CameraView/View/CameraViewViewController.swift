//
//  CameraViewViewController.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraViewViewController: BaseViewController {
    var output: CameraViewViewOutput!
    private weak var videoLayer: AVCaptureVideoPreviewLayer? = nil
    private var camView: UIView? = nil
    var rItem:UIBarButtonItem!
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        rItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(change))
        navigationItem.rightBarButtonItem = rItem
        output.viewIsReady()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if camView != nil && videoLayer != nil{
            videoLayer!.frame = camView!.bounds
        }
    }
    
    @objc func change() {
        output.navBtnTapped()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.stopTracking()
    }
}


// MARK: - CameraViewViewInput
extension CameraViewViewController: CameraViewViewInput {
    func changedlayer(layer: AVCaptureVideoPreviewLayer) {
        videoLayer = layer
    }
    
    func attachVideoLayer() {
        detachVideolayer()
        if let videoLayer = videoLayer {
            let backView = UIView()
            backView.backgroundColor = .red
            backView.translatesAutoresizingMaskIntoConstraints = false
            videoLayer.videoGravity = .resizeAspectFill
            self.view.addSubview(backView)
            self.view.addConstraints(
                [backView.topAnchor.constraint(equalTo: self.view.topAnchor),
                 backView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                 backView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                 backView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            backView.layer.addSublayer(videoLayer)
            camView = backView
            output.videoFromCameraAttached()
        }
    }
    
    func detachVideolayer() {
        if videoLayer != nil {
            camView?.removeFromSuperview()
        }
    }
    
    func setVideobtn(videoTracked: Bool) {
        if videoTracked {
            rItem.title = "Disable camera".localized
        } else {
            rItem.title = "Enable camera".localized
        }
    }
    
    func setupInitialState() {
    }
}
