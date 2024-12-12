import SwiftUI

struct StatisticsView: View {
    
    let score: Double
    let rank: Int
    let popularity: Int
    let users: Int
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Statistics by \(users) users")
            HStack (alignment: .center, spacing: 80){
                if(score != 0.0){
                    VStack {
                        Text("Score")
                            .font(.caption)
                            .bold()
                        Label("\(score.formatted())", systemImage: "star.fill")
                    }}
                
                if(rank != 0){
                    VStack {
                        Text("Rank")
                            .font(.caption)
                            .bold()
                        Label("\(rank)", systemImage: "number")
                    }}
                
                VStack {
                    Text("Popularity")
                        .font(.caption)
                        .bold()
                    Label("\(popularity)", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    StatisticsView(
        score: 8.0,
        rank: 1,
        popularity: 1000,
        users: 10000
    )
}
