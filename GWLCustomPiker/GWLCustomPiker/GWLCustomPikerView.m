//
//  GWLCustomPikerView.m
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/12.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "GWLCustomPikerView.h"

@interface GWLPikerItem : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, assign) BOOL hightLight;
@property (nonatomic, strong) UIColor *itemTextColor;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIColor *itemSelectedTextColor;
@property (nonatomic, strong) UIFont *itemSelectedFont;

@end

@interface GWLCustomPikerCell : UITableViewCell

@property (nonatomic, strong) GWLPikerItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

@interface GWLCustomPikerView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UIView *toolContainerView;
@property (nonatomic, weak) UIView *toolView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *titleButton;
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, weak) UIView *tableContainerView;

@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation GWLCustomPikerView

- (CGFloat)cellHeight {
    _cellHeight = (NSInteger)(CGRectGetHeight(self.tableContainerView.bounds) / GWLDatePickerViewRow);
    return _cellHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configureToolView];
    }
    return self;
}

- (void)configureToolView {
    UIView *toolContainerView = [[UIView alloc]init];
    toolContainerView.backgroundColor = [UIColor lightGrayColor];
    self.toolContainerView = toolContainerView;
    [self addSubview:toolContainerView];
    
    UIView *toolView = [[UIView alloc]init];
    toolView.backgroundColor = [UIColor whiteColor];
    self.toolView = toolView;
    [self addSubview:toolView];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"请选择";
    self.titleLabel = titleLabel;
    [toolView addSubview:titleLabel];
    
    UIButton *titleButton = [[UIButton alloc]init];
    [titleButton setTitle:@"完成" forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchDown];
    self.titleButton = titleButton;
    [toolView addSubview:titleButton];
}

- (void)setDataSource:(id<GWLCustomPikerViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self configureTableView];
}

- (void)configureTableView {
    UIView *tableContainerView = [[UIView alloc]init];
    self.tableContainerView = tableContainerView;
    [self addSubview:tableContainerView];
    
    NSInteger tableViewCount = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInCustomPikerView:)]) {
        tableViewCount = [self.dataSource numberOfComponentsInCustomPikerView:self];
    }
    for (NSInteger i = 0; i < tableViewCount; i++) {
        UITableView *tableView = [self tableView];
        tableView.tag = 999 + i;
        [tableContainerView addSubview:tableView];
        [self.tableViewArray addObject:tableView];
    }
    
    [self configureDataSource];
    
    UIView *indicatorView = [[UIView alloc]init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.userInteractionEnabled = NO;
    self.indicatorView = indicatorView;
    [tableContainerView insertSubview:indicatorView atIndex:0];
}

- (void)configureDataSource {
    NSInteger tableViewCount = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInCustomPikerView:)]) {
        tableViewCount = [self.dataSource numberOfComponentsInCustomPikerView:self];
    }
    
    for (NSInteger i = 0; i < tableViewCount; i++) {
        NSMutableArray *arrayM = [NSMutableArray array];
        [self.dataSourceArray addObject:arrayM];
        [self dataSourceByTableViewComponent:i];
    }
}

- (void)dataSourceByTableViewComponent:(NSInteger)component {
    NSInteger tableViewRowsInSection = 0;
    if ([self.dataSource respondsToSelector:@selector(customPickerView:numberOfRowsInComponent:)]) {
        tableViewRowsInSection = [self.dataSource customPickerView:self numberOfRowsInComponent:component];
    }
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSInteger j = 0; j < tableViewRowsInSection; j++) {
        GWLPikerItem *item = [[GWLPikerItem alloc]init];
        if ([self.dataSource respondsToSelector:@selector(customPickerView:titleForRow:forComponent:)]) {
            item.title = [self.dataSource customPickerView:self titleForRow:j forComponent:component];
        }
        [arrayM addObject:item];
    }
    [self.dataSourceArray replaceObjectAtIndex:component withObject:arrayM];
}

