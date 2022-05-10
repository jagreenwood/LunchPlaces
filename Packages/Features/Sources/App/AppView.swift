//
//  AppView.swift
//
//
//  Created by Jeremy Greenwood on 05/07/2022.
//

import ComposableArchitecture
import Home
import LocationAccess
import SwiftUI

public struct AppView: View {
    let store: Store<AppDomain.State, AppDomain.Action>

    public init(store: Store<AppDomain.State, AppDomain.Action>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                HomeView(store: store.scope(
                    state: \.homeState,
                    action: AppDomain.Action.home))

                IfLetStore(
                    store.scope(
                        state: \.locationAccessState,
                        action: AppDomain.Action.locationAccess),
                    then: LocationAccessView.init(store:))
                .zIndex(1)
                .animation(
                    viewStore.locationAccessState == nil
                    ? .easeIn // dismissing
                    : nil,    // presenting
                    value: viewStore.locationAccessState)
                .transition(.move(edge: .bottom))
            }
        }
    }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: AppDomain.State(),
                reducer: AppDomain.reducer,
                environment: .mock(.mock))
        )
    }
}
#endif
