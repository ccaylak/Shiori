import SwiftUI

struct StrokeModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        if colorScheme == .light {
            content.overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary, lineWidth: 0.1)
            )
        } else {
            content
        }
    }
}

extension View {
    func strokedBorder() -> some View {
        self.modifier(StrokeModifier())
    }
}
