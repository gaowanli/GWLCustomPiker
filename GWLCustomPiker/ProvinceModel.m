//
//  ProvinceModel.m
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/26.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _provinceName = dict[@"name"];
        _provinceCities = dict[@"cities"];
    }
    return self;
}

+ (instancetype)provinceModelWithDict:(NSDictionary *)dict {
    return [[self alloc]initWithDict:dict];
}

@end
