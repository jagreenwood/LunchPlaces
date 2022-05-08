//
//  LocationAccessView.swift
//
//
//  Created by Jeremy Greenwood on 05/08/2022.
//

import ComposableArchitecture
import Localization
import SwiftUI
import UIComponents

public struct LocationAccessView: View {
    let store: Store<LocationAccessDomain.State, LocationAccessDomain.Action>

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(Localization.LocationAccess.title)
                    .font(.largeTitle)

                Spacer()

                VStack(spacing: 20) {
                    Image(systemName: "location")
                        .font(.system(
                            size: 150,
                            weight: .thin,
                        design: .default))

                    Text(viewStore.bodyText)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                if viewStore.showConfirmButton {
                    Button(Localization.LocationAccess.buttonTitle) {
                        viewStore.send(.didSelectConfirm)
                    }
                    .buttonStyle(ConfirmButtonStyle())
                }
            }
            .padding()
            .onAppear {
                viewStore.send(.onAppear)
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
