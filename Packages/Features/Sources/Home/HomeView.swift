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
                ZStack {
                    VStack(spacing: 0) {
                        Self.textField(viewStore)

                        Divider()

                        ZStack(alignment: .bottom) {
                            if viewStore.showMap {
                                Self.mapView(viewStore)
                            } else {
                                PlaceListView(
                                    store: store.scope(
                                        state: \.placeListState,
                                        action: HomeDomain.Action.placeList))
                            }

                            Button(action: {
                                viewStore.send(.toggleMap)
                            }, label: {
                                Label(
                                    viewStore.showMap ? Localization.Home.list : Localization.Home.map,
                                    systemImage: viewStore.showMap ? "list.bullet" : "map")
                            })
                            .buttonStyle(ConfirmButtonStyle(showShadow: true))
                            .padding(.bottom)
                        }.onAppear {
                            viewStore.send(.onAppear)
                        }
                    }
                    .sheet(item: viewStore.binding(\.$route)) { route in
                        switch route {
                        case .placeDetail(let place):
                            PlaceDetail(
                                place: place,
                                route: viewStore.binding(\.$route))
                        }
                    }

                    if viewStore.isLoading {
                        ProgressView()
                            .progressViewStyle(.circular)
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

extension HomeView {
    static func textField(_ viewStore: ViewStore<HomeDomain.State, HomeDomain.Action>) -> some View {
        ZStack(alignment: .trailing) {
            TextField(Localization.Home.searchPlaceholder, text: viewStore.binding(\.$searchText))
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color.appBackground)
                .cornerRadius(10)
                .onSubmit {
                    viewStore.send(.submitSearch)
                }

            if !viewStore.searchText.isEmpty {
                Button(action: {
                    viewStore.send(.clearSearch)
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                        .accessibilityHidden(true)
                })
                .accessibilityLabel(Text(Localization.Home.clearSearch))
            }
        }
        .padding()
    }

    static func mapView(_ viewStore: ViewStore<HomeDomain.State, HomeDomain.Action>) -> some View {
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
                            viewStore.send(.showDetail(place))
                        }, label: {
                            HStack {
                                PlaceComponent(place: place)
                            }
                            .padding()
                            .background(Color.appPrimary.colorInvert())
                            .cornerRadius(10.0)
                            .scaleEffect(0.6)
                        })
                        .buttonStyle(.plain)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(Text("\(place.name)"))
                        .accessibility(hint: Text(Localization.Generic.accessibilityTapHint))
                }
            })
        .edgesIgnoringSafeArea([.bottom])
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
