/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Small extensions to simplify view handling in the demo app.
*/

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public extension PlatformView {
    func pinToSuperviewEdges() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }

    func setBorder(color: PlatformColor, width: CGFloat) {
        #if os(iOS)
        layer.borderColor = color.cgColor
        layer.borderWidth = CGFloat(width)
        #elseif os(macOS)
        layer?.borderColor = color.cgColor
        layer?.borderWidth = CGFloat(width)
        #endif
    }
}
