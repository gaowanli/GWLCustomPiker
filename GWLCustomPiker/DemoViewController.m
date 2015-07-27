//
//  DemoViewController.m
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/12.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "DemoViewController.h"
#import "ProvinceModel.h"
#import "GWLCustomPikerView.h"

@interface DemoViewController () <GWLCustomPikerViewDataSource, GWLCustomPikerViewDelegate>

@property (nonatomic,weak) UILabel *resultLabel;
@property (nonatomic,weak) GWLCustomPikerView *customPikerView;

@property (strong, nonatomic) NSArray *citiesData;

@property (nonatomic,assign) NSInteger selectedProvince;
@property (nonatomic,assign) NSInteger selectedCity;

@end

@implementation DemoViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self configureResultLabel];
    [self configureReloadButton];
    
    [self configureCustomPikerView];
}

- (void)configureResultLabel {
    UILabel *resultLabel = [[UILabel alloc]init];
    resultLabel.backgroundColor = [UIColor lightGrayColor];
    resultLabel.frame = CGRectMake(0, 100, self.view.bounds.size.width, 44);
    resultLabel.textColor = [UIColor whiteColor];
    resultLabel.textAlignment = NSTextAlignmentCenter;
    
    ProvinceModel *provinceModel = self.citiesData[0];
    resultLabel.text = [NSString stringWithFormat:@"%@ %@",provinceModel.provinceName,provinceModel.provinceCities[0]];
    
    [self.view addSubview:resultLabel];
    self.resultLabel = resultLabel;
}

- (void)configureReloadButton {
    UIButton *reloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, _resultLabel.frame.origin.y, 100, _resultLabel.bounds.size.height)];
    [reloadButton setTitle:@"reload All" forState:UIControlStateNormal];
    [reloadButton setBackgroundColor:[UIColor blueColor]];
    reloadButton.titleLabel.textColor = [UIColor whiteColor];
    [reloadButton addTarget:self action:@selector(reloadButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadButton];
}

- (void)configureCustomPikerView {
    GWLCustomPikerView *customPikerView  = [[GWLCustomPikerView alloc]init];
    customPikerView.frame = CGRectMake(0, CGRectGetMaxY(_resultLabel.frame)+10, self.view.bounds.size.width, 220);
    customPikerView.dataSource = self;
    customPikerView.delegate = self;
    customPikerView.titleLabelText = @"请选择日期";
    customPikerView.titleLabelColor = [UIColor redColor];
    customPikerView.titleButtonText = @"确定";
    customPikerView.titleButtonTextColor = [UIColor redColor];
    customPikerView.indicatorColor = [UIColor redColor];
    [self.view addSubview:customPikerView];
    self.customPikerView = customPikerView;
}

#pragma mark - GWLCustomPikerViewDataSource
- (NSInteger)numberOfComponentsInCustomPikerView:(GWLCustomPikerView *)customPickerView {
    return 2;
}

- (NSInteger)customPickerView:(GWLCustomPikerView *)customPickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.citiesData.count;
    }else {
        ProvinceModel *provinceModel = self.citiesData[_selectedProvince];
        return provinceModel.provinceCities.count;
    }
}

- (NSString *)customPickerView:(GWLCustomPikerView *)customPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        ProvinceModel *provinceModel = self.citiesData[row];
        return provinceModel.provinceName;
    }else {
        ProvinceModel *provinceModel = self.citiesData[_selectedProvince];
        return provinceModel.provinceCities[row];
    }
}

#pragma mark - events
- (void)reloadButtonDidClick {
    [self.customPikerView reloadAllComponents];
}

#pragma mark - GWLCustomPikerViewDelegate
- (void)customPikerViewDidSelectedComponent:(NSInteger)component row:(NSInteger)row {
    if (component == 0) {
        _selectedProvince = row;
        [self.customPikerView reloadComponent:1];
        _selectedCity = 0;
    }else if (component == 1) {
        _selectedCity = row;
    }
    
    ProvinceModel *provinceModel = self.citiesData[_selectedProvince];
    self.resultLabel.text = [NSString stringWithFormat:@"%@ %@",provinceModel.provinceName,provinceModel.provinceCities[_selectedCity]];
}

- (void)customPikerViewCompleteSelectedRows:(NSArray *)rows {
    ProvinceModel *provinceModel = self.citiesData[[rows[0] integerValue]];
    self.resultLabel.text = [NSString stringWithFormat:@"%@ %@",provinceModel.provinceName,provinceModel.provinceCities[[rows[1] integerValue]]];
}

//- (void)customPikerViewCompleteSelect {
//    NSLog(@"customPikerViewCompleteSelect");
//}

#pragma mark - layz loading
- (NSArray *)citiesData {
    if (!_citiesData) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"plist"];
        NSArray *citiesArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *provinceModelArrayM = [NSMutableArray array];
        for (NSDictionary *dict in citiesArray) {
            ProvinceModel *provinceModel = [ProvinceModel provinceModelWithDict:dict];
            [provinceModelArrayM addObject:provinceModel];
        }
        _citiesData = provinceModelArrayM;
    }
    return _citiesData;
}

@end
