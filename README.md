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
pod 'WKTrackingData', '~> 0.0.9'
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
* `UIView+GestureTracking`
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
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [kWKTrackingDataManager enableTracking];
    return YES;
}
​``` 
```
在`didFinishLaunchingWithOptions`中开启事件追踪，如果在`didFinishLaunchingWithOptions`之后启用，会导致部分事件无法覆盖。

```objective-c
// default is 30
kWKTrackingDataManager.memeryItemCount = 60;
kWKTrackingDataManager.uploadType = WKTrackingDataUploadDefault;
```

可以自定义内存中超过多少条事件触发上传，以及上传的类型。

#### Upload Tracking Data

```objective-c
kWKTrackingDataManager.uploadTrackingDataTrigger = ^(NSArray *trackingDataArray, void (^remove)(void)) {

  // do something
  ...

  // after upload success , remove uploaded tmp data
  remove();
};
```

在合适的地方做数据上传操作，注意在上传成功之后调用 `remove()`，将已上传数据从缓存中删除；如果未调用 `remove()`，已上传数据仍然存在于缓存中。

对外交付的 `trackingDataArray` 数据如下：

```
[
	{
	    "event_id" = 96D071ADA1D70DF2805634108B754A10;
	    "event_path" = "#buttonClick:#UIButton#UIButton[0]#UIView[0]#ViewController#...#UIApplication#AppDelegate#currentTitle=Button#state=1#enabled=1#selected=0";
	    "event_time" = 1578558811346;
	}
]
```

#### Add Additional parameters

为了方便业务定制，可以给响应事件的控件添加额外的参数：

```objective-c
self.button.wk_trackingData = @{
    @"id" : @"4396",
    @"type" : @"event_type"
};
```
那么对外交付的 `trackingDataArray` 数据就会变为：

```objective-c
[
	{
	    "event_id" = xxxxxx;
	    "event_path" = "#buttonClick:#...#currentTitle=Button#state=1#enabled=1#selected=0#id=4396#type=event_type";
	    "event_time" = 1578558811346;
	}
]
```

对于不希望进行事件追踪的控件，可以通过 `wk_ignoreTracking` 进行忽略：
```objective-c
self.slider.wk_ignoreTracking = YES;
```


## License

WKTrackingData is released under the MIT license. 