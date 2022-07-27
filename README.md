# Pro-Found

<p align="center">
  <img src="https://user-images.githubusercontent.com/94298439/180979665-ac1eda52-adb3-46b8-895e-fdc75a5b3474.png" width="150"/>
</p>

<p align="center" style="margin:0px 50px 0px 60px">
An interactive tutor matching platform that allows users to schedule courses, host events, and share lifestyle or professional content
</p>

<p align="center">
    <img src="https://img.shields.io/badge/platform-iOS-lightgray">
    <img src="https://img.shields.io/badge/license-MIT-informational">
    <img src="https://img.shields.io/badge/release-v1.0.2-green">
    <img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat">
</p>

<p align="center">
    <a href="https://apps.apple.com/tw/app/pro-found/id1630665076?l=en"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg"></a>
</p>

## Main Features

> Browse Tutors

<img src="https://user-images.githubusercontent.com/94298439/181002775-18238d5b-8c73-48e9-a40d-bde45d001306.png" width="300"/> <img src="https://user-images.githubusercontent.com/94298439/181019290-071da985-5939-4935-8093-5fbeba9bf288.png" width="300"/>

> Schedule Courses

<img src="https://user-images.githubusercontent.com/94298439/181020379-1cc0f078-bf9c-45b8-917f-8df2e4df5a66.png" width="300"/> <img src="https://user-images.githubusercontent.com/94298439/181020576-43bcc182-cf81-4323-ad33-cda2c8328b7f.png" width="300"/>

> View Posts and Events

<img src="https://user-images.githubusercontent.com/94298439/181021028-dedd4159-dfa0-4bdf-ba84-aede171b8dad.png" width="300"/> <img src="https://user-images.githubusercontent.com/94298439/181021328-60ccf0d0-46e3-49e3-aaf6-000d4ddc4aee.png" width="300"/>

> View Articles

<img src="https://user-images.githubusercontent.com/94298439/181021910-aca4cf45-daf7-44f2-93e3-430cfd872af3.png" width="300"/> <img src="https://user-images.githubusercontent.com/94298439/181021733-3e27e23f-dc64-496d-94ce-7814a6c9b359.png" width="300"/>

> View Personal Schedule and Profile

<img src="https://user-images.githubusercontent.com/94298439/181022568-cc830bfb-19f2-42f3-9b92-dcb0c509136b.png" width="300"/> <img src="https://user-images.githubusercontent.com/94298439/181022599-097c3faa-13a6-46cf-851a-99c416e5791a.png" width="300"/>

## Technical Highlights
- Followed `MVC pattern` to structure the code base, utilized Firebase SDK to design data structure to perform CRUD operations
- Adopted `delegate pattern` to hand off responsibilities between different classes.
- Utilized Lottie to display loading animation.
- Implemented image downloading and caching via Kingfisher.
- Implemented Auto Layout via `programmatical NSLayoutConstraint` to build an pleasing user interface
- Managed asynchronous/synchronous firebase API sessions through `GCD` framework
- Enable editing of technical articles via `NSAttributedString` and export to PDF via `PDFKit`
- Optimized performance by implementing video `cache` functionality on post’s videos with `AVPlayer` to provide users a smooth scrolling experience.
- Applied multiple user roles of business logic to the application to deal with different user scenarios
- Constructed calendar with date filtering functionality without using third-party libraries

## Libraries
  * [Kingfisher](https://github.com/onevcat/Kingfisher)
  * [lottie-ios](https://github.com/airbnb/lottie-ios)
  * [Cosmos](https://github.com/evgenyneu/Cosmos)
  * [IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager)
  * [SwiftLint](https://github.com/realm/SwiftLint)
  * [MarqueeLabel](https://github.com/cbpowell/MarqueeLabel)

## Version
1.0.2

## Release Notes
| Version | Date | Notes |
| :---: | ----- | ----- |
| 1.0.2 | 2022.07.18 | User flow improvement |
| 1.0.1 | 2022.07.14 | UI improvement |
| 1.0.0 | 2022.07.11 | Submitted to the App Store |

## Requirement
- Xcode 13.0 or later
- iOS 15.0 or later
- Swift 5

## Contact
Hsueh Peng Tseng

tsenghsuehpeng@gmail.com<br>

<a href="https://www.linkedin.com/in/hsueh-peng-tseng/"><img src="https://user-images.githubusercontent.com/94298439/180976421-679887a6-177f-4ee9-b5bd-27c878106ea3.png"></a>

## License
Pro-Found is released under the MIT license. See [LICENSE](https://github.com/HsuehPeng/Pro-Found/blob/main/LICENSE) for details.
