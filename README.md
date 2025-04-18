# Shiori

A free and modern anime/manga application for iOS, powered by the MyAnimeList.net API.

## About the App

**MALytics** is a streamlined and visually clean reimagining of [MyAnimeList.net](https://myanimelist.net) for iOS. The app delivers a native iOS experience with a simplified and intuitive interface, designed for anime and manga enthusiasts.

## Features & Roadmap

### Version 1.0 (Core Functionality)

#### Main Views:
- **Settings View**  
  Customize the app to suit your preferences:  
  - [x] Toggle between system, dark, and light themes.  
  - [x] Choose custom accent colors.  
  - [x] Define the number of search results displayed per query.  

- **Search View**  
  Discover anime and manga with ease:  
  - [x] Switch between anime and manga search modes.  
  - [x] Filter and sort results by popularity, favorites, and other parameters.  
  - [x] Load additional results with a single button.  
  - [x] View detailed information for selected titles.  

#### Detailed Views:
- **Anime/Manga Details Page**  
  Access in-depth information about any title:  
  - [x] Cover image and description.  
  - [x] Key details, including:  
    - Media type (e.g., TV, Movie, Manga).  
    - Number of episodes or chapters.  
    - Animation studio or publisher.  
    - Release dates and runtime.  
  - [x] Genres for easy categorization.  
  - [x] Statistics, such as:  
    - Average user score.  
    - Popularity ranking.  
    - Overall rank.  
  - [x] Related content:  
    - Alternative versions, side stories, prequels, and sequels.  
  - [x] User-generated recommendations.  
  - [x] Additional images in a scrollable gallery.  
    - [ ] Optimize gallery functionality.

---

### Version 2.0 (User Profiles)

#### Main Views:
- **Login View**  
  Seamlessly integrate MyAnimeList accounts:  
  - [x] Login functionality.  
  - [x] Logout functionality.  
  - [ ] Automatic session refresh.  

- **Library View**  
  Manage your anime and manga library efficiently:  
  - [x] Toggle between anime and manga libraries.  
  - [x] Update scores, episodes, or chapters directly.  
  - [x] Delete entire entries.

#### Search View:
- **Anime/Manga Details Page**  
  Enhanced functionality:  
  - [x] Add anime or manga directly to your library.

---

### Future Plans

- **Beta Testing:**  
  Launch a beta test via TestFlight.  
- **Jikan API Integration:**  
  Add support for additional data not covered by the MAL API.  
- **Alternative Data Sources:**  
  Integrate AniList for users who prefer its platform.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Privacy Policy

**Shiori** respects your privacy and is committed to protecting your personal information. This Privacy Policy explains how we collect, use, and protect your data while using the app.

### Data Collection

**Shiori** uses the publicly available [MyAnimeList.net API](https://myanimelist.net) to fetch anime and manga data. This data includes information like titles, cover images, release dates, and other public details, which are displayed within the app. The app does not collect any personal information from its users beyond what is necessary for authentication.

### User Authentication Data

To provide personalized features (such as user libraries), **Shiori** allows users to authenticate using their MyAnimeList account. Authentication tokens (such as OAuth tokens) are stored securely on your device to manage your session and enable login/logout functionality. These tokens are not shared with third parties and are only used locally for the purpose of authenticating requests to the MyAnimeList API.

### Data Storage

All data retrieved from the MyAnimeList API (such as anime/manga information) is displayed within the app and is not stored on any external servers. The app does not store any of this data beyond the local cache used for displaying content while offline. 

Your preferences and library data (such as scores, episodes, and chapters) are also stored locally on your device. **Shiori** does not collect or store any personal data on remote servers.

### Third-Party Services

**Shiori** does not integrate third-party analytics, advertising, or data collection services. Your usage of the app is not tracked by any third-party entities.

### Data Sharing

As **Shiori** does not collect or store any personal information, there is no data shared with any third parties. The only data shared with external services is via requests made to the MyAnimeList API for fetching public data.

### Security

Your authentication tokens and other local data are securely stored on your device. The app relies on the security features provided by iOS to protect this data.

### Changes to This Privacy Policy

We may update this Privacy Policy from time to time. Any changes will be reflected within the app's Privacy Policy section.

### Contact

If you have any questions or concerns about this Privacy Policy, feel free to contact us at: [support@shioriapp.com]

---

## Final Notes

This app is not officially affiliated with MyAnimeList.net. It leverages their publicly available API to provide data and functionality.
