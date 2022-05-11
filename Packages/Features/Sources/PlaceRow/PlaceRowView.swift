//
//  PlaceRowView.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import ComposableArchitecture
import SwiftUI

public struct PlaceRowView: View {
    let store: Store<PlaceRowDomain.State, PlaceRowDomain.Action>

    public init(store: Store<PlaceRowDomain.State, PlaceRowDomain.Action>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            Text(viewStore.place.name)
                .padding()
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }
}

#if DEBUG
import Mock

struct PlaceRowView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceRowView(
            store: Store(
                initialState: PlaceRowDomain.State(place: Mock.places.first!),
                reducer: PlaceRowDomain.reducer,
                environment: .mock(.mock))
        )
    }
}
#endif
