# PhotoGallery
A app where images fetch from API and implemented like/dislike images feature which is manage by core data.

# Features 
 - Like and Dislike the image which is managed by the core data.
 - Save the specific image to the Photos App.
 - Delete the images.
 - Pull to refresh at home screen.
 - See only Liked images. 


# Description 
About Home Screen:- 
1. User can use like and dislike functionality by tap on like button(❤️) toggle nature.
2. User can user like and dislike functionality by swipe left for unlike the image and right to like the image on tableView Cell.
3. User can pull to refresh the list. (Getting same data by API if user pulls to refresh)
4. User can navigate on the tap of specific cell to see the details of particular record.
5. There us "Liked" button to navigate to see the only Liked Images Records.

About Detail Screen:- 
1. User can see the full details of image title, description and image.
2. User can download the image and save to gallery (Photos App).
3. User can delete the specific image. Which will delete from Database and List(table view).

About Detail Screen:- 
1. User can see the only records of image which is liked.


- Wrote Unit and UI test cases for All three screens.
- No third party used.
- Created Protocol for use delegate methods from detail screen to home screen to save and delete image. 

# Demo 

- Home Screen 
https://github.com/devJay18/PhotoGallery/assets/159724974/976265ae-861e-4edd-bd4d-6942f38fe9b2

- Detail Screen
https://github.com/devJay18/PhotoGallery/assets/159724974/e6291e2c-f6a9-4743-adf9-bd29f7ec410e

- Pull to refresh and Liked Images List
https://github.com/devJay18/PhotoGallery/assets/159724974/f92d2165-640e-4bab-98dd-3662ca3763e9
