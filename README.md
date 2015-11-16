# GWLCustomPiker
自定义外观的pikcerView，使用方法和UIPikcerView基本一致
## Requirements

* iOS 7.0+
* Xcode 6+


![gif1](https://github.com/gaowanli/GWLCustomPiker/blob/master/1.gif)
## Installation

### CocoaPods 
pod 'GWLCustomPiker'

## Usage
import 'GWLCustomPiker.h'

```Objective-C
GWLCustomPikerView *customPikerView  = [[GWLCustomPikerView alloc]init];
customPikerView.frame = ?;
customPikerView.dataSource = ?;
customPikerView.delegate = ?;
customPikerView.titleLabelText = ?;
customPikerView.titleLabelColor = ?;
customPikerView.titleButtonText = ?";
customPikerView.titleButtonTextColor = ?;
customPikerView.indicatorColor = ?;
[self.view addSubview:customPikerView];
```

# License

GWLCustomPiker is released under the MIT license. See LICENSE for details.
