//
//  AppView.swift
//
//
//  Created by Jeremy Greenwood on 05/07/2022.
//

import ComposableArchitecture
import SwiftUI

public struct AppView: View {
    let store: Store<AppDomain.State, AppDomain.Action>

    public var body: some View {
        WithViewStore(store) { viewStore in
            Text(viewStore.name)
                .padding()
                .onAppear {
                    viewStore.send(.onAppear)
                }
        }
    }
}

#if DEBUG
struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(
            store: Store(
                initialState: AppDomain.State(),
                reducer: AppDomain.reducer,
                environment: .mock(.mock))
        )
    }
}
#endif
