//
//  PlaceDetail.swift
//  
//
//  Created by Jeremy Greenwood on 5/12/22.
//

import Model
import SwiftUI
import UIComponents
import MapKit

struct PlaceDetail: View {
    let place: Place
    @Binding var route: HomeDomain.Route?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Map(coordinateRegion: .constant(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: place.geometry.location.lat,
                            longitude: place.geometry.location.lng),
                        span: MKCoordinateSpan(
                            latitudeDelta: 0.01,
                            longitudeDelta: 0.01))),
                    interactionModes: [],
                    annotationItems: [place],
                    annotationContent: { place in
                    MapMarker(coordinate: CLLocationCoordinate2D(
                        latitude: place.geometry.location.lat,
                        longitude: place.geometry.location.lng))
                    }
                ).frame(height: 200)

                PlaceComponent(place: place)
                    .padding()

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(place.name)
            .toolbar {
                ToolbarItem(
                    placement: .navigationBarLeading) {
                        Button(action: {
                            route = nil
                        }, label: {
                            Text("Done")
                                .font(.headline)
                        })
                }
            }
        }
    }
}

#if DEBUG
import Mock

struct PlaceDetail_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetail(
            place: Mock.places[0],
            route: .constant(nil))
    }
}
#endif
