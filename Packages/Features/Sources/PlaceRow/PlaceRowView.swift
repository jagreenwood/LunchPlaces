//
//  PlaceRowView.swift
//
//
//  Created by Jeremy Greenwood on 05/11/2022.
//

import ComposableArchitecture
import SwiftUI
import UIComponents

public struct PlaceRowView: View {
    let store: Store<PlaceRowDomain.State, PlaceRowDomain.Action>

    public init(store: Store<PlaceRowDomain.State, PlaceRowDomain.Action>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            HStack(alignment: .top, spacing: 20) {
                PlaceComponent(place: viewStore.place)

                Spacer()

                Button(
                    action: {
                        viewStore.send(.toggleFavorite)
                    },
                    label: {
                        Image(systemName: viewStore.isFavorite ? "heart.fill" : "heart")
                            .font(.title)
                            .foregroundColor(.red)
                    })
            }
            .alert(
                store.scope(state: \.alertState),
                dismiss: PlaceRowDomain.Action.error(nil))
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .stroke(Color(.quaternaryLabel), lineWidth: 1)
                    .background(RoundedRectangle(
                        cornerRadius: 4,
                        style: .continuous).fill(Color(.systemBackground)))
                    .foregroundColor(Color.primary),
                alignment: .center)
            .onTapGesture {
                viewStore.send(.rowWasSelected)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text("\(viewStore.place.name)"))
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
                initialState: PlaceRowDomain.State(
                    place: Mock.places.first!,
                    isFavorite: true),
                reducer: PlaceRowDomain.reducer,
                environment: .mock(.mock))
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
