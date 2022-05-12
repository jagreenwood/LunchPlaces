//
//  PlaceComponent.swift
//  
//
//  Created by Jeremy Greenwood on 5/12/22.
//

import struct Model.Place
import SwiftUI

public struct PlaceComponent: View {
    static let maxRating = 5
    let place: Place

    public init(place: Place) {
        self.place = place
    }

    var ratingValue: Int {
        guard let rating = place.rating else {
            return 0
        }

        return Int(rating.rounded())
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(place.name)
                .font(.title2)

            if place.rating != nil {
                HStack {
                    HStack(spacing: 0) {
                        ForEach(1...PlaceComponent.maxRating, id: \.self) { value in
                            Image(systemName: value <= ratingValue ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                    }

                    if let ratingTotal = place.userRatingsTotal {
                        Text("(\(ratingTotal))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }

            if let priceLevel = place.priceLevel {
                HStack(spacing: 4) {
                    Text(String(repeating: "$", count: priceLevel))

                    if let openingHours = place.openingHours {
                        Text("• \(openingHours.openNow ? "open" : "closed")")
                    }
                }.font(.subheadline)
            }
        }
    }
}

#if DEBUG
import Mock

struct PlaceComponent_Previews: PreviewProvider {
    static var previews: some View {
        PlaceComponent(place: Mock.places[0])
    }
}
#endif
