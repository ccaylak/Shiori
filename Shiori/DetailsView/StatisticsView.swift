import SwiftUI

struct StatisticsView: View {
    
    let score: Double
    let rank: Int
    let popularity: Int
    let users: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("Statistics by ")
                .font(.caption)
            +
            Text("\(users) users")
                .font(.caption)
                .bold()
            
            HStack (alignment: .center){
                if(score != 0.0){
                    VStack {
                        Text("Score")
                            .font(.caption)
                            .bold()
                        Label("\(score.formatted())", systemImage: "star.fill")
                    }}
                Spacer()
                if(rank != 0){
                    VStack {
                        Text("Rank")
                            .font(.caption)
                            .bold()
                        Label("\(rank)", systemImage: "number")
                    }}
                Spacer()
                VStack {
                    Text("Popularity")
                        .font(.caption)
                        .bold()
                    Label("\(popularity)", systemImage: "chart.line.uptrend.xyaxis")
                }
            }
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15))
        .background(Color.gray.opacity(0.15))
        .cornerRadius(12)
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
