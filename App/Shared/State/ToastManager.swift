import Observation

@MainActor
@Observable
final class ToastManager {
    var showUpdatedToast = false
    var showRemovedToast = false
    var showAddedToast = false
    var isLoading = false
}
