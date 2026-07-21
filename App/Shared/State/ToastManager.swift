import Observation

@MainActor
@Observable
final class ToastManager {
    var isLoading = false
    
    var showUpdatedToast = false
    var showRemovedToast = false
    var showAddedToast = false
    
    var showNoConnectionToast = false
    var showWeakConnectionToast = false
}
