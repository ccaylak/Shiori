import SwiftUI

@main
struct ShioriApp: App {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    private var tokenHandler: TokenHandler = .shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    if isFirstLaunch {
                        tokenHandler.revokeToken()
                        isFirstLaunch = false
                    }
                }
        }
    }
}
