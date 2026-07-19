# Shiori

Shiori is a free and modern anime and manga tracking app for iOS.

[![Download on the App Store](https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83)](https://apps.apple.com/app/shiori-for-myanimelist/id6738731291)

The app provides a native iOS experience with a clean and intuitive interface, designed for anime and manga fans. It uses the public [MyAnimeList API](https://myanimelist.net/apiconfig/references/api/v2) to display anime and manga information in a simplified and user-friendly way.

Shiori is independently developed and is not affiliated with, endorsed by, or officially connected to MyAnimeList.net.

## License

This project is licensed under the [Apache License 2.0](LICENSE).

## Privacy Policy

Shiori respects your privacy and is committed to protecting your personal information.

### Data Collection

Shiori uses the public MyAnimeList API to fetch anime and manga data, such as titles, synopses, cover images, scores, rankings, genres, studios, authors, and related media information.

The app collects limited, anonymized usage analytics to improve features, stability, and the overall user experience. No personal data is used for advertising.

### User Authentication

Users may log in with their MyAnimeList account to access personal library features.

Authentication is handled through OAuth. Access tokens are stored securely on your device and are only used to authenticate requests to MyAnimeList.

### Data Storage

Shiori does not operate its own external servers or store user data on servers controlled by the app.

Your app preferences are stored locally on your device. Anime and manga data is retrieved from external APIs when needed, so most features require an active internet connection.

### Third-Party Services

Shiori uses the official MyAnimeList API for anime and manga data, user authentication, and library-related features.

In some cases, Shiori may use [Jikan](https://jikan.moe), an unofficial MyAnimeList API, to retrieve missing or additional public anime and manga information.

Shiori uses [TelemetryDeck](https://telemetrydeck.com) for limited, privacy-friendly, anonymized analytics to help improve the app. No advertising tools are used.

### Data Sharing

Shiori communicates with external anime and manga data services, such as MyAnimeList and Jikan, to retrieve app content and, when authenticated, update library-related data.

Limited, anonymized usage analytics are processed through TelemetryDeck to improve the app. Shiori does not sell personal data and does not use personal data for advertising.

### Security

Sensitive authentication data, such as MyAnimeList access tokens, is stored securely on your device using the iOS Keychain. Shiori uses the open-source [KeychainSwift](https://github.com/evgenyneu/keychain-swift) library to access the Keychain.
