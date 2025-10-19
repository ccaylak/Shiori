import SwiftUI

struct StatisticsView: View {
    
    let score: Double
    let rank: Int
    let popularity: Int
    let users: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if users != 0 {
                Text("Based on \(users.formatted()) user ratings")
                    .font(.caption2)
                    .bold()
            }
            
            HStack(alignment: .center, spacing: 0) {
                let sections: [AnyView] = [
                    score != 0.0 ?
                        AnyView(statSection(icon: "star.fill", label: "Score", value: score.formatted())) : nil,
                    rank != 0 ?
                        AnyView(statSection(icon: "number", label: "Rank", value: "\(rank)")) : nil,
                    AnyView(statSection(icon: "chart.line.uptrend.xyaxis", label: "Popularity", value: "\(popularity)"))
                ].compactMap { $0 }

                ForEach(sections.indices, id: \.self) { index in
                    if index != 0 {
                        Divider()
                    }
                    sections[index]
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding([.top, .bottom], 8)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private func statSection(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.subheadline)
            Text(label)
                .font(.caption)
            Text(value)
                .font(.body)
        }
    }
}
