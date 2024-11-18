import SwiftUI

struct AsyncImageView: View {
    let imageUrl: String

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipped()
            } else if phase.error != nil {
                Text("There was an error loading the image.")
                    .foregroundColor(.red)
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    AsyncImageView(imageUrl: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg")
}
