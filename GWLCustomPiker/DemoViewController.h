//
//  DemoViewController.h
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/12.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemoViewController : UIViewController

@end

@interface ProvinceModel : NSObject

@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, strong) NSArray *provinceCities;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)provinceModelWithDict:(NSDictionary *)dict;

@end
