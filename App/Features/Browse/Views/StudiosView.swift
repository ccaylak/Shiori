import SwiftUI

struct StudiosView: View {
    
    private let jikanStudioController = JikanStudioController()
    
    @StateObject private var resultManager: ResultManager = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    @State var jikanStudio = JikanStudio(data: [], pagination: nil)
    @State var searchText: String = ""
    
    @State var studioPage = 1
    @State var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(jikanStudio.data, id: \.malId) { studio in
                    NavigationLink(destination: StudioDetailsView(malId: studio.malId, initialStudio: studio)) {
                        HStack {
                            AsyncImageView(imageUrl: studio.images.jpgImage.baseImage)
                                .frame(width: CoverSize.small.size.width, height: CoverSize.small.size.width)
                                .cornerRadius(12)
                                .strokedBorder()
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(studio.englishTitle)
                                    .bold()
                                
                                Spacer()
                                
                                Label("\(studio.favorites) favorites", systemImage: "heart")
                                    .font(.caption)
                                
                                Label("\(studio.count) anime", systemImage: "film.stack")
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                if !jikanStudio.data.isEmpty,
                   let pagination = jikanStudio.pagination,
                   pagination.hasNextPage,
                   pagination.currentPage < pagination.lastVisiblePage
                {
                    Button{
                        Task {
                            guard !isLoading else { return  }
                            isLoading = true
                            studioPage+=1
                            do {
                                let newJikanStudioResponse = try await jikanStudioController.fetchAnimeStudios(
                                    searchTerm: searchText,
                                    order: resultManager.animeStudioOption.rawValue,
                                    sort: resultManager.animeStudioSort.rawValue,
                                    page: studioPage
                                )
                                
                                jikanStudio.append(newJikanStudioResponse.data)
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
                    .listRowInsets(EdgeInsets())
                }
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Choose a sort option", selection: $resultManager.animeStudioOption){
                            ForEach(StudioSortOption.allCases, id: \.self) { option in
                                Label(option.displayName, systemImage: option.icon)
                                    .tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: resultManager.animeStudioOption.icon)
                            .foregroundColor(.accentColor)
                    }
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarSpacer(.fixed)
                }
                
                ToolbarItem {
                    Menu {
                        Picker("Choose a sort order", selection: $resultManager.animeStudioSort){
                            ForEach(SortDirection.allCases, id: \.self) { direction in
                                Label(direction.displayName, systemImage: direction.icon)
                                    .tag(direction)
                            }
                        }
                    }  label: {
                        Image(systemName: resultManager.animeStudioSort.icon)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            
        }
        .listRowSpacing(10)
        .contentMargins(.top, 0)
        .navigationTitle("Anime Studios")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            
            guard jikanStudio.data.isEmpty else { return }
            
            Task {
                jikanStudio = try await jikanStudioController.fetchAnimeStudios(
                    searchTerm: searchText,
                    order: resultManager.animeStudioOption.rawValue,
                    sort: resultManager.animeStudioSort.rawValue,
                    page: studioPage
                )
            }
        }
        .onSubmit(of: .search) {
            Task {
                jikanStudio = try await jikanStudioController.fetchAnimeStudios(
                    searchTerm: searchText,
                    order: resultManager.animeStudioOption.rawValue,
                    sort: resultManager.animeStudioSort.rawValue,
                    page: studioPage
                )
            }
        }
        .onChange(of: resultManager.animeStudioOption) {
            Task {
                jikanStudio = try await jikanStudioController.fetchAnimeStudios(
                    searchTerm: searchText,
                    order: resultManager.animeStudioOption.rawValue,
                    sort: resultManager.animeStudioSort.rawValue,
                    page: studioPage
                )
            }
        }
        .onChange(of: resultManager.animeStudioSort) {
            Task {
                jikanStudio = try await jikanStudioController.fetchAnimeStudios(
                    searchTerm: searchText,
                    order: resultManager.animeStudioOption.rawValue,
                    sort: resultManager.animeStudioSort.rawValue,
                    page: studioPage
                )
            }
        }
    }
    
}
