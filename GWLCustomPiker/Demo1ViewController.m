//
//  Demo1ViewController.m
//  GWLCustomPiker
//
//  Created by GaoWanli on 15/11/17.
//  Copyright © 2015年 高万里. All rights reserved.
//

#import "Demo1ViewController.h"
#import "GWLCustomPikerView.h"

@interface Demo1ViewController () <GWLCustomPikerViewDataSource, GWLCustomPikerViewDelegate>

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GWLCustomPikerView *customPikerView  = [[GWLCustomPikerView alloc]init];
    customPikerView.frame = CGRectMake(0, 100, self.view.bounds.size.width, 220);
    
    customPikerView.dataSource = self;
    customPikerView.delegate = self;
    
    //    customPikerView.titleLabelText = @"请选择日期";
    //    customPikerView.titleLabelFont = [UIFont systemFontOfSize:18.0];
    //    customPikerView.titleLabelColor = [UIColor redColor];
    //
    //    customPikerView.titleButtonText = @"确定";
    //    customPikerView.titleButtonFont = [UIFont systemFontOfSize:18.0];
    //    customPikerView.titleButtonTextColor = [UIColor redColor];
    //
    //    customPikerView.indicatorColor = [UIColor redColor];
    //
    //    customPikerView.itemFont = [UIFont systemFontOfSize:12.0];
    //    customPikerView.itemTextColor = [UIColor lightGrayColor];
    //    customPikerView.itemSelectedFont = [UIFont systemFontOfSize:18.0];
    //    customPikerView.itemSelectedTextColor = [UIColor whiteColor];
    
    [self.view addSubview:customPikerView];
}
#pragma mark - GWLCustomPikerViewDataSource
- (NSInteger)numberOfComponentsInCustomPikerView:(GWLCustomPikerView *)customPickerView {
    return 2;
}

- (NSInteger)customPickerView:(GWLCustomPikerView *)customPickerView numberOfRowsInComponent:(NSInteger)component {
    return component == 0 ? 10 : 20;
}

- (NSString *)customPickerView:(GWLCustomPikerView *)customPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"测试%zd - %zd",component, row];
}

#pragma mark - GWLCustomPikerViewDelegate
- (void)customPikerViewDidSelectedComponent:(NSInteger)component row:(NSInteger)row {
    NSLog(@"customPikerViewDidSelectedComponent componet:%zd - row:%zd", component, row);
}

- (void)customPikerViewCompleteSelectedRows:(NSArray *)rows {
    NSLog(@"customPikerViewCompleteSelectedRows rows:%@", rows);
}

- (void)customPikerViewCompleteSelect {
    NSLog(@"customPikerViewCompleteSelect");
}

@end
