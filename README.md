<p align="center">
  <img
    src="https://github.com/user-attachments/assets/09c0db2e-65a0-4385-9671-4f9bb2055d8e"
    alt="VibeFinder Logo"
    width="160"
  />
</p>

<h1 align="center">VibeFinder</h1>

<p align="center">
  Mood-based discovery for movies, series, and games.
</p>

<br>

**VibeFinder** is a polished iOS application for discovering movies, TV series, and games from a short natural-language prompt.

Instead of searching by exact title, users describe the mood, format, or experience they want, and the app returns curated recommendations grouped by media category.

Example prompts:

- `a cozy game for one evening`
- `a dark detective series`
- `a movie for a rainy night`
- `slow emotional sci-fi with beautiful atmosphere`

The project was built as a complete mini-product and demonstrates modern iOS development topics: SwiftUI, Navigation, MVVM with Observation, Networking, async/await, screen states, local storage, Dependency Injection, Swift Package Manager, UIKit + SwiftUI integration, Firebase Authentication, OpenAI-powered recommendations, and automated tests.

---

## Features

### AI-Powered Prompt Search

<table>
  <tr>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 12 02 46" src="https://github.com/user-attachments/assets/2aee2cc1-3d72-4f05-b469-e3e3dc64cf4e" />
    </td>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 05 34" src="https://github.com/user-attachments/assets/931e7871-ee0b-4cbb-8aec-62c4f07ee6d6" />
    </td>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 05 25" src="https://github.com/user-attachments/assets/fce8f3cd-ac7b-4d6b-8dcc-2f35d46df0cd" />
    </td>
  </tr>
</table>

<div align="center">
  
https://github.com/user-attachments/assets/435c3e13-e530-4b9d-8085-f442294f2211

</div>

Users can enter a short prompt describing what they want to watch or play. VibeFinder uses an LLM-powered recommendation flow to understand the request and return structured media suggestions.

The app can understand category intent. For example, if the prompt asks for a game, the result focuses on games; if it asks for a movie or series, the app prioritizes that media type.

### Categorized Recommendation Results

<table>
  <tr>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 10 13" src="https://github.com/user-attachments/assets/4835ade2-7a86-458f-8745-afe04bc11ce5" />
    </td>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 10 21" src="https://github.com/user-attachments/assets/d08fdaa5-bab4-42c5-bcba-a5316e39c785" />
    </td>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 10 26" src="https://github.com/user-attachments/assets/015e6914-8d15-4e76-9adc-d058cfcb290f" />
    </td>
  </tr>
</table>

<div align="center">
  
https://github.com/user-attachments/assets/9e9e0250-e6c1-4d07-a3d4-9e56f2596958

</div>

Recommendations are displayed as clean media cards grouped by category.

Each card includes:

- Poster artwork
- Title
- Media category
- Genre
- Year
- Short description
- Match level
- Favorite button

### Media Details

<table>
  <tr>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 01 49" src="https://github.com/user-attachments/assets/3eefefb8-30fb-4731-85e3-975a82d8bdfa" />
    </td>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 02 04" src="https://github.com/user-attachments/assets/f35efaad-c764-4b6a-b983-dc4e3ba35358" />
    </td>
    <td width="33%">
       <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 02 15" src="https://github.com/user-attachments/assets/0e4bb061-a608-438c-a45a-38cce43bb387" />
    </td>
  </tr>
</table>

<div align="center">
  
https://github.com/user-attachments/assets/10f28a39-8a6d-4bf7-a3c0-e63c21b97750

</div>

Each recommendation has a detailed screen with richer information about the selected media item.

The detail screen includes:

- Large poster image
- Title and metadata
- Category, genre, and year
- Match explanation
- Description
- Platforms or streaming options
- Mood tags
- Duration or length
- Favorite action

### Favorites

<p align="center">
  <img
    src="https://github.com/user-attachments/assets/bc733e35-2271-4cc7-8feb-3079973aa097"
    alt="Screenshot"
    width="350"
  />
</p>

<div align="center">
  
https://github.com/user-attachments/assets/845165ee-cdac-4049-ad89-c31734f050b1

</div>

Users can save recommendations to Favorites and return to them later.

Favorites are persisted locally and restored after app restart.

### Favorites Search, Filtering, and Sorting

<table>
  <tr>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 17 41" src="https://github.com/user-attachments/assets/144b4569-e006-46bd-a66d-a17291efa2c5" />
    </td>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 17 46" src="https://github.com/user-attachments/assets/18382622-9d63-45cb-9056-e7468b751a9c" />
    </td>
    <td width="33%">
       <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 17 56" src="https://github.com/user-attachments/assets/f5bf2b75-fce0-4ea4-93af-b1d9c2c372e3" />
    </td>
  </tr>
</table>

<div align="center">
  
https://github.com/user-attachments/assets/3c04c4cd-15bd-442f-b114-5b4e01f2a241

</div>

The Favorites tab supports:

