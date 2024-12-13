import SwiftUI

struct MoreImagesView: View {
    
    let images: [Images]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("More images")
                .font(.headline)
            NavigationLink(destination: ImageViewerView(images: images)) {
                ZStack {
                    VStack {
                        AsyncImage(url: URL(string: images.first?.large ?? "")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .clipped()
                            } else if phase.error != nil {
                                Text("There was an error loading the image.")
                                    .foregroundColor(.red)
                            } else {
                                ProgressView()
                            }
                        }
                        if(images.count > 1) {
                            HStack {
                                ForEach(1...2, id: \.self) { index in
                                    AsyncImage(url: URL(string: images[index].large)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 100)
                                                .cornerRadius(12)
                                                .clipped()
                                        } else if phase.error != nil {
                                            Text("There was an error loading the image.")
                                                .foregroundColor(.red)
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                    .frame(height: 100)
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    Rectangle()
                        .fill(Color.gray.opacity(0.5))
                        .cornerRadius(12)
                    
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .cornerRadius(12)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    let exampleImages: [Images] = [
        Images(medium: "https://cdn.myanimelist.net/images/anime/1675/127908.jpg", large: "https://cdn.myanimelist.net/images/anime/1675/127908l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1218/134045.jpg", large: "https://cdn.myanimelist.net/images/anime/1218/134045l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1667/135908.jpg", large: "https://cdn.myanimelist.net/images/anime/1667/135908l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1875/136959.jpg", large: "https://cdn.myanimelist.net/images/anime/1875/136959l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1553/137254.jpg", large: "https://cdn.myanimelist.net/images/anime/1553/137254l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1015/138006.jpg", large: "https://cdn.myanimelist.net/images/anime/1015/138006l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1531/139077.jpg", large: "https://cdn.myanimelist.net/images/anime/1531/139077l.jpg"),
        Images(medium: "https://cdn.myanimelist.net/images/anime/1036/140549.jpg", large: "https://cdn.myanimelist.net/images/anime/1036/140549l.jpg")
    ]

    MoreImagesView(images: exampleImages)
}
