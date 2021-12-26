# TripleStackGallery

TripleStackGallery is a image gallery component, which displays a set of images as a stack of three images, always displaying the image beign currently displayed and the next two ones in the list, under the current image. To move to the next image in the stack, simply swipe the image on the top and the component will dismiss it and present the next image in the stack.

![TripleStackGalleryDemo](/Images/demo.gif)

This component is a rebuild of image gallery present in the Adidas' store app, built entirely with SwiftUI:

![Adidas Demo](/Images/adidas.gif)

## Installation

This package can be added to a project thorugh Swift Package Manager. To add it through Xcode, select `File -> Add Pacakges...` and type `TripleStackGallery` or paste this page's URL in the search field in the top right of the screen.

![Adding Package from Xcode](/Images/spm.png)

You can also add it by declaring this package as a dependency on your project `Package.swift` file, inside the `dependencies` property of your Package:
```swift
dependencies: [
    .package(name: "TripleStackGallery", url: "https://github.com/tfmart/TripleStackGallery.git", from: "1.0.0"),
]
```

## How to Use

First, create an instance of `TripleStackViewModel` by passing the array of images that will be displayed in the gallery. This class will be the source of the images to the component,
```swift
let images: [UIImage] = [...]

let viewModel = TripleStackViewModel(images: images)
```

Use the instance of view model you just created on the `TripleStackGallery` component initializer

```swift
let gallery = TripleStackGallery(viewModel: viewModel)
```

With the component ready, you should be all set!

### Cusotmizations

You can change some of the presentation rules with the `TripleStackViewModel` class. On it's initializer there are two optional parameters: `index` and `animationDuration`

`index` let's you set the starting index of the gallery when component first appears on screen. Be aware though that if the value set is out of bounds of the `images` arary, a error message will be shown in place of the gallery component

`animationDuration` let's you configure the amount of time the animations displayed when transitioning to a new image takes. The default value is 0.25 second

```
let viewModel = TripleStackViewModel(images: images, index: 2, animationDuration: 0.75)
```

## Contribution

Contributions are always welcome! If you have any trouble with this package, you are welcome to open an issue in this repository. If you want to contribute with code instead, feel free to fork the repo and open a pull request!
