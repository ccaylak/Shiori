import SwiftUI

struct SeasonView: View {
    
    private let seasonController = SeasonController()
    @ObservedObject private var seasonManager: SeasonManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    
    @State private var jikanSeason = MediaResponse(data: [], paging: nil)
    
    @State private var groupedMedia: [MediaType.Anime: [Media]] = [:]
    
    var body: some View {
        NavigationStack {
            Form {
                ForEach(MediaType.Anime.allCases, id: \.self) { animeType in
                    if let items = groupedMedia[animeType], !items.isEmpty {
                        Section(header: Label(animeType.displayName,systemImage: animeType.icon)) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 10) {
                                    ForEach(items, id: \.node.id) { anime in
                                        NavigationLink(destination: DetailsView(media: anime.node)) {
                                            VStack(spacing: 3) {
                                                AsyncImageView(imageUrl: anime.node.mainPicture.largeUrl)
                                                    .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                                    .cornerRadius(12)
                                                    .strokedBorder()
                                                
                                                Text(anime.node.preferredTitle)
                                                    .font(.caption)
                                                    .lineLimit(2)
                                                    .frame(maxWidth: CoverSize.large.size.width, alignment: .leading)
                                            }
                                            .overlay(alignment: .topTrailing) {
                                                anime.node.getEntryStatus.libraryIcon
                                                    .padding(7)
                                                    .glassEffectOrMaterial()
                                                    .cornerRadius(12)
                                                    .isVisible(anime.node.getEntryStatus != .notSet)
                                            }
                                        }.buttonStyle(.plain)
                                    }
                                }
                            }
                            .scrollClipDisabled()
                        }
                    }
                }
            }
            .noScrollEdgeEffect()
            .onAppear {
                fetchSeason()
            }
            .onChange(of: seasonManager.selectedYear) {
                fetchSeason()
            }
            .onChange(of: seasonManager.selectedSeason) {
                fetchSeason()
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Select season", selection: $seasonManager.selectedSeason) {
                            ForEach(Season.allCases, id: \.self) { season in
                                Label(season.displayName, systemImage: season.icon)
                                    .tag(season)
                            }
                        }
                    } label: {
                        Image(systemName: seasonManager.selectedSeason.icon)
                            .foregroundColor(.accentColor)
                    }
                }
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.fixed)
                }
                ToolbarItem {
                    Menu {
                        Picker("Select year",selection: $seasonManager.selectedYear) {
                            ForEach(
                                (1980...Calendar.current.component(.year, from: Date()) + 1).reversed(),
                                id: \.self
                            ) { year in
                                Text(String(year)).tag(year)
                            }
                        }
                    } label : {
                        Text(String(seasonManager.selectedYear))
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .navigationTitle("Anime Season")
            .toolbarTitleDisplayMode(.inlineLarge)
        }
    }
    
    private func fetchSeason() {
        Task {
            alertManager.isLoading = true
            defer { alertManager.isLoading = false }
            
            do {
                let season = try await seasonController.fetchSeason(
                    year: seasonManager.selectedYear,
                    season: seasonManager.selectedSeason.rawValue
                )
                jikanSeason = season
                
                groupedMedia = Dictionary(
                    grouping: season.data,
                    by: { media in
                        if let type = media.node.mediaType?.lowercased(),
                           let animeType = MediaType.Anime(rawValue: type) {
                            return animeType
                        } else {
                            return .unknown
                        }
                    }
                )
                
            } catch {
                print("Error fetching library: \(error)")
            }
        }
    }
}

#Preview {
    SeasonView()
}
