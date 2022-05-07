//
//  Localization.swift
//
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import Foundation

private class BundleLocator {
    static let bundle: Bundle = Bundle(for: BundleLocator.self)
}

public struct Localization {
    public struct Generic {
        public static let appName = NSLocalizedString("Generic.appName", bundle: BundleLocator.bundle, comment: "")
    }

    public struct Home {
        public static let searchPlaceholder = NSLocalizedString("Home.searchPlaceholder", bundle: BundleLocator.bundle, comment: "")
    }
}
