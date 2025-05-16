import Foundation

@MainActor final class AlertManager: ObservableObject {
    static let shared = AlertManager()
    
    @Published var showUpdatedAlert = false
    @Published var showRemovedAlert = false
    @Published var showAddedAlert = false
    @Published var isLoading = false
    
    private init() {}
}

