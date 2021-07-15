[![SwiftPM Compatible](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

# CreditScore

CreditScore is an iOS app that fetches credit information of a sample user and displays it.

## Requirements

- Xcode 12
- iOS 13

## Technical Notes

The app uses the MVP architecture to co-ordinate fetching the data via CreditKit and displaying them on screen.

It's built using UIKit and has a simple two-page flow:

- Home Screen

Displays the credit score.

- Credit Information View

It's a detail view where additional credit information is displayed.

## Dependencies

`CreditScore` depends on [CreditKit](https://github.com/arvindravi/CreditKit) which is a Swift Package that interfaces with the API to return the required information.

## Tests

The app is covered with Unit and UITests:

- The presentation logic is covered under Unit Tests and uses a mocked view and the service layer to test the presenter.

- The app's journeys are covered with UITests.

- Additionally, `CreditKit` is covered with Unit Tests to ensure it fetches the data as expected.

## License
[MIT](https://choosealicense.com/licenses/mit/)
