import Foundation

struct JikanImages: Decodable {
    
    private(set) var jpg: JikanImageData?
    private(set) var webp: JikanImageData?
    
    init() {}
}

struct JikanImageData: Decodable {
    
    private(set) var imageUrl: String?
    private(set) var smallImageUrl: String?
    private(set) var largeImageUrl: String?
    
    init() {}
}

extension JikanImages {
    var jpgImage: JikanImageData {
        jpg ?? JikanImageData()
    }
    
    var webpImage: JikanImageData {
        webp ?? JikanImageData()
    }
}

extension JikanImageData {
    var baseImage: String {
        imageUrl ?? "https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.istockphoto.com%2Fillustrations%2Fpage-not-found-icon&ved=0CBYQjRxqFwoTCPD8lsjCpZMDFQAAAAAdAAAAABAk&opi=89978449"
    }
    
    var smallImage: String {
        smallImageUrl ?? "https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.istockphoto.com%2Fillustrations%2Fpage-not-found-icon&ved=0CBYQjRxqFwoTCPD8lsjCpZMDFQAAAAAdAAAAABAk&opi=89978449"
    }
    
    var largeImage: String {
        largeImageUrl ?? "https://www.google.com/url?sa=t&source=web&rct=j&url=https%3A%2F%2Fwww.istockphoto.com%2Fillustrations%2Fpage-not-found-icon&ved=0CBYQjRxqFwoTCPD8lsjCpZMDFQAAAAAdAAAAABAk&opi=89978449"
    }
}
