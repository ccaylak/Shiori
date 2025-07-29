import SwiftUI

struct StatisticsView: View {
    
    let score: Double
    let rank: Int
    let popularity: Int
    let users: Int
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if (users != 0) {
                Text("Based on \(users.formatted()) user ratings")
                    .font(.caption2)
                    .bold()
            }
            
            HStack (alignment: .center){
                if(score != 0.0){
                    VStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.subheadline)
                        
                        Text("Score")
                            .font(.caption)
                        
                        Text("\(score.formatted())")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity)
                }
                Divider()
                if(rank != 0){
                    VStack(spacing: 3) {
                        Image(systemName: "number")
                            .font(.subheadline)
                        
                        Text("Rank")
                            .font(.caption)
                        
                        Text("\(rank)")
                            .font(.body)
                    }
                    .frame(maxWidth: .infinity)
                }
                Divider()
                VStack(spacing: 3) {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.subheadline)
                    
                    Text("Popularity")
                        .font(.caption)
                    
                    Text("\(popularity)")
                        .font(.body)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding([.top, .bottom], 8)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
