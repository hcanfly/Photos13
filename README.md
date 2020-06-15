# Photos13

Photos13 is a sample app that requires iOS 13 and Xcode 11. It is a photo app that illustrates the use of: a) scrolling view using DisplayLink, b)UICollectionView that uses UICollectionViewDiffableDataSource and UICollectionViewCompositionalLayout, c)properly handling getting access to the camera roll and using your photos, d) use of the Coordinator pattern, among other things. For me, the coolest thing is UICollectionViewCompositionalLayout which lets you create interesting layouts that would be very time-consuming otherwise.

In the screenshot below the top row is the view that scrolls horizontally using CADisplayLink. Below it is the collection view that uses UICollectionViewCompositionalLayout. The section with the Koala bear scrolls horizontally, while the other section use layouts made easy by the new layout.

|![Screenshot](Photos13.gif)





## License

Photos13 is licensed under the Unlicense. See the LICENSE file for more information, but basically this is sample code and you can do whatever you want with it.