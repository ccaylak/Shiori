import SwiftUI

struct StudiosView: View {
    
    enum SortOrder: String, CaseIterable {
        case def = ""
        case asc, desc
        
        var displayName: String {
            switch self {
            case .def: String(localized: "Default")
            case .asc: String(localized: "Ascending")
            case .desc: String(localized: "Descending")
            }
        }
        
        var icon: String {
            switch self {
            case .def: return "arrow.up.arrow.down"
            case .asc: return "arrow.up"
            case .desc: return "arrow.down"
            }
        }
    }
    
    enum SortOption: String, CaseIterable {
        case malId = "mal_id"
        case count, favorites, established
        
        var displayName: String {
            switch self {
            case .malId: String(localized: "Id")
            case .count: String(localized: "Productions")
            case .favorites: String(localized: "Favorites")
            case .established: String(localized: "Established")
            }
        }
        
        var icon: String {
            switch self {
            case .malId: return "barcode"
            case .count: return "chart.bar"
            case .favorites: return "heart"
            case .established: return "calendar"
            }
        }
    }
    
    private let jikanStudioController = JikanStudioController()
    
    @StateObject private var resultManager: ResultManager = .shared
    @ObservedObject private var settingsManager: SettingsManager = .shared
    
    @State var jikanAnimeStudio = JikanAnimeStudio(data: [], pagination: nil)
    @State var searchText: String = ""
    
    @State var studioPage = 1
    @State var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(jikanAnimeStudio.data, id: \.malId) { studio in
                    NavigationLink(destination: StudioDetailsView(malId: studio.malId, initialStudio: studio)) {
                        HStack {
                            AsyncImageView(imageUrl: studio.images.jpg.imageUrl)
                                .frame(width: CoverSize.small.size.width, height: CoverSize.small.size.width)
                                .cornerRadius(12)
                                .strokedBorder()
                            
                            VStack(alignment: .leading, spacing: 3) {
                                Text(studio.titles[0].title)
                                    .bold()
                                
                                Spacer()
                                
                                Label("\(studio.favorites) favorites ", systemImage: "heart")
                                    .font(.caption)
                                
                                Label("\(studio.count) anime", systemImage: "film.stack")
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                if !jikanAnimeStudio.data.isEmpty,
                   let pagination = jikanAnimeStudio.pagination,
                   pagination.hasNextPage,
                   pagination.currentPage < pagination.lastVisiblePage
                {
                    Button{
                        Task {
                            guard !isLoading else { return  }
                            isLoading = true
                            studioPage+=1
                            do {
                                let newJikanAnimeStudioResponse = try await jikanStudioController.fetchAnimeStudios(
                                    searchTerm: searchText,
                                    order: resultManager.animeStudioOption.rawValue,
                                    sort: resultManager.animeStudioSort.rawValue,
                                    page: studioPage
                                )
                                
                                jikanAnimeStudio.data.append(contentsOf: newJikanAnimeStudioResponse.data)
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
                            ForEach(StudiosView.SortOption.allCases, id: \.self) { option in
                                Label(option.displayName, systemImage: option.icon)
                                    .tag(option)
                            }
                        }
                    } label : {
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
                            ForEach(StudiosView.SortOrder.allCases, id: \.self) { order in
                                Label(order.displayName, systemImage: order.icon)
                                    .tag(order)
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
        .contentMargins(.top, 0 )
        .navigationTitle("Anime studios")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            
            guard jikanAnimeStudio.data.isEmpty else { return }
            
            Task {
                jikanAnimeStudio = try await jikanStudioController.fetchAnimeStudios(
                    searchTerm: searchText,
                    order: resultManager.animeStudioOption.rawValue,
                    sort: resultManager.animeStudioSort.rawValue,
                    page: studioPage
                )
            }
        }
        .onSubmit(of: .search) {
            Task {
                jikanAnimeStudio = try await jikanStudioController.fetchAnimeStudios(
                    searchTerm: searchText,
                    order: resultManager.animeStudioOption.rawValue,
                    sort: resultManager.animeStudioSort.rawValue,
                    page: studioPage
                )
            }
        }
        .onChange(of: resultManager.animeStudioOption) {
            Task {
                jikanAnimeStudio = try await jikanStudioController.fetchAnimeStudios(
                    searchTerm: searchText,
                    order: resultManager.animeStudioOption.rawValue,
                    sort: resultManager.animeStudioSort.rawValue,
                    page: studioPage
                )
            }
        }
        .onChange(of: resultManager.animeStudioSort) {
            Task {
                jikanAnimeStudio = try await jikanStudioController.fetchAnimeStudios(
                    searchTerm: searchText,
                    order: resultManager.animeStudioOption.rawValue,
                    sort: resultManager.animeStudioSort.rawValue,
                    page: studioPage
                )
            }
        }
    }
    
}
