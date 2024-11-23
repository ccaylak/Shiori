import SwiftUI

struct StatisticsView: View {
    
    let rating: Double
    let rank: Int
    let popularity: Int
    
    var body: some View {
        VStack(alignment: .center) {
            HStack (alignment: .center, spacing: 80){
                if(rating != 0.0){
                    VStack {
                        Text("Score")
                            .font(.caption)
                            .bold()
                        Text("\(rating.formatted())")
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
    StatisticsView(rating: 8.5, rank: 1, popularity: 1000)
}
