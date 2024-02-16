# 🛒 Clothing Shop - Flutter Project 🛒

## Overview

### Features

#### Login
Before diving into our store, you need to log in. The system will verify user credentials with information stored in a .json file. If successful, you will be redirected to the main page (Page_select); otherwise, you will receive an error notification.

#### Page Select
In the Page_select, you can choose between sections for men and women. Depending on your choice, the screen will initiate in the corresponding section.

#### Sections
   
##### a. Home

The main page will feature an overview of featured products and the latest arrivals.

##### b. Shop

The shop section will display 8 products obtained from our API. Each product will be presented in a CARD with essential information: image, name, and price. Clicking on a product will open a detailed screen.

##### c. User

In the top right corner, the user's name who has logged in will be displayed, along with a profile picture. Clicking on this section will allow access to your account information.

1. Quick Navigation
The application supports quick navigation through different sections. Clicking on a specific section in the navigation menu will automatically scroll the application to the corresponding part of the page.

1. Search
A functional search feature has been implemented, allowing you to find specific products by their name. The search is performed in real-time, providing instant results as you type.

1. Categories
The store is divided into specific categories for men and women:

For Men:

- Men's Clothing
- Electronics

For Women:

- Women's Clothing
- Jewelry

## Resources

- 📘 [Flutter Documentation](https://flutter.dev/docs)
- 🎓 [Dart Programming Language](https://dart.dev)