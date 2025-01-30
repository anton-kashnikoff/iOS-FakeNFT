# FakeNFT
<img src="https://github.com/prostokot14/iOS-FakeNFT/assets/86567361/bcbff957-61a3-4f62-b2e4-13b8bd1dc976" width="250">
<img src="https://github.com/prostokot14/iOS-FakeNFT/assets/86567361/02dd7a3c-d262-465e-b9c5-acb2850c0fe7" width="250">
<img src="https://github.com/prostokot14/iOS-FakeNFT/assets/86567361/5fcb57ee-b8ca-4311-ae98-cec2ed3b7d32" width="250">
<img src="https://github.com/prostokot14/iOS-FakeNFT/assets/86567361/61b38148-95e3-4237-a08b-2128172b46cb" width="250">
<img src="https://github.com/prostokot14/iOS-FakeNFT/assets/86567361/9b9dd29b-f465-415b-b2f4-469cc64571ca" width="250">

## Application Demonstration
- [Profile](https://disk.yandex.ru/i/O7lh871n-52YTA)
- [Catalog](https://drive.google.com/file/d/1oCUCGAS-AV1a85jKYM882yX8hfsTaaPJ/view?usp=share_link)
- [Cart](https://www.loom.com/share/bdfee510348b4d65a352f450489ff228?sid=d55cb93d-956d-4d34-b427-7c93919a6028)
- [Statistics](https://disk.yandex.ru/i/9IwAXzE0i_-Tbw)
---

## FakeNFT Mobile App Requirements

### Links

[Design in Figma](https://www.figma.com/file/k1LcgXHGTHIeiCv4XuPbND/FakeNFT-(YP)?node-id=96-5542&t=YdNbOI8EcqdYmDeg-0)

## Purpose and Goals of the Application

The application helps users browse and purchase NFTs (Non-Fungible Tokens). The purchasing functionality is simulated using a mock server.

Application goals:

- Viewing NFT collections
- Viewing and purchasing NFTs (simulated)
- Viewing user rankings

## Brief Description of the Application

- The app showcases an NFT catalog structured into collections.
- Users can browse collection details, individual NFTs, and add favorites.
- Users can add and remove items from the cart and complete purchases (simulated).
- Users can view rankings and detailed user profiles.
- Users can check their profile, including favorite and owned NFTs.

Optional features include:
- Localization
- Dark mode
- Statistics via Yandex Metrics
- Authentication screen
- Onboarding screen
- App rating prompt
- Network error messages
- Custom launch screen
- Search within collections

## Catalog

### Catalog Screen
The catalog screen displays a list of available NFT collections using `UITableView`. Each collection displays:
- Cover image
- Collection name
- Number of NFTs

A sorting button allows users to reorder collections by various criteria.

A loading indicator is displayed until data is loaded.

Clicking on a collection navigates to its detail screen.

### NFT Collection Screen
Displays detailed information about a selected NFT collection, including:

- Cover image
- Collection name
- Description
- Author name (links to their website)
- A `UICollectionView` of NFTs in the collection

Clicking the author's name opens their website in a WebView.

Each NFT cell contains:
- NFT image
- NFT name
- Rating
- Price in ETH
- Favorite button (heart icon)
- Add to cart button

Clicking the heart icon toggles favorite status.

Clicking the add-to-cart button adds/removes the NFT from the cart.

Clicking an NFT cell opens its detailed screen.

### NFT Detail Screen
Implemented partially by a mentor via live coding, not required for student implementation.

## Cart

### Order Screen
Displays a `UITableView` list of NFTs in the cart, showing:
- Image
- Name
- Rating
- Price
- Remove from cart button

Clicking the remove button displays a confirmation dialog with:
- NFT image
- Removal confirmation text
- Confirm and cancel buttons

A sorting button allows sorting by various criteria.

At the bottom, a panel displays the total number of NFTs and price, along with a checkout button.

A loading indicator is displayed until data is loaded or refreshed.

### Currency Selection Screen
Allows users to select a currency for payment.

Includes:
- Header with back button
- `UICollectionView` of available payment methods, showing:
  - Logo
  - Full name
  - Abbreviation
- Terms of use link (`https://yandex.ru/legal/practicum_termsofuse/`) opening in WebView
- Payment button

If payment succeeds, a success screen appears; otherwise, an error screen appears with retry and back-to-cart buttons.

## Profile

### Profile Screen
Displays user information, including:
- Profile picture
- Name
- Description
- Table with navigation items: My NFTs, Favorite NFTs, and Website

A top-right edit button allows users to update their name, description, website, and profile picture URL (image upload not required).

### My NFTs Screen
A `UITableView` listing owned NFTs, each showing:
- NFT icon
- Name
- Author
- Price in ETH

A sorting button allows users to order NFTs by different criteria.

If no NFTs are owned, a message is displayed.

### Favorite NFTs Screen
A `UICollectionView` of liked NFTs, each showing:
- Icon
- Heart icon
- Name
- Rating
- Price in ETH

Clicking the heart removes the NFT from favorites, updating the collection.

If no favorite NFTs exist, a message is displayed.

## Statistics

### Rankings Screen
A `UITableView` listing users, displaying:
- Rank
- Avatar
- Name
- NFT count

A sorting button allows reordering by various criteria.

Clicking a user navigates to their profile screen.

### User Profile Screen
Displays:
- Profile picture
- Name
- Description
- Website link (opens in WebView)
- Link to user’s NFT collection

### User’s NFT Collection Screen
A `UICollectionView` listing a user’s NFTs, each showing:
- Icon
- Heart icon
- Name
- Rating
- Price in ETH
- Add to/remove from cart button

## Data Sorting

Sorting is available in Catalog, Cart, My NFTs, and Rankings screens. The selected order is stored locally and restored on app restart.

**Default sorting order:**
- Catalog – by NFT count
- Cart – by name
- My NFTs – by rating
- Rankings – by rating
