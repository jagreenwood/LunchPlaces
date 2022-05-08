//
//  Localization.swift
//
//
//  Created by Jeremy Greenwood on 5/7/22.
//

import Foundation

public struct Localization {
    public struct Generic {
        public static let appName = NSLocalizedString("Generic.appName", bundle: .strings, comment: "")
    }

    public struct LocationAccess {
        public static let title = NSLocalizedString("LocationAccess.title", bundle: .strings, comment: "")
        public static let disabledBody = NSLocalizedString("LocationAccess.disabledBody", bundle: .strings, comment: "")
        public static let deniedBody = NSLocalizedString("LocationAccess.deniedBody", bundle: .strings, comment: "")
        public static let notDeterminedBody = NSLocalizedString("LocationAccess.notDeterminedBody", bundle: .strings, comment: "")
        public static let buttonTitle = NSLocalizedString("LocationAccess.buttonTitle", bundle: .strings, comment: "")
    }

    public struct Home {
        public static let searchPlaceholder = NSLocalizedString("Home.searchPlaceholder", bundle: .strings, comment: "")
    }
}

private class FindMyBundle {}

/// Provides better compatibility for SwiftUI previews
private extension Foundation.Bundle {
    static var strings: Bundle = {
        let bundleName = "Localization_Localization"
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,
            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: FindMyBundle.self).resourceURL,
            /* For command-line tools. */
            Bundle.main.bundleURL,
            /* Bundle should be present here when the package is used in UI Tests. */
            Bundle(for: FindMyBundle.self).resourceURL?.deletingLastPathComponent(),
            /* Bundle should be present here when running previews from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: FindMyBundle.self).resourceURL?.deletingLastPathComponent().deletingLastPathComponent()
        ]

        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        fatalError("unable to find bundle named \(bundleName)")
    }()
}
