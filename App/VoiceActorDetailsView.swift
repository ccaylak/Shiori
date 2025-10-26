import SwiftUI

struct VoiceActorDetailsView: View {
    
    let id: Int
    let language: String
    let image: String
    let name: String
    
    @State private var details: JikanPersonFull? = nil
    @State private var isDescriptionExpanded = false
    
    let jikanPersonFullController = JikanPersonController()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(alignment: .top, spacing: 8) {
                    AsyncImageView(imageUrl: image)
                        .frame(width: 72*1.5, height: 108*1.5)
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
                            HStack {
                                Text("Birthday")
                                    .fontWeight(.bold)
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
                                .lineLimit(7)
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
                .frame(maxHeight: 110 * 1.5)
                .padding(.horizontal)
                Divider()
                VStack(alignment: .leading) {
                    LabelWithChevron(text: "Anime appearances")
                        .padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 10) {
                            ForEach(details?.data.voices ?? [], id: \.id) { voiceactor in
                                
                                VStack {
                                    AsyncImageView(imageUrl: voiceactor.character.images.jpg.imageUrl)
                                        .frame(width: 75, height: 117)
                                        .cornerRadius(12)
                                        .strokedBorder()
                                    Text("As \(voiceactor.character.formattedName)")
                                        .font(.caption)
                                        .frame(maxWidth: 75, alignment: .leading)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if details == nil {
                Task {
                    details = try? await jikanPersonFullController.fetchPersonFull(id: id)
                }
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
