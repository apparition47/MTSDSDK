## Overview

`MTSDSDK` is a SDK that returns a list of GitHub repository information for an organization for a given mobile platform.


## Requirements

- Xcode 12+
- Swift 5+
- iOS 10.0+

## Installation

MTSDSDK can be installed with [Cocoapods](http://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or [Swift Package Manager](https://swift.org/package-manager/).

### Cocoapods

You can install Cocoapods with [RubyGems](https://rubygems.org/):

```bash
$ sudo gem install cocoapods
```

If your project does not yet have a Podfile, use the `pod init` command in the root directory of your project. To install MTSDSDK using Cocoapods, add the following to your Podfile (substituting `MyApp` with the name of your app).

```ruby
use_frameworks!

target 'MyApp' do
    pod 'MTSDSDK', '~> 0.0.1'
end
```

Then run the `pod install` command, and open the generated `.xcworkspace` file. To update to a newer release of MTSDSDK, use `pod update MTSDSDK`.

For more information on using Cocoapods, refer to the [Cocoapods Guides](https://guides.cocoapods.org/using/index.html).

### Carthage

You can install Carthage with [Homebrew](http://brew.sh/):

```bash
$ brew update
$ brew install carthage
```

If your project does not have a Cartfile yet, use the `touch Cartfile` command in the root directory of your project. To install MTSDSDK using Carthage, add the following to your Cartfile.

```
github "apparition47/MTSDSDK" ~> 0.0.1
```

Then run the following command to build the dependencies and frameworks:

```bash
$ carthage update --platform iOS
```

Follow the remaining Carthage installation instructions [here](https://github.com/Carthage/Carthage#getting-started). Make sure to drag-and-drop the built `MTSDSDK.framework` into your Xcode project and import it in the source files that require it.

### Swift Package Manager

Add the following to your `Package.swift` file to identify MTSDSDK as a dependency. The package manager will clone MTSDSDK when you build your project with `swift build`.

```swift
dependencies: [
    .package(url: "https://github.com/apparition47/MTSDSDK", from: "0.0.1")
]
```
