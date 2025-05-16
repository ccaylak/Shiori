import Foundation
import SwiftUI

enum ProgressStatus: Equatable {
    case anime(Anime)
    case manga(Manga)
    case unknown
    
    enum Anime: String, CaseIterable {
        case all, completed, watching, dropped
        case onHold = "on_hold"
        case planToWatch = "plan_to_watch"
        
        var displayName: String {
            switch self {
            case .all: return String(localized: "All", comment: "Progress status")
            case .watching: return String(localized: "Watching", comment: "Progress status")
            case .completed: return String(localized: "Completed", comment: "Progress status")
            case .onHold: return String(localized: "On Hold", comment: "Progress status")
            case .dropped: return String(localized: "Dropped", comment: "Progress status")
            case .planToWatch: return String(localized: "Plan To Watch", comment: "Progress status")
            }
        }
        
        @ViewBuilder
        var profileIcon: some View {
            switch self {
            case .all:
                Image(systemName: "tv.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.green)
            case .watching:
                Image(systemName: "play.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.accentColor, Color.primary)
            case .completed:
                Image(systemName: "checkmark.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.green, Color.primary)
            case .onHold:
                Image(systemName: "pause.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.yellow, Color.primary)
            case .dropped:
                Image(systemName: "trash.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.red, Color.primary)
            case .planToWatch:
                Image(systemName: "calendar.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.gray, Color.primary)
            }
        }
        
        @ViewBuilder
        var libraryIcon: some View {
            switch self {
            case .all:
                Image(systemName: "rectangle.stack.fill")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.primary)
            case .watching:
                Image(systemName: "play.tv.fill")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.accentColor)
            case .completed:
                Image(systemName: "checkmark")
                    .fontWeight(.bold)
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.green)
            case .onHold:
                Image(systemName: "pause.fill")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.yellow)
            case .dropped:
                Image(systemName: "trash.fill")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.red)
            case .planToWatch:
                Image(systemName: "calendar")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.gray)
            }
        }
    }
    
    enum Manga: String, CaseIterable {
        case all, completed, reading, dropped
        case onHold = "on_hold"
        case planToRead = "plan_to_read"
        
        var displayName: String {
            switch self {
            case .all: return String(localized: "All")
            case .reading: return String(localized: "Reading")
            case .completed: return String(localized: "Completed")
            case .onHold: return String(localized: "On Hold")
            case .dropped: return String(localized: "Dropped")
            case .planToRead: return String(localized: "Plan To Read")
            }
        }
        
        @ViewBuilder
        var profileIcon: some View {
            switch self {
            case .all:
                Image(systemName: "tv.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.primary)
            case .reading:
                Image(systemName: "book.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.accentColor, Color.primary)
            case .completed:
                Image(systemName: "checkmark.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.green, Color.primary)
            case .onHold:
                Image(systemName: "book.closed.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.yellow, Color.primary)
            case .dropped:
                Image(systemName: "trash.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.red, Color.primary)
            case .planToRead:
                Image(systemName: "calendar.circle")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(Color.gray, Color.primary)
            }
        }
        
        @ViewBuilder
        var libraryIcon: some View {
            switch self {
            case .all:
                Image(systemName: "books.vertical.fill")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.primary)
            case .reading:
                Image(systemName: "book.fill")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.accentColor)
            case .completed:
                Image(systemName: "checkmark")
                    .fontWeight(.bold)
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.green)
            case .onHold:
                Image(systemName: "book.closed.fill")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.yellow)
            case .dropped:
                Image(systemName: "trash.fill")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.red)
            case .planToRead:
                Image(systemName: "calendar")
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(Color.gray)
            }
        }
    }
    
    var displayName: String {
        switch self {
        case .anime(let status): return status.displayName
        case .manga(let status): return status.displayName
        case .unknown: return String("Unknown progress status")
        }
    }
}
