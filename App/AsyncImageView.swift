import SwiftUI
import NukeUI

struct AsyncImageView: View {
    let imageUrl: String

    var body: some View {
        LazyImage(url: URL(string: imageUrl)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if phase.error != nil {
                Text("There was an error loading the image.")
                    .foregroundColor(.red)
            } else {
                Rectangle()
                    .fill(Color.gray)
            }
        }
    }
}

#Preview {
    AsyncImageView(imageUrl: "https://cdn.myanimelist.net/images/anime/9/74398l.jpg")
}
