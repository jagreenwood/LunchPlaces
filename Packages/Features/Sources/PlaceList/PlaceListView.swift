//
//  PlaceListView.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import Common
import PlaceRow
import SwiftUI

public struct PlaceListView: View {
    let store: Store<PlaceListDomain.State, PlaceListDomain.Action>

    public init(store: Store<PlaceListDomain.State, PlaceListDomain.Action>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEachStore(
                    store.scope(
                        state: \.placeRowStates,
                        action: PlaceListDomain.Action.placeRow(id:action:)),
                    content: PlaceRowView.init(store:)
                )
            }.padding()
        }.background(Color.appBackground)
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
