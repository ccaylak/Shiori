import SwiftUI

struct StatisticsView: View {
    
    let score: Double
    let rank: Int
    let popularity: Int
    
    var body: some View {
        VStack(alignment: .center) {
            HStack (alignment: .center, spacing: 80){
                if(score != 0.0){
                    VStack {
                        Text("Score")
                            .font(.caption)
                            .bold()
                        Text("\(score.formatted())")
                    }}
                
                if(rank != 0){
                    VStack {
                        Text("Rank")
                            .font(.caption)
                            .bold()
                        Text("\(rank)")
                    }}
                
                VStack {
                    Text("Popularity")
                        .font(.caption)
                        .bold()
                    Text("\(popularity)")
                }
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    StatisticsView(score: 8.0, rank: 1, popularity: 1000)
}
