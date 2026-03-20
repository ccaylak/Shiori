import Foundation
import SwiftUI

extension View {
    
    @ViewBuilder
    func isVisible(_ visible: Bool) -> some View {
        if visible {
            self
        } else {
            EmptyView()
        }
    }
}
