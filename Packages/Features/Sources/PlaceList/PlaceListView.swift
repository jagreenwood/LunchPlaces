//
//  PlaceListView.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import ComposableArchitecture
import SwiftUI

public struct PlaceListView: View {
    let store: Store<PlaceListDomain.State, PlaceListDomain.Action>

    public init(store: Store<PlaceListDomain.State, PlaceListDomain.Action>) {
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
struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListView(
            store: Store(
                initialState: PlaceListDomain.State(),
                reducer: PlaceListDomain.reducer,
                environment: .mock(.mock))
        )
    }
}
#endif
