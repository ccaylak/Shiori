import Foundation

@MainActor final class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var showUpdatedToast = false
    @Published var showRemovedToast = false
    @Published var showAddedToast = false
    @Published var isLoading = false
    
    private init() {}
}
