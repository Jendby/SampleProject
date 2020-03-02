//
//  CamConnect.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import AVFoundation

final class CamConnect {
    private var session = AVCaptureSession()
    private var input: AVCaptureDeviceInput?
    private var output: AVCaptureVideoDataOutput?
    private var lock = NSRecursiveLock()
    private var listeners = [CamConnectServiceListener]()
}

extension CamConnect: CamConnectService {
    func startCameraFor(delegate: CamConnectServiceListener) -> String? {
        let captureDevice: AVCaptureDevice
        if #available(iOS 10.0, *) {
            let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                          mediaType: AVMediaType.video,
                                                                          position: .back)
            guard let cd = deviceDiscoverySession.devices.first else {
                return "Failed to get the camera device".localized
            }
            captureDevice = cd
        } else {
            guard let cd = AVCaptureDevice.default(for: AVMediaType.video) else {
                return "Failed to get the camera device".localized
            }
            captureDevice = cd
        }
        do {
            // get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            session.addInput(input)
            lock.lock(); defer { lock.unlock() }
            // do not start tracking again if we're already doing it:
            let added = listeners.contains(where: {
                $0.nameForImageFromCamera == delegate.nameForImageFromCamera
            })
            if !added {
                listeners.append(delegate)
            }
            // we do listen to the events already, so simply quit:
            if added && listeners.count > 0 { return nil }
            session.sessionPreset = AVCaptureSession.Preset.photo
            output = AVCaptureVideoDataOutput()
            output!.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
            session.addOutput(output!)

            let imageLayer = AVCaptureVideoPreviewLayer(session: session)
            for d in self.listeners {
                d.changed(layer: imageLayer)
            }
            session.startRunning()
            return nil

        } catch {
            return "Failed to get the camera device".localized
        }
    }

    func stopCameraFor(delegate: CamConnectServiceListener) {
        lock.lock(); defer { lock.unlock() }
        listeners.removeAll(where: {
            $0.nameForImageFromCamera == delegate.nameForImageFromCamera
        })
        if listeners.count == 0 {
            session.stopRunning()
            session.inputs.forEach({ session.removeInput($0 )})
            if let out = output {
                session.removeOutput(out)
                output = nil
            }
        }
    }
}
