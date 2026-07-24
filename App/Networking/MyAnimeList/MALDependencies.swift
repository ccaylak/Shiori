import Observation

@MainActor
@Observable
final class MALDependencies {
    @ObservationIgnored
    let tokenStore: TokenHandler

    @ObservationIgnored
    let requestBuilder: MALRequestBuilder

    @ObservationIgnored
    let service: MALService

    @ObservationIgnored
    let userController: UserController

    @ObservationIgnored
    let animeController: AnimeController

    @ObservationIgnored
    let mangaController: MangaController

    @ObservationIgnored
    let seasonController: SeasonController

    init(tokenStore: TokenHandler) {
        let requestBuilder = MALRequestBuilder(
            tokenStore: tokenStore
        )

        let service = MALService(
            tokenStore: tokenStore
        )

        self.tokenStore = tokenStore
        self.requestBuilder = requestBuilder
        self.service = service

        self.userController = UserController(
            requestBuilder: requestBuilder,
            malService: service
        )

        self.animeController = AnimeController(
            requestBuilder: requestBuilder,
            malService: service
        )

        self.mangaController = MangaController(
            requestBuilder: requestBuilder,
            malService: service
        )

        self.seasonController = SeasonController(
            requestBuilder: requestBuilder,
            malService: service
        )
    }

    convenience init() {
        self.init(
            tokenStore: TokenHandler.shared
        )
    }
}
