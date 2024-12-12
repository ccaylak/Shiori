import SwiftUI

struct RatingView: View {
    
    let rating: Int
    let status: String
    let progress: Int
    let total: String
    let mediaType: String
    let loggedIn: Bool
    
    var body: some View {
        VStack (spacing: 20) {
            Text("Your statistics")
                .tint(.primary)
            
            if (loggedIn) {
                HStack(alignment: .top, spacing: 30) {
                    VStack {
                        Text("Rating")
                        
                        Label("\(rating)", systemImage: "star.fill")
                            .accentColor(.primary)
                    }
                    
                    VStack {
                        Text("Status")
                        Label(status, systemImage: "star")
                        // completed = checkmark.fill
                        // planToWatch = calendar.badge.plus
                        // watching = tv
                        // dropped = trash.circle.fill
                        // onHold = pause.circle.fill
                    }
                    
                    VStack {
                        Text("Progress")
                        
                        Label("\(progress)/\(total)", systemImage: "arrow.2.circlepath")
                        // rectangle.stack.fill
                        // text.book.closed.fill
                    }
                }
            } else {
                GroupBox {
                    Text("Log in with your MyAnimeList account to see your \(mediaType) progress, rating and progress status.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                } label: {
                    Label("Info", systemImage: "info.circle")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    RatingView(
        rating: 4,
        status: "finished",
        progress: 100,
        total: "100",
        mediaType: "anime",
        loggedIn: true
    )
}
