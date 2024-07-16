# Viper-Movies
Viper-Movies is an iOS application that utilizes the MovieDB.org database to provide users with a comprehensive movie browsing experience. It follows the VIPER architecture pattern and includes various key features and views designed for optimal usability.

## Main Views
* **Splash Screen:** The first screen displayed when the application is started. It is displayed every time the application is opened.
* **Onboarding:** Includes application introduction, created using Page ViewController. Features:
    * The introduction screen is shown only once; it is skipped on subsequent application starts (controlled via UserDefaults).
* **Main:** The primary screen among the 3 tabs in the Tabbar, showing movies currently in theaters and their posters. Features:
    * Includes two different search functionalities: local search and service-based search.
        * Local search: Searches within currently fetched "in theaters" movies. Removes posters during the search for a more convenient view of search results.
        * Service search: Searches all movies from the database search service. A delay has been added in this search format to avoid making too many service requests. If there are more than 3 movies as a result, the "see more" button becomes active and navigates to the "SearchResultList" screen.
    * Pagination for efficient navigation through movie listings.
    * Access to the "Detail" page from both the main view movie list and search view.
* **SearchResultList:** Displays search results. Features:
    * Accessed via the "Search in All" option on the Main View.
    * Pagination for efficient navigation through movie listings.
* **Detail:** Detailed information about selected movies. Features:
    * Scroll view for seamless browsing of movie details.
    * IMDb button for direct navigation to the movie's IMDb page.
    * Lists similar movies, with navigation to their detail pages upon clicking.
    * Add to/remove from favorites functionality using UserDefaults.
* **Specials:** Section featuring curated lists such as Upcoming, Top Rated, and Popular movies. Features:
    * Selection of different lists via a picker and refreshing the list with a new service call if a different list is selected.
    * Pagination for efficient navigation through movie listings.
* **Favorites:** Lists movies saved in favorites. Features:
    * Removal capability via swipe-to-delete in the Favorites Screen.

## General Features
* **UI Design:** Utilizes ***Autolayout*** for responsive UI design.
* **Layout and Data Management:** Implements compositional layout and diffable datasource on some pages for efficient data rendering.
* **Localization:** Supports English and Turkish languages using Localizable files.
* **Network Connectivity:** Checks for internet connectivity app-wide; restricts usage without internet.
* **Loading View:** Displays a loading view until data is fetched for a smooth user experience.

## Dependencies
* **Networking**: Integrates Alamofire for networking.
* **Image Loading:** Utilizes Kingfisher for image loading.
