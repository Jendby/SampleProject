//
//  Constants.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import UIKit

struct Const {
    static let os = "iOS"

    enum Devices {
        static let iPad = UI_USER_INTERFACE_IDIOM() == .pad
        static let iPhone = UI_USER_INTERFACE_IDIOM() == .phone
        static let iPhone4 = iPhone && UIScreen.main.bounds.size.height == 480.0  // iPhone 2G, 3G, 3GS, 4, 4s
        static let iPhone5 = iPhone && UIScreen.main.bounds.size.height == 568.0  // iPhone 5, 5s, 5c, SE
        static let iPhone6 = iPhone && UIScreen.main.bounds.size.height == 667.0  // iPhone 6, 6s, 7, 8
        static let iPhone6Plus = iPhone && Const.Sizes.maxScreenSize == 736.0       // iPhone 6+, 6s+, 7+, 8+
        static let iPhoneX = iPhone && Const.Sizes.maxScreenSize == 812.0           // iPhone X
        static let iPadPro12 = iPad && Const.Sizes.maxScreenSize == 1366.0
        static let isRetina = Const.Sizes.screenScale >= 2.0
    }

    enum Sizes {
        static let iPadContentSize = CGSize(width: 460, height: min(Const.Sizes.minScreenSize * 0.8, 700))
        static let screenScale = UIScreen.main.scale
        static var screenSize: CGSize { return UIScreen.main.bounds.size }
        static var screenWidth: CGFloat { return screenSize.width }
        static var screenHeight: CGFloat { return screenSize.height }
        static let maxScreenSize = max(screenWidth, screenHeight)
        static let minScreenSize = min(screenWidth, screenHeight)
        static let maxCaptchaSize: CGFloat = 2048
        @available(iOS 11.0, *)
        static let safeAreaInsets: UIEdgeInsets = SceneDelegate.currentDelegate.window!.safeAreaInsets
    }

    static let domain = ""

    struct notification {
        static let authErr = "AuthError"
    }

    struct cache {
        static let info = "cache_info"
        static let galleryFilled = "cache_gallery_filled"
    }

    struct keys {
        static let name = "keys_name"
        static let image = "keys_image"
        static let category = "keys_category"
        static let publishType = "currentPublishType"
        static let title = "window_title"
        static let ownAvatar = "own_avatar"
        static let sticker = "sticker"
        static let parallax = "parallax"
        static let panorama = "b360"
        static let arJSON = "ar_scene"
        static let arType = "ar"
        static let background = "background"
    }

    // error codes
    struct err {
        static let kNet = -100
        static let kNetAuth = -101
        struct fields {
            static let data = "data"
            static let defDescr = "default_description"
            static let kindOfErr = "error"
        }
    }

    // commonly used texts in UI
    struct text {
        static let kClose = "Close".localized
        static let kOk = "Ok".localized
        static let kCancel = "Cancel".localized
        static let kCancelAction = "CancelAction".localized
        static let kYes = "Yes".localized
        static let kNo = "No".localized
    }
}
