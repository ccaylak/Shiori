import SwiftUI

struct ImageViewerView: View {
    
    let images: [Images]
    
    var body: some View {
        TabView {
            ForEach(images, id: \.self) { image in
                AsyncImage(url: URL(string: image.large)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if phase.error != nil {
                        Text("There was an error loading the image.")
                            .foregroundColor(.red)
                    } else {
                        ProgressView()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
    
}

#Preview {
    let exampleImages = [
        Images(medium: "https://cdn.myanimelist.net/images/anime/1675/127908.jpg", large: "https://cdn.myanimelist.net/images/anime/1675/127908l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1218/134045.jpg", large: "https://cdn.myanimelist.net/images/anime/1218/134045l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1667/135908.jpg", large: "https://cdn.myanimelist.net/images/anime/1667/135908l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1875/136959.jpg", large: "https://cdn.myanimelist.net/images/anime/1875/136959l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1553/137254.jpg", large: "https://cdn.myanimelist.net/images/anime/1553/137254l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1015/138006.jpg", large: "https://cdn.myanimelist.net/images/anime/1015/138006l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1531/139077.jpg", large: "https://cdn.myanimelist.net/images/anime/1531/139077l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1036/140549.jpg", large: "https://cdn.myanimelist.net/images/anime/1036/140549l.jpg")
    ]
    
    ImageViewerView(images: exampleImages)
}
