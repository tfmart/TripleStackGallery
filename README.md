# TripleStackGallery

TripleStackGallery is a image gallery component, which displays a set of images as a stack of three images, always displaying the image beign currently displayed and the next two ones in the list, under the current image. To move to the next image in the stack, simply swipe the image on the top and the component will dismiss it and present the next image in the stack.

<!--Add GIF of the component in action-->

This component is a rebuild of image gallery present in the Adidas' store app, built entirely with SwiftUI:

<!--Add GIF of Adidas' implementation-->

## Installation

This package can be added to a project thorugh Swift Package Manager. To add it through Xcode, select `File -> Add Pacakges...` and type `TripleStackGallery` or paste this page's URL in the search field in the top right of the screen.

<!-- Add image of Xcode prompt with the -->

You can also add it by declaring this package as a dependency on your project `Package.swift` file, inside the `dependencies` property of your Package:
```swift
dependencies: [
    .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0"),
]
```

## Usage

First, create an instance of `TripleStackViewModel` by passing the array of images that will be displayed in the gallery:
```swift
let images: [UIImage] = [...]

let viewModel = TripleStackViewModel(images: images)
```


## Contribution

Contributions are always welcome! If you have any trouble with this package, you are welcome to open an issue in this repository. If you want to contribute with code instead, feel free to fork the repo and open a pull request!