- Search by title, genre, category, description, and mood
- Category filtering
- Sorting by title
- Sorting by year
- Detail navigation
- Favorite removal

### Search History

<p align="center">
  <img
    src="https://github.com/user-attachments/assets/f078419f-3f14-4559-b5c7-3610e12ff026"
    alt="Screenshot"
    width="350"
  />
</p>

<div align="center">

https://github.com/user-attachments/assets/45990410-ae32-46a7-a77f-ade62d5077ee

</div>

Every successful prompt is saved into local search history.

History records allow users to revisit previous prompts and their generated recommendations.

### History Search, Sorting, Restore, and Delete

<table>
  <tr>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 24 24" src="https://github.com/user-attachments/assets/468ef0bb-ad1b-4c08-8dee-67788494aba7" />
    </td>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 24 38" src="https://github.com/user-attachments/assets/4a855288-ff92-41ee-8c85-110c9321430e" />
    </td>
    <td width="33%">
       <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 25 00" src="https://github.com/user-attachments/assets/ae13fde5-4964-4de5-948b-d7214be4c662" />
    </td>
  </tr>
</table>

<div align="center">
  
https://github.com/user-attachments/assets/8fd5ec97-c8df-417b-82f8-a6682db2ba12

</div>

The History tab supports:

- Search through previous prompts and results
- Sorting
- Opening history details
- Restoring a prompt back to Search
- Swipe-to-delete
- Local persistence

### Authentication

<table>
  <tr>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 27 17" src="https://github.com/user-attachments/assets/789b4ef2-f2aa-4845-968b-be4d38962ccf" />
    </td>
    <td width="33%">
      <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 27 24" src="https://github.com/user-attachments/assets/3bbacc22-79af-49b0-b9d1-7202454996f5" />
    </td>
    <td width="33%">
       <img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-06-01 at 11 28 08" src="https://github.com/user-attachments/assets/3f2f8cb6-ed3b-48c0-86fe-356c805f2327" />
    </td>
  </tr>
</table>

<div align="center">
  
https://github.com/user-attachments/assets/39edaf65-7b03-48ad-beca-ab9eb1a88eb5

</div>

The app includes Firebase Authentication.

Authentication supports:

- Sign in
- Account creation
- Password confirmation
- Session restore
- Sign out

### UIKit Share Screen

<p align="center">
  <img
    src="https://github.com/user-attachments/assets/598f5145-5d2a-43be-aadc-e7df13289c5a"
    alt="Screenshot"
    width="350"
  />
</p>

<div align="center">
  
https://github.com/user-attachments/assets/bbe32b7f-4687-4ac0-be82-b0d833128d4a

</div>

VibeFinder includes UIKit integration inside SwiftUI through a custom share experience.

This demonstrates how UIKit can be embedded into a SwiftUI app when a more customized native interaction is needed.

### Empty, Loading, Error, and Content States

The app uses explicit screen states to make asynchronous flows predictable and user-friendly.

Supported states:

- Loading
- Empty
- Error
- Content

---

## Architecture

VibeFinder follows **MVVM + Observation**.

The app is separated into clear layers:

```text
VibeFinder
├── App
├── DI
├── DTO
│   ├── OpenAI
│   ├── RAWG
│   └── TMDB
├── Models
├── Networking
├── Services
│   ├── Artwork
│   │   └── Cache
│   ├── Auth
│   └── Recommendations
├── Storage
├── UIKit
├── ViewModels
└── Views
    ├── Components
    └── Screens
```

### View Layer

SwiftUI views are responsible for rendering UI and forwarding user actions.

Examples:

- `SearchScreen`
- `FavoritesScreen`
- `HistoryScreen`
- `HistoryDetailScreen`
- `DetailScreen`
- `AuthScreen`
- `ProfileScreen`

Reusable UI is extracted into components:

- `MediaCardView`
- `ArtworkView`
- `MatchBadge`
- `PromptInputView`
- `StateViews`
- `DetailBlock`
- `DetailChips`
- `FlowLayout`
- `CategoryStripView`

### ViewModel Layer

ViewModels own screen state and user scenarios.

Main ViewModels:

- `SearchViewModel`
- `LibraryViewModel`
- `AuthViewModel`
- `ArtworkViewModel`

The project uses the Observation framework with `@Observable`. UI-related state is updated from main-actor ViewModels.

### Service Layer

Networking and external integrations are isolated in service types.

Examples:

- `OpenAIMediaSuggestionService`
- `RemoteMediaArtworkService`
- `URLSessionImageDataLoadingService`
- `FirebaseAuthService`

Services are accessed through protocols, which makes the app easier to test and easier to switch between real and mock implementations.

### Storage Layer

Local persistence is isolated in a dedicated storage layer.

The app uses:

- `UserLibraryStorage` protocol
- `UserDefaultsLibraryStorage` real implementation
- `InMemoryLibraryStorage` mock/test implementation

Favorites and search history are restored after app restart.

### Dependency Injection

Dependencies are created in `AppContainer` and injected into ViewModels.

