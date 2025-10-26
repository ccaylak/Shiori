import SwiftUI

struct SeasonView: View {
    
    private let seasonController = SeasonController()
    @ObservedObject private var seasonManager: SeasonManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    
    @State private var jikanSeason = SeasonResponse(data: [])
    
    @State private var groupedMedia: [FormatType.Anime: [MediaNode]] = [:]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(FormatType.Anime.allCases, id: \.self) { animeType in
                    if let items = groupedMedia[animeType], !items.isEmpty {
                        VStack(alignment: .leading, spacing: 5) {
                        
                            HStack(alignment: .center, spacing: 3) {
                                Text(LocalizedStringKey(animeType.displayName))
                                    .font(.title3)
                                    .bold()
                                
                                Image(systemName: "chevron.forward")
                                    .foregroundStyle(.secondary)
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 10) {
                                    ForEach(items, id: \.node.id) { anime in
                                        NavigationLink(destination: DetailsView(media: anime.node)) {
                                            VStack(spacing: 3) {
                                                AsyncImageView(imageUrl: anime.node.getCover)
                                                    .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                                    .cornerRadius(12)
                                                    .strokedBorder()
                                                
                                                Text(anime.node.getTitle)
                                                    .font(.caption)
                                                    .lineLimit(2)
                                                    .frame(maxWidth: CoverSize.large.size.width, alignment: .leading)
                                            }
                                            .overlay(alignment: .topTrailing) {
                                                if anime.node.getEntryStatus != .unknown {
                                                    anime.node.getEntryStatus.libraryIcon
                                                        .padding(6)
                                                        .background(Material.ultraThin)
                                                        .cornerRadius(12)
                                                }
                                            }
                                        }.buttonStyle(.plain)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 4)
                    }
                }
            }
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
                ToolbarItem(placement: .topBarLeading) {
                    Picker("Please choose an anime season", selection: $seasonManager.selectedSeason) {
                        ForEach(Season.allCases, id: \.self) { season in
                            Label(season.displayName, systemImage: season.icon)
                                .tag(season)
                        }
                    }
                    .fixedSize()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Picker("Please choose an anime season year", selection: $seasonManager.selectedYear) {
                        ForEach(1980...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .fixedSize()
                }
            }
            .navigationTitle("Anime season")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @State private var lastLoadedYear: Int?
    @State private var lastLoadedSeason: Season?
    
    private func fetchSeason() {
        // Prüfen, ob die aktuelle Season schon geladen ist
        guard lastLoadedYear != seasonManager.selectedYear ||
                lastLoadedSeason != seasonManager.selectedSeason else {
            return
        }
        
        Task {
            alertManager.isLoading = true
            do {
                let season = try await seasonController.fetchSeason(
                    year: seasonManager.selectedYear,
                    season: seasonManager.selectedSeason.rawValue
                )
                jikanSeason = season
                
                groupedMedia = Dictionary(
                    grouping: season.data,
                    by: { media in
                        if let type = media.node.type?.lowercased(),
                           let animeType = FormatType.Anime(rawValue: type) {
                            return animeType
                        } else {
                            return .unknown
                        }
                    }
                )
                
                lastLoadedYear = seasonManager.selectedYear
                lastLoadedSeason = seasonManager.selectedSeason
                
            } catch {
                print("Error fetching library: \(error)")
            }
            alertManager.isLoading = false
        }
    }
}

#Preview {
    SeasonView()
}
