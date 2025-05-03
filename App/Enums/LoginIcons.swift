import SwiftUI

enum LoginIcon {
    case mangaCompleted
    case mangaOnHold
    case mangaReading
    case mangaDropped
    case mangaPlanToRead
    
    case animeCompleted
    case animeOnHold
    case animeWatching
    case animeDropped
    case animePlanToWatch
    
    private func makeIcon(baseIcon: String, overlayIcon: String) -> some View {
        Image(systemName: baseIcon)
            .font(.system(size: 18))
            .symbolRenderingMode(.monochrome)
            .foregroundStyle(.secondary)
            .overlay(
                Image(systemName: overlayIcon)
                    .font(.system(size: 15))
                    .background(
                        Circle()
                            .fill(Color(.systemBackground))
                            .frame(width: 12, height: 12)
                    )
                    .offset(x: 6, y: -6),
                alignment: .topTrailing
            )
    }
    
    var image: some View {
        switch self {
        case .mangaCompleted: return makeIcon(baseIcon: "character.book.closed.ja", overlayIcon: "checkmark.circle.fill")
        case .mangaOnHold: return makeIcon(baseIcon: "character.book.closed.ja", overlayIcon: "pause.circle.fill")
        case .mangaDropped: return makeIcon(baseIcon: "character.book.closed.ja",overlayIcon: "x.circle.fill")
        case .mangaReading: return makeIcon(baseIcon: "character.book.closed.ja",overlayIcon: "circle.dotted.circle.fill")
        case .mangaPlanToRead: return makeIcon(baseIcon: "character.book.closed.ja",overlayIcon: "calendar.circle.fill")
            
        case .animeCompleted: return makeIcon(baseIcon: "tv", overlayIcon: "checkmark.circle.fill")
        case .animeOnHold: return makeIcon(baseIcon: "tv", overlayIcon: "pause.circle.fill")
        case .animeWatching: return makeIcon(baseIcon: "tv", overlayIcon: "circle.dotted.circle.fill")
        case .animeDropped: return makeIcon(baseIcon: "tv", overlayIcon: "x.circle.fill")
        case .animePlanToWatch: return makeIcon(baseIcon: "tv", overlayIcon: "calendar.circle.fill")
        }
    }
}
