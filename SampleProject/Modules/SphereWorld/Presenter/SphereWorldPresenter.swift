//
//  SphereWorldPresenter.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 02/03/2020.
//  Copyright © 2020 JendBy. All rights reserved.
//

import UIKit
import CoreMotion

final class SphereWorldPresenter {

    weak var view: SphereWorldViewInput!
    var interactor: SphereWorldInteractorInput!
    var router: SphereWorldRouterInput!
    var retained: UIViewController? = nil
    let motionTracker: MotionTrackerService
    var tracked360 = false
    
    init(motionTracker: MotionTrackerService) {
        self.motionTracker = motionTracker
    }
    
    private func toggle360video() {
        tracked360 = !tracked360
        if !tracked360 {
            stop360video()
        }
        view.set360btn(tracked: tracked360)
    }

    private func stop360video() {
        motionTracker.stopTrackingFor(delegate: self)
        view.detachArViewWithSphere()
    }
}

// MARK: - SphereWorldModuleInput
extension SphereWorldPresenter: SphereWorldModuleInput {
	func present(from viewController: UIViewController) {
        self.view.present(from: viewController)
        retained = nil
	}
}

// MARK: - SphereWorldViewOutput
extension SphereWorldPresenter: SphereWorldViewOutput {
    func stopTracking() {
        stop360video()
    }
    
    func back360attached() {
        toggle360video()
        view.hideBusyIndicator()
    }
    
    func navBtnTapped() {
        if tracked360 {
            view.detachArViewWithSphere()
            toggle360video()
        } else {
            view.showBusyIndicator()
            if let err = motionTracker.startTrackingFor(delegate: self) {
                view.hideBusyIndicator()
                view.show(error: err.localizedDescription)
            } else {
                // try to initialize window for that in view:
                view.attachArViewWithSphereAnd(image: #imageLiteral(resourceName: "imgFor360"))
            }
        }
    }
    
    func viewIsReady() {
        view.set360btn(tracked: tracked360)
    }
}

// MARK: - MotionTrackerServiceListener
extension SphereWorldPresenter: MotionTrackerServiceListener {
    var name: String {
        return String(describing: self)
    }

    func changed(motion: CMDeviceMotion?, error: Error?) {
        if let e = error {
            view.detachArViewWithSphere()
            tracked360 = false
//            view.set360btn(tracked360: tracked360)
            view.hideBusyIndicator()
            view.show(error: e.localizedDescription)
        } else if let a = motion?.attitude {
            view.changed(attitude: a)
        }
    }
}
// MARK: - SphereWorldInteractorOutput
extension SphereWorldPresenter: SphereWorldInteractorOutput {
}
