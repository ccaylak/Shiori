import SwiftUI

struct LabelWithChevron: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            Text(LocalizedStringKey(text))
                .font(.headline)
            
            Image(systemName: "chevron.forward")
                .foregroundStyle(.secondary)
                .fontWeight(.bold)
        }
    }
}