- (UITableView *)tableView {
    UITableView *tableView = [[UITableView alloc]init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat separatorH = 0.5;
    CGFloat toolViewH = 44;
    CGFloat margin = 15;
    
    _toolContainerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), toolViewH + separatorH);
    _toolView.frame = CGRectMake(0, 0, CGRectGetWidth(_toolContainerView.bounds), toolViewH);
    
    CGFloat titleButtonW = 44;
    _titleButton.frame = CGRectMake(CGRectGetWidth(_toolView.bounds) - margin - titleButtonW, 0, titleButtonW, CGRectGetHeight(_toolView.bounds));
    
    _titleLabel.frame = CGRectMake(margin, 0, CGRectGetWidth(self.bounds) - CGRectGetWidth(_titleButton.bounds) - margin * 2, CGRectGetHeight(_titleButton.bounds));
    
    CGFloat tableMargin = 20;
    CGFloat tableContainerViewY = CGRectGetMaxY(_toolContainerView.frame) + tableMargin;
    _tableContainerView.frame = CGRectMake(margin, tableContainerViewY,  CGRectGetWidth(self.bounds) - 2 * margin, CGRectGetHeight(self.bounds) - tableContainerViewY - tableMargin);
    NSInteger index = 0;
    NSInteger tableViewCount = self.tableViewArray.count;
    CGFloat tableViewW = CGRectGetWidth(_tableContainerView.bounds) / tableViewCount;
    NSInteger inset = GWLDatePickerViewRow * 0.5;
    for (UITableView *tableView in self.tableViewArray) {
        tableView.frame = CGRectMake(index * tableViewW, 0, tableViewW, CGRectGetHeight(_tableContainerView.bounds));
        tableView.contentInset = UIEdgeInsetsMake(inset * self.cellHeight, 0, inset * self.cellHeight, 0);
        tableView.contentOffset = CGPointMake(0, -inset * self.cellHeight);
        index++;
    }
    _indicatorView.frame = CGRectMake(0, inset * self.cellHeight, CGRectGetWidth(_tableContainerView.bounds), self.cellHeight);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dataSourceArrayInSection = self.dataSourceArray[tableView.tag - 999];
    return dataSourceArrayInSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWLCustomPikerCell *cell = [GWLCustomPikerCell cellWithTableView:tableView];
    NSArray *dataSourceArrayInSection = self.dataSourceArray[tableView.tag-999];
    GWLPikerItem *item = dataSourceArrayInSection[indexPath.row];
    cell.item = item;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.titleButton.userInteractionEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger row = [self selectedCellIndex:scrollView];
    [self hightLightCellWithRowIndex:row inComponent:scrollView.tag-999];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!scrollView.isDragging){
        [self selectCellInCenter:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.titleButton.userInteractionEnabled = YES;
    [self selectCellInCenter:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.titleButton.userInteractionEnabled = YES;
    if (!scrollView.isDecelerating) {
        [self componentSelected:scrollView.tag - 999];
    }
}

- (void)componentSelected:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(customPikerViewDidSelectedComponent:row:)]) {
        [self.delegate customPikerViewDidSelectedComponent:component row:[self selectedCellIndex:self.tableViewArray[component]]];
    }
}

- (void)selectCellInCenter:(UIScrollView *)scrollView {
    NSInteger row = [self selectedCellIndex:scrollView];
    CGFloat newOffset = row * self.cellHeight;
    newOffset -= (CGRectGetHeight(self.tableContainerView.bounds) * 0.5 - self.cellHeight * 0.5);
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
}

- (NSInteger)selectedCellIndex:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    offset += scrollView.contentInset.top;
    NSInteger mod = (NSInteger)offset % (NSInteger)self.cellHeight;
    CGFloat newValue = (mod >= self.cellHeight * 0.5) ? offset + (self.cellHeight - mod) : offset - mod;
    NSInteger row = (NSInteger)(newValue / self.cellHeight);
    
    NSArray *dataSourceArrayInSection = self.dataSourceArray[scrollView.tag-999];
    if (row > dataSourceArrayInSection.count - 1) {
        row = dataSourceArrayInSection.count - 1;
    }
    return row;
}

