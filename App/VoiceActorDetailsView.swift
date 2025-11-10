import SwiftUI

struct VoiceActorDetailsView: View {
    
    let id: Int
    let language: String
    let image: String
    let name: String
    
    @State private var details: JikanPersonFull? = nil
    @State private var isDescriptionExpanded = false
    
    @EnvironmentObject private var alertManager: AlertManager
    
    let jikanPersonFullController = JikanPersonController()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                HStack(alignment: .top, spacing: 8) {
                    AsyncImageView(imageUrl: image)
                        .frame(width: CoverSize.extraLarge.size.width, height: CoverSize.extraLarge.size.height)
                        .cornerRadius(12)
                        .strokedBorder()
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            VStack {
                                HStack(alignment: .center, spacing: 2) {
                                    if let givenName = details?.data.givenName, !givenName.isEmpty {
                                        Text(givenName)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }
                                    
                                    if let familyName = details?.data.familyName, !familyName.isEmpty {
                                        Text(familyName)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.secondary)
                                            .font(.caption)
                                    }
                                }
                            }
                            Spacer()
                            
                            if let favorites = details?.data.favorites, favorites > 0 {
                                HStack(alignment: .center) {
                                    Image(systemName: "heart")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                    
                                    Text("\(favorites) favorites")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        if let birthDate = details?.data.birthday,
                           !birthDate.isEmpty,
                           let formattedDate = formattedBirthDate(from: birthDate) {
                            HStack(alignment: .center) {
                                Image(systemName: "birthday.cake")
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                Text(formattedDate)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(details?.data.about ?? "")
                                .font(.subheadline)
                                .lineLimit(9)
                                .truncationMode(.tail)
                            Button(isDescriptionExpanded ? "Show less" : "Show more") {
                                isDescriptionExpanded.toggle()
                            }
                            .font(.caption)
                            .sheet(isPresented: $isDescriptionExpanded) {
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        Text(details?.data.about ?? "")
                                            .font(.subheadline)
                                    }
                                    .padding()
                                    .presentationDetents([.large, .medium])
                                    .presentationBackgroundInteraction(.automatic)
                                }
                                .scrollIndicators(.automatic)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxHeight: CoverSize.extraLarge.size.height)
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    LabelWithChevron(text: String(localized: "Characters"))
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            ForEach(details?.data.voices ?? [], id: \.id) { voiceactor in
                                NavigationLink(destination: CharacterDetailsView(character: Character(metaData: MetaData(
                                    malId: voiceactor.character.malId,
                                    name: voiceactor.character.formattedName,
                                    images: CharacterImage(jpg: CharacterJPG(imageUrl: voiceactor.character.images.jpg.imageUrl))
                                )), role: "")) {
                                    VStack {
                                        AsyncImageView(imageUrl: voiceactor.character.images.jpg.imageUrl)
                                            .frame(width: CoverSize.medium.size.width, height: CoverSize.medium.size.height)
                                            .cornerRadius(12)
                                            .strokedBorder()
                                        Text("\(voiceactor.character.formattedName)")
                                            .font(.caption)
                                            .frame(maxWidth: CoverSize.medium.size.width, alignment: .leading)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: URL(string: details?.data.url ?? "myanimelist.net")!) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .noScrollEdgeEffect()
        .background(Color(.systemGroupedBackground))
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            
            Task {
                alertManager.isLoading = true
                defer { alertManager.isLoading = false }
                details = try? await jikanPersonFullController.fetchPersonFull(id: id)
            }
            
        }
    }
    
    func formattedBirthDate(from isoDateString: String) -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withFullDate]
        
        guard let date = isoFormatter.date(from: isoDateString) else {
            return nil
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale.current
        displayFormatter.dateFormat = "dd.MM.yyyy"  // z.B. 30.04.2023
        
        return displayFormatter.string(from: date)
    }
}
