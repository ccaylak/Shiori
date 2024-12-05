import SwiftUI

struct LibraryView: View {
    
    @State private var mangaProgressSelection = MangaProgressStatus.all
    
    @AppStorage("mediaType") private var mediaType = MediaType.manga
    
    @State private var mangaLibraryStatus = MangaLibraryStatus(data: [])
    
    @State private var selectedMedia: MediaNode?
    
    @State private var status = MangaProgressStatus.reading
    @State private var score: Int = 1
    @State private var progress: Int = 1
    
    @State private var showAlert = false
    
    @Environment(\.dismiss) private var dismiss
    
    private var profileController = ProfileController()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if (mediaType == .manga) {
                        Picker("Filter by", selection: $mangaProgressSelection) {
                            ForEach(MangaProgressStatus.allCases, id: \.self) { mangaSelection in
                                Text(mangaSelection.displayName)
                            }
                        }
                        .onAppear {
                            Task {
                                mangaLibraryStatus = try await profileController.fetchMangaLibrary(status: mangaProgressSelection.rawValue)
                            }
                        }
                        .onChange(of: mangaProgressSelection) {
                            Task {
                                mangaLibraryStatus = try await profileController.fetchMangaLibrary(status: mangaProgressSelection.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        ForEach(mangaLibraryStatus.data, id: \.self) { manga in
                            Button(action: {
                                selectedMedia = manga
                            }) {
                                LibraryMediaView(
                                    title: manga.node.title,
                                    image: manga.node.images.large,
                                    releaseYear: String(manga.node.startDate?.prefix(4) ?? "Unknown"),
                                    type: manga.node.type ?? "Unknown",
                                    progressStatus: mangaProgressSelection.displayName,
                                    completedUnits: manga.listStatus?.readChapters ?? 0,
                                    totalUnits: manga.node.numberOfChapters ?? 0
                                )
                            }
                        }
                    }
                }
            }
            .scrollClipDisabled()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Menu("Selection") {
                        Picker("Manga or Anime", selection: $mediaType) {
                            Label("Manga", systemImage: "book").tag(MediaType.manga)
                            Label("Anime", systemImage: "tv").tag(MediaType.anime)
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .padding()
            .sheet(item: $selectedMedia) { media in
                NavigationView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack{
                            AsyncImageView(imageUrl: media.node.images.large)
                                .frame(height: 180)
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Section(header: Text("Status").font(.subheadline).bold()) {
                                    Picker("Status", selection: $status) {
                                        ForEach(MangaProgressStatus.allCases, id: \.self) { mangaSelection in
                                            Text(mangaSelection.displayName)
                                        }
                                    }
                                }

                                Section(header: Text("Rating").font(.subheadline).bold()) {
                                    Picker("Rating", selection: $score) {
                                        ForEach(1...10, id: \.self) { rating in
                                            Text("\(rating)")
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                }

                                Section(header: Text("Chapters").font(.subheadline).bold()) {
                                    Picker("Chapters", selection: $progress) {
                                        ForEach(1...10, id: \.self) { chapter in
                                            Text("\(chapter)")
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                }
                            }.padding(.horizontal)
                        }
                    }
                    .padding()
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Save") {
                                dismiss()
                            }
                        }
                        ToolbarItem(placement: .principal) {
                            Text("Edit Entry")
                                .font(.headline)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: {
                                showAlert = true
                            }) {
                                Label("Delete", systemImage: "trash")
                                    .foregroundColor(.red)
                            }
                            .alert("Delete library entry", isPresented: $showAlert) {
                                Button("Delete", role: .destructive) {
                                    Task {
                                        try await profileController.deleteMangaListItem(mangaId: media.node.id)
                                        mangaLibraryStatus = try await profileController.fetchMangaLibrary(status: mangaProgressSelection.rawValue)
                                        showAlert = false
                                        selectedMedia = nil
                                    }
                                }
                                Button("Cancel", role: .cancel) {}
                            } message: {
                                Text("Are you sure you want to delete \(media.node.title) from your library?")
                            }
                        }
                    }
                    .presentationDetents([.medium, .large])
                    .presentationBackgroundInteraction(.disabled)
                    .presentationBackground(.regularMaterial)
                }
            }

            .onChange(of: selectedMedia) {
                score = selectedMedia?.listStatus?.rating ?? 0
                progress = selectedMedia?.listStatus?.rating ?? 0
                status = MangaProgressStatus(rawValue: selectedMedia?.listStatus?.status ?? "") ?? MangaProgressStatus.reading
        
            }
        }
    }
}
#Preview {
    LibraryView()
}
