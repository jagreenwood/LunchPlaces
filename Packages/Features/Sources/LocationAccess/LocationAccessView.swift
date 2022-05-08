//
//  LocationAccessView.swift
//
//
//  Created by Jeremy Greenwood on 05/08/2022.
//

import ComposableArchitecture
import SwiftUI
import Localization

public struct LocationAccessView: View {
    let store: Store<LocationAccessDomain.State, LocationAccessDomain.Action>

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(Localization.LocationAccess.title)
            }
        }
    }
}

#if DEBUG
struct LocationAccessView_Previews: PreviewProvider {
    static var previews: some View {
        LocationAccessView(
            store: Store(
                initialState: LocationAccessDomain.State(),
                reducer: LocationAccessDomain.reducer,
                environment: .mock(.mock))
        )
    }
}
#endif
