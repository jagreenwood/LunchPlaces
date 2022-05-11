//
//  HomeView.swift
//
//
//  Created by Jeremy Greenwood on 05/10/2022.
//

import ComposableArchitecture
import SwiftUI
import PlaceList
import Localization

public struct HomeView: View {
    let store: Store<HomeDomain.State, HomeDomain.Action>

    public init(store: Store<HomeDomain.State, HomeDomain.Action>) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                VStack(spacing: 0) {
                    HStack {
                        TextField("Search", text: .constant(""))
                    }
                    .padding()

                    Divider()

                    ZStack {
                        PlaceListView(
                            store: store.scope(
                                state: \.placeListState,
                                action: HomeDomain.Action.placeList))
                    }.onAppear {
                        viewStore.send(.onAppear)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "leaf.fill")
                        Text(Localization.Generic.appName)
                            .font(.headline)
                    }
                }
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
