//
//  HomeView.swift
//
//
//  Created by Jeremy Greenwood on 05/10/2022.
//

import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    let store: Store<HomeDomain.State, HomeDomain.Action>

    public init(store: Store<HomeDomain.State, HomeDomain.Action>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            Text(viewStore.name)
                .padding()
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            store: Store(
                initialState: HomeDomain.State(),
                reducer: HomeDomain.reducer,
                environment: .mock(.mock))
        )
    }
}
#endif
