import SwiftUI

struct ContextMenuFullTitleModifier: ViewModifier {
    let text: String
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
            Button(action: {
                UIPasteboard.general.string = text
            }) {
                Label(text, systemImage: "document.on.document")
            }
        }
    }
}

extension View {
    func showFullTitleContextMenu(_ text: String) -> some View {
        self.modifier(ContextMenuFullTitleModifier(text: text))
    }
}
