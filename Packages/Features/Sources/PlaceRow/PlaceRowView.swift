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
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(viewStore.place.name)
                        .font(.title2)

                    if viewStore.state.showValue(\.rating) {
                        HStack {
                            HStack(spacing: 0) {
                                ForEach(1...PlaceRowDomain.State.maxRating, id: \.self) { value in
                                    Image(systemName: value <= viewStore.ratingValue ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                            }

                            if let ratingTotal = viewStore.place.userRatingsTotal {
                                Text("(\(ratingTotal))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }

                    if let priceLevel = viewStore.place.priceLevel {
                        HStack(spacing: 4) {
                            Text(Array(repeating: "$", count: priceLevel).joined())

                            if let openingHours = viewStore.place.openingHours {
                                Text("• \(openingHours.openNow ? "open" : "closed")")
                            }
                        }.font(.subheadline)
                    }
                }

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