- (void)hightLightCellWithRowIndex:(NSInteger)cellIndex inComponent:(NSInteger)component {
    NSArray *itemArray = self.dataSourceArray[component];
    for (NSInteger i = 0;i < itemArray.count;i++) {
        GWLPikerItem *item = (GWLPikerItem *)itemArray[i];
        item.itemFont = _itemFont;
        item.itemSelectedFont = _itemSelectedFont;
        item.itemTextColor = _itemTextColor;
        item.itemSelectedTextColor = _itemSelectedTextColor;
        item.hightLight = (i == cellIndex);
    }
    UITableView *tableView = self.tableViewArray[component];
    [tableView reloadData];
}

- (void)titleButtonDidClick:(UIButton *)titleBtn {
    titleBtn.userInteractionEnabled = NO;
    [self completeSelected];
    titleBtn.userInteractionEnabled = YES;
}

- (void)completeSelected {
    if ([self.delegate respondsToSelector:@selector(customPikerViewCompleteSelect)]) {
        [self.delegate customPikerViewCompleteSelect];
    }else if ([self.delegate respondsToSelector:@selector(customPikerViewCompleteSelectedRows:)]) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (UITableView *tableView in self.tableViewArray) {
            [arrayM addObject:@([self selectedCellIndex:tableView])];
        }
        [self.delegate customPikerViewCompleteSelectedRows:arrayM];
    }
}

#pragma mark - setter
- (void)setTitleLabelText:(NSString *)titleLabelText {
    _titleLabelText = titleLabelText;
    self.titleLabel.text = titleLabelText;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont {
    _titleLabelFont = titleLabelFont;
    self.titleLabel.font = titleLabelFont;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor {
    _titleLabelColor = titleLabelColor;
    self.titleLabel.textColor = titleLabelColor;
}

- (void)setTitleButtonText:(NSString *)titleButtonText {
    _titleButtonText = titleButtonText;
    [self.titleButton setTitle:titleButtonText forState:UIControlStateNormal];
}

- (void)setTitleButtonTextColor:(UIColor *)titleButtonTextColor {
    _titleButtonTextColor = titleButtonTextColor;
    [self.titleButton setTitleColor:titleButtonTextColor forState:UIControlStateNormal];
}

- (void)setTitleButtonFont:(UIFont *)titleButtonFont {
    _titleButtonFont = titleButtonFont;
    self.titleButton.titleLabel.font = titleButtonFont;
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    [self.indicatorView setBackgroundColor:indicatorColor];
}

- (void)setItemTextColor:(UIColor *)itemTextColor {
    _itemTextColor = itemTextColor;
}

- (void)setItemFont:(UIFont *)itemFont {
    _itemFont = itemFont;
}

- (void)setItemSelectedTextColor:(UIColor *)itemSelectedTextColor {
    _itemSelectedTextColor = itemSelectedTextColor;
}

- (void)setItemSelectedFont:(UIFont *)itemSelectedFont {
    _itemSelectedFont = itemSelectedFont;
}

#pragma mark - events
- (void)reloadComponent:(NSInteger)component {
    if (self.tableViewArray.count >= component) {
        [self dataSourceByTableViewComponent:component];
        UITableView *tableView = self.tableViewArray[component];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self hightLightCellWithRowIndex:0 inComponent:component];
    }
}

- (void)reloadAllComponents {
    for (NSInteger i = 0; i < self.tableViewArray.count; i ++) {
        [self reloadComponent:i];
    }
}

#pragma mark - getter
- (NSMutableArray *)tableViewArray {
    if (!_tableViewArray) {
        _tableViewArray = [NSMutableArray array];
    }
    return _tableViewArray;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

@end

@implementation GWLPikerItem

@end

@interface GWLCustomPikerCell ()

@property(nonatomic, weak) UILabel *titleLabel;

@end

@implementation GWLCustomPikerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"customPikerCell";
    GWLCustomPikerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[GWLCustomPikerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}

- (void)setItem:(GWLPikerItem *)item {
    _item = item;
    _titleLabel.text = item.title;
    if (_item.hightLight) {
        self.titleLabel.font = item.itemSelectedFont ?: [UIFont systemFontOfSize:22];
        self.titleLabel.textColor = item.itemSelectedTextColor ?: [UIColor whiteColor];
    }else {
        self.titleLabel.font = item.itemFont ?: [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = item.itemTextColor ?: [UIColor lightGrayColor];
    }
}

@end