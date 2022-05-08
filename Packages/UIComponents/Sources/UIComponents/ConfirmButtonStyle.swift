//
//  ConfirmButtonStyle.swift
//  
//
//  Created by Jeremy Greenwood on 5/8/22.
//

import SwiftUI

public struct ConfirmButtonStyle: ButtonStyle {
    public var color: Color
    public var showShadow: Bool

    public init(
        color: Color = .blue,
        showShadow: Bool = false) {
            self.color = color
            self.showShadow = showShadow
    }

    public func makeBody(configuration: ConfirmButtonStyle.Configuration) -> some View {
        ConfirmButton(
            configuration: configuration,
            color: color,
            showShadow: showShadow
        )
    }

    struct ConfirmButton: View {
        let configuration: ConfirmButtonStyle.Configuration
        let color: Color
        let showShadow: Bool

        var body: some View {

            return configuration.label
                .font(.headline)
                .foregroundColor(.primary).colorInvert()
                .padding(15)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(color)
                )
                .compositingGroup()
                .shadow(color: showShadow ? .primary.opacity(0.25) : .clear, radius: 3)
                .opacity(configuration.isPressed ? 0.5 : 1.0)
        }
    }

}
