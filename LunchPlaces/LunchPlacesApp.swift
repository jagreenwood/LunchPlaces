//
//  LunchPlacesApp.swift
//  LunchPlaces
//
//  Created by Jeremy Greenwood on 5/5/22.
//

import App
import SwiftUI

@main
struct LunchPlacesApp: App {
    let store = Store(
        initialState: .init(),
        reducer: AppDomain.reducer,
        environment: .mock(.mock))

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
