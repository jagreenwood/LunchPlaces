//
//  HomeView.swift
//
//
//  Created by Jeremy Greenwood on 05/10/2022.
//

import ComposableArchitecture
import Localization
import MapKit
import PlaceList
import SwiftUI
import UIComponents

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
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(Color.appBackground)
                            .cornerRadius(10)
                    }
                    .padding()

                    Divider()

                    ZStack {
                        if viewStore.showMap {
                            Map(
                                coordinateRegion: viewStore.binding(\.$mapCooridinate),
                                interactionModes: [.all],
                                showsUserLocation: true,
                                annotationItems: viewStore.places,
                                annotationContent: { place in
                                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                                        latitude: place.geometry.location.lat,
                                        longitude: place.geometry.location.lng)) {
                                            Button(action: {

                                            }, label: {
                                                HStack {
                                                    PlaceComponent(place: place)
                                                    Image(systemName: "chevron.right")
                                                }
                                                .padding()
                                                .background(Color.appPrimary.colorInvert())
                                                .cornerRadius(10.0)
                                                .scaleEffect(0.6)
                                            }).buttonStyle(.plain)
                                    }
                                })
                        } else {
                            PlaceListView(
                                store: store.scope(
                                    state: \.placeListState,
                                    action: HomeDomain.Action.placeList))
                        }
                    }.onAppear {
                        viewStore.send(.onAppear)
                    }
                }
            }
            .edgesIgnoringSafeArea([.bottom])
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
