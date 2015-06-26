//
//  GWLCustomPikerView.h
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/12.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GWLCustomPikerView;
@protocol GWLCustomPikerViewDataSource <NSObject>

- (NSInteger)numberOfComponentsInCustomPikerView:(GWLCustomPikerView *)customPickerView;

- (NSInteger)customPickerView:(GWLCustomPikerView *)customPickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)customPickerView:(GWLCustomPikerView *)customPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

@protocol GWLCustomPikerViewDelegate <NSObject>

@optional
/**
 *  滚动结束后 当前组选中的行
 *
 *  @param component 组
 *  @param row       行
 */
- (void)customPikerViewDidSelectedComponent:(NSInteger)component row:(NSInteger)row;

@optional
/**
 *  点击完成按钮 和customPikerViewCompleteSelectedRows:(NSArray *)rows方法二选一实现
 */
- (void)customPikerViewCompleteSelect;

@optional
/**
 *  点击完成按钮 返回当前选中的所有行
 *
 *  @param rows 所有行
 */
- (void)customPikerViewCompleteSelectedRows:(NSArray *)rows;

@end

@interface GWLCustomPikerView : UIView

/**提示文字 默认：“请选择”*/
@property (nonatomic, copy  ) NSString                       *titleLabelText;
/**提示文字颜色*/
@property (nonatomic, strong) UIColor                        *titleLabelColor;
/**按钮文字 默认：“完成”*/
@property (nonatomic, copy  ) NSString                       *titleButtonText;
/**按钮文字颜色*/
@property (nonatomic, strong) UIColor                        *titleButtonTextColor;
/**指示器颜色*/
@property (nonatomic, strong) UIColor                        *indicatorColor;

@property (nonatomic, weak  ) id<                                       GWLCustomPikerViewDelegate      > delegate;
@property (nonatomic, weak  ) id<                                       GWLCustomPikerViewDataSource  > dataSource;

- (void)reloadComponent:(NSInteger)component;
- (void)reloadAllComponents;

@end
