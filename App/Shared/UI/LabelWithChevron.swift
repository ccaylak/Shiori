import SwiftUI

struct LabelWithChevron: View {
    let text: LocalizedStringResource
    
    init(_ text: LocalizedStringResource) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            Text(text)
                .font(.title2)
                .bold()
            
            Image(systemName: "chevron.forward")
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
        }
    }
}