This keeps Views and ViewModels independent from concrete service implementations and supports live, preview, and test configurations.

---

## Technologies Used

- Swift
- SwiftUI
- Observation framework
- NavigationStack
- NavigationPath
- TabView
- async/await
- Task
- TaskGroup
- actors
- URLSession
- Codable
- UserDefaults
- Firebase Authentication
- OpenAI Swift SDK
- TMDB API
- RAWG API
- Swift Package Manager
- UIKit integration with `UIViewRepresentable`
- UIKit integration with `UIViewControllerRepresentable`
- Swift Testing

---

## External APIs

### OpenAI

OpenAI is used to understand the user's natural-language prompt and generate structured media recommendations.

### TMDB

TMDB is used to fetch poster artwork for:

- Movies
- TV series

### RAWG

RAWG is used to fetch artwork for:

- Games

### Firebase

Firebase Authentication is used for account creation, sign in, session restore, and sign out.

---

## Networking

The app includes a dedicated networking flow based on `URLSession`.

Networking features:

- async/await requests
- Codable DTO decoding
- HTTP status code validation
- Error handling through `NetworkError`
- Poster URL fetching from TMDB and RAWG
- Image data loading and caching

Example status code validation:

```swift
guard (200...299).contains(httpResponse.statusCode) else {
    throw NetworkError.badStatusCode(httpResponse.statusCode)
}
```

---

## Local Storage

The app stores user data locally:

- Favorite media items
- Search history records

The real storage implementation uses `UserDefaults`, while tests and previews use an in-memory storage implementation.

This keeps persistence logic outside the View and ViewModel layers.

---

## UIKit + SwiftUI Integration

The project includes UIKit inside SwiftUI.

UIKit integrations:

- Prompt input through `UIViewRepresentable`
- Custom media sharing screen through `UIViewControllerRepresentable`

---

## Testing

The project includes unit tests for ViewModels, Storage, and Service logic.

Test coverage includes:

- Successful data loading
- Error handling
- Empty state
- Search and filtering
- Sorting
- Adding favorites
- Removing favorites
- Saving data
- Restoring data from storage
- Image loading service behavior
- Image cache behavior
- Artwork ViewModel behavior

Mocks and test doubles are used to isolate units under test.

---

## How to Run the Project

### 1. Clone the Repository

```sh
git clone <repository-url>
cd VibeFinder
```

### 2. Open the Project

```sh
open VibeFinder.xcodeproj
```

### 3. Add API Keys

Create a local secrets file:

```sh
cp Config/Secrets.example.xcconfig Config/Secrets.xcconfig
```

Open `Config/Secrets.xcconfig` and add your keys:

```xcconfig
OPENAI_API_KEY = your_openai_api_key
TMDB_API_KEY = your_tmdb_api_key
RAWG_API_KEY = your_rawg_api_key
```

`Secrets.xcconfig` is ignored by Git and should not be committed.

### 4. Add Firebase Configuration

Download `GoogleService-Info.plist` from Firebase Console and add it to the `VibeFinder` app target.

### 5. Run the App

Select a simulator or a real iPhone in Xcode and press:

```text
Cmd + R
```

---

## How to Run Tests

Run tests from Xcode:

```text
Cmd + U
```

Or run the unit test target from Terminal:

```sh
xcodebuild \
  -project VibeFinder.xcodeproj \
  -scheme VibeFinder \
  -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.0' \
  -only-testing:VibeFinderTests \
  test
```

---

## LLM Tools Used

The following LLM-based tools were used during development:

- ChatGPT and Codex for planning, architecture review, refactoring support, debugging support, test planning, and README generation

- OpenAI API / OpenAI Swift SDK inside the app for prompt understanding and recommendation generation

LLM assistance was used to support development, while architecture decisions, implementation details, testing structure, and final integration were reviewed and adapted manually.

---

## Full Demo Video

<div align="center">
  
https://github.com/user-attachments/assets/fbc204cd-0cc3-4408-9d69-a0b8349b8254

</div>

---

## Project Status

VibeFinder is a complete educational iOS mini-product built to demonstrate modern SwiftUI app development with real networking, local persistence, dependency injection, UIKit integration, authentication, LLM-powered recommendations, and automated tests.

---

## Possible Improvements

Future versions of VibeFinder could include:

### Personalized Recommendations

Add user preference learning based on saved favorites, skipped recommendations, and search history. This would allow the app to improve suggestions over time.

### User-Specific Cloud Storage

Move favorites and search history from local-only storage to cloud storage, so users can sync their data across multiple devices.

### Recommendation Feedback

Allow users to mark recommendations as:

- Perfect match
- Not relevant
- Already watched / played
- Not interested

This feedback could be used to refine future LLM prompts.

### Offline Mode

Cache previous recommendations and posters more deeply, so users can browse saved favorites and history without an internet connection.

### Push Notifications

Add optional reminders for saved recommendations, such as "watch later" or "play this weekend".

### Richer Detail Pages

Improve detail screens with ratings, trailers, screenshots, cast information, similar titles, and external links.
