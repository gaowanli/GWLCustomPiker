//
//  GWLCustomPikerView.h
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/12.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWLCustomPikerView;
@protocol GWLCustomPikerViewDataSource;
@protocol GWLCustomPikerViewDelegate;

static const CGFloat GWLDatePickerViewRow = 5; // 显示的行数

@interface GWLCustomPikerView : UIView

@property (nonatomic, weak) id<GWLCustomPikerViewDataSource> dataSource;
@property (nonatomic, weak) id<GWLCustomPikerViewDelegate> delegate;
@property (nonatomic, copy) NSString *titleLabelText; // 提示文字 默认：“请选择”
@property (nonatomic, strong) UIFont *titleLabelFont; // 提示文字字体 默认：[UIFont systemFontOfSize:15]
@property (nonatomic, strong) UIColor *titleLabelColor; // 提示文字颜色 默认：[UIColor redColor]
@property (nonatomic, copy) NSString *titleButtonText;  // 按钮文字 默认：“完成”
@property (nonatomic, strong) UIColor *titleButtonTextColor; //  按钮文字颜色 默认：[UIColor redColor]
@property (nonatomic, strong) UIFont *titleButtonFont; //  按钮文字字体 默认：[UIFont systemFontOfSize:15]
@property (nonatomic, strong) UIColor *indicatorColor; // 指示器颜色 默认：[UIColor redColor]
@property (nonatomic, strong) UIColor *itemTextColor; // 选项文字颜色 默认：[UIColor whiteColor]
@property (nonatomic, strong) UIFont *itemFont; // 选项文字字体 默认：[UIFont systemFontOfSize:15]
@property (nonatomic, strong) UIColor *itemSelectedTextColor; // 选项选中文字颜色 默认：[UIColor lightGrayColor]
@property (nonatomic, strong) UIFont *itemSelectedFont; // 选项选中文字字体 默认：[UIFont systemFontOfSize:22]

- (void)reloadComponent:(NSInteger)component; // 刷新某一组
- (void)reloadAllComponents; // 刷新所有组

@end

@protocol GWLCustomPikerViewDataSource <NSObject>

@optional;
- (NSInteger)numberOfComponentsInCustomPikerView:(GWLCustomPikerView *)customPickerView; // 组数 不实现默认返回1
- (NSInteger)customPickerView:(GWLCustomPikerView *)customPickerView numberOfRowsInComponent:(NSInteger)component; // 每组显示的行数
- (NSString *)customPickerView:(GWLCustomPikerView *)customPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component; // 每行显示的文字

@end

@protocol GWLCustomPikerViewDelegate <NSObject>

@optional
- (void)customPikerViewDidSelectedComponent:(NSInteger)component row:(NSInteger)row; // 滚动结束
@optional
- (void)customPikerViewCompleteSelect; // 完成选择 (点击完成按钮)
@optional
- (void)customPikerViewCompleteSelectedRows:(NSArray *)rows; // 完成选择 (点击完成按钮) 返回所有选中行的索引数组

@end