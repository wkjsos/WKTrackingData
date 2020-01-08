# WKTrackingData
基于AOP的全埋点库

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like WKTrackingData in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate WKTrackingData into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'WKTrackingData', '~> 0.0.1'
end
```

Then, run the following command:

```bash
$ pod install
```

## Architecture

### WKTrackingDataManager

- `WKTrackingDataManager`
- `WKTrackingDataViewPathHelper`

### AOP

* `UIApplication+AppdelegateNote`
* `UIApplication+UIControlEventPath`
* `UIGestureRecognizer+Tracking`
* `UITableView+Tracking`
* `UICollectionView+Tracking`
* `UIViewController+Tracking`
* `UIAlertAction+Tracking`
* `UIAlertView+Tracking`
* `UIActionSheet+Tracking`

### Additional Functionality

- `NSObject+TrackingData`

## Usage

### WKTrackingDataManager

`WKTrackingDataManager` creates and manages all tracking data.

#### Enable Tracking

```objective-c
[[WKTrackingDataManager sharedTrackingDataManager] enableTracking];
```

#### Upload Tracking Data

```objective-c
kWKTrackingDataManager.uploadTrackingDataTrigger = ^(NSArray *trackingDataArray, void (^remove)(void)) {

      // do something

      // remove uploaded data
      remove();
  };
```

#### Add Additional parameters

```objective-c
self.button.wk_trackingData = @{
    @"id" : @"4396",
    @"type" : @"event_type"
};
```



## License

WKTrackingData is released under the MIT license. 