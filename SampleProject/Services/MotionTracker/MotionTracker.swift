//
//  MotionTracker.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 ES. All rights reserved.
//

import Foundation
import CoreMotion

final class MotionTracker {
    func initialization() {
        initialized = true
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
    }

    private var initialized = false
    private lazy var motionManager: CMMotionManager = {
        let m = CMMotionManager()
        return m
    } ()
    private var lock = NSRecursiveLock()
    private var listeners = [MotionTrackerServiceListener]()
}

// MARK: - MotionTrackerService
extension MotionTracker: MotionTrackerService {
    func isAvailable() -> Bool {
        return motionManager.isDeviceMotionAvailable
    }

    func startTrackingFor(delegate: MotionTrackerServiceListener) -> Error? {
        if !isAvailable() {
            let e = NSError(domain: Const.domain,
                            code: -1,
                            userInfo:
                [
                    NSLocalizedDescriptionKey:
                        "Motion Tracking is not available on your device!".localized
                ])
            return e
        }
        if !initialized {
            initialization()
        }
        lock.lock(); defer { lock.unlock() }
        // do not start tracking again if we're already doing it:
        let added = listeners.contains(where: { $0.name == delegate.name })
        if !added {
            listeners.append(delegate)
        }
        // we do listen to the events already, so simply quit:
        if added && listeners.count > 0 { return nil }
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, err) in
            guard let `self` = self else { return }
            self.lock.lock(); defer { self.lock.unlock() }
            for d in self.listeners {
                d.changed(motion: motion, error: err)
            }
        }
        return nil
    }

    func stopTrackingFor(delegate: MotionTrackerServiceListener) {
        lock.lock(); defer { lock.unlock() }
        listeners.removeAll(where: { $0.name == delegate.name })
        if listeners.count == 0 {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}
