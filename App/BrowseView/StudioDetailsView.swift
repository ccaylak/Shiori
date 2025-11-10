import SwiftUI

struct StudioDetailsView: View {
    
    let malId: Int
    let initialStudio: JikanAnimeStudioData?
    
    @State var studio: JikanAnimeStudioData? = nil
    
    @ObservedObject private var settingsManager: SettingsManager = .shared
    @EnvironmentObject private var alertManager: AlertManager
    
    private let jikanStudioController = JikanStudioController()
    @State var jikanAnime = JikanAnime(data: [], pagination: nil)
    @State var page = 1
    
    @State var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top, spacing: 8) {
                    AsyncImageView(imageUrl: studio?.images.jpg.imageUrl ?? "")
                        .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.width)
                        .cornerRadius(12)
                        .strokedBorder()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            HStack(alignment: .center) {
                                Image(systemName: "film.stack")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                
                                Text("\(studio?.count ?? 0) productions")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            HStack(alignment: .center) {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(Color.red)
                                    .font(.caption)
                                
                                Text("\(studio?.favorites ?? 0) favorites")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        Text(studio?.about ?? "No description available")
                            .font(.subheadline)
                            .lineLimit(5)
                            .truncationMode(.tail)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                VStack(spacing: 5){
                    LabelWithChevron(text: "Productions")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 3),
                        spacing: 25
                    ) {
                        ForEach(jikanAnime.data, id: \.id) { anime in
                            NavigationLink(destination: DetailsView(media: Media(
                                id: anime.malId,
                                title: anime.titles[0].title,
                                images: Images(large: anime.images.jpg.imageUrl),
                                type: "tv"
                            ))) {
                                VStack {
                                    AsyncImageView(imageUrl: anime.images.jpg.imageUrl)
                                        .frame(width: CoverSize.large.size.width, height: CoverSize.large.size.height)
                                        .cornerRadius(12)
                                        .strokedBorder()
                                    Text(anime.titles[0].title)
                                        .font(.caption)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                        .frame(maxWidth: CoverSize.large.size.width, alignment: .leading)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !jikanAnime.data.isEmpty,
                       let pagination = jikanAnime.pagination,
                       pagination.hasNextPage,
                       pagination.currentPage < pagination.lastVisiblePage {
                        Button {
                            Task {
                                guard !isLoading else { return  }
                                isLoading = true
                                page+=1
                                do {
                                    let newJikanAnimeResponse = try await jikanStudioController.fetchAnimesByAnimeStudio(
                                        id: malId,
                                        page: page
                                    )
                                    
                                    jikanAnime.data.append(contentsOf: newJikanAnimeResponse.data)
                                }
                                
                                isLoading = false
                            }
                        } label: {
                            Group {
                                if isLoading {
                                    ProgressView()
                                } else {
                                    Text("Load more")
                                }
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                        }
                        .borderedProminentOrGlassProminent()
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .onAppear{
                
                guard jikanAnime.data.isEmpty else { return }
                
                Task {
                    alertManager.isLoading = true
                    defer { alertManager.isLoading = false }
                    
                    if let initialStudio {
                        studio = initialStudio
                    } else {
                        studio = try? await jikanStudioController.fetchAnimeStudioById(id: malId).data
                    }
                    
                    jikanAnime = try! await jikanStudioController.fetchAnimesByAnimeStudio(
                        id: malId,
                        page: page
                    )
                }
            }
            .navigationTitle(studio?.titles[0].title ?? "")
            .navigationBarTitleDisplayMode(.inline)
        }
        .noScrollEdgeEffect()
    }
}

