//
//  GWLCustomPikerView.m
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/12.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "GWLCustomPikerView.h"

@interface UIView (Add)

@property (nonatomic,assign) CGFloat X;
@property (nonatomic,assign) CGFloat Y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGSize  size;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

@end

@implementation UIView (Add)

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center                          = self.center;
    center.x                                = centerX;
    self.center                             = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center                          = self.center;
    center.y                                = centerY;
    self.center                             = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setY:(CGFloat)Y {
    CGRect frameT                           = self.frame;
    frameT.origin.y                         = Y;
    self.frame                              = frameT;
}

- (CGFloat)Y {
    return self.frame.origin.y;
}

- (void)setX:(CGFloat)X {
    CGRect frameT                           = self.frame;
    frameT.origin.x                         = X;
    self.frame                              = frameT;
}

- (CGFloat)X {
    return self.frame.origin.x;
}

-(void)setWidth:(CGFloat)width {
    CGRect frameT                           = self.frame;
    frameT.size.width                       = width;
    self.frame                              = frameT;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frameT                           = self.frame;
    frameT.size.height                      = height;
    self.frame                              = frameT;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frameT                           = self.frame;
    frameT.size                             = size;
    self.frame                              = frameT;
}

- (CGSize)size {
    return self.frame.size;
}

@end

@interface GWLPikerItem : NSObject

@property(nonatomic, copy) NSString *title;
/**高亮*/
@property(nonatomic, assign) BOOL hightLight;

@end

@implementation GWLPikerItem

@end

@interface GWLCustomPikerCell : UITableViewCell

@property (nonatomic, strong) GWLPikerItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

@interface GWLCustomPikerCell ()

@property(nonatomic, weak) UILabel *titleLabel;

@end

@implementation GWLCustomPikerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID                     = @"customPikerCell";
    GWLCustomPikerCell *cell                = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell                                    = [[GWLCustomPikerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor                    = [UIColor clearColor];
        cell.selectionStyle                     = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self                                = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
        [self makeCellSubviews];
    return self;
}

/**创建cell所有控件*/
- (void)makeCellSubviews
{
    UILabel *titleLabel                     = [[UILabel alloc]init];
    titleLabel.font                         = [UIFont systemFontOfSize:15];
    titleLabel.textColor                    = [UIColor lightGrayColor];
    titleLabel.textAlignment                = NSTextAlignmentCenter;
    self.titleLabel                         = titleLabel;
    [self addSubview:titleLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.width                       = self.width;
    _titleLabel.height                      = self.height;
}

- (void)setItem:(GWLPikerItem *)item
{
    _item                                   = item;
    _titleLabel.text                        = item.title;
    if (_item.hightLight) {
        self.titleLabel.textColor               = [UIColor whiteColor];
        self.titleLabel.font                    = [UIFont systemFontOfSize:22];
    }else{
        self.titleLabel.textColor               = [UIColor lightGrayColor];
        self.titleLabel.font                    = [UIFont systemFontOfSize:15];
    }
}

@end

const CGFloat GWLDatePickerViewRow      = 5;// 显示多少行
@interface GWLCustomPikerView () <UITableViewDataSource, UITableViewDelegate>

/**工具条*/
@property (nonatomic, weak  ) UIView         *toolContainerView;
@property (nonatomic, weak  ) UIView         *toolView;
@property (nonatomic, weak  ) UILabel        *titleLabel;
@property (nonatomic, weak  ) UIButton       *titleButton;
/**指示器*/
@property (nonatomic, weak  ) UIView         *indicatorView;
@property (nonatomic, assign) CGFloat        cellHeight;
@property (nonatomic, weak  ) UIView         *tableContainerView;

@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation GWLCustomPikerView

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight                             = (NSInteger)(self.tableContainerView.height / GWLDatePickerViewRow);
    }
    return _cellHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self                                = [super initWithFrame:frame]) {
        self.backgroundColor                    = [UIColor whiteColor];
        // 创建工具条
        [self configureToolView];
    }
    return self;
}

/**创建工具条*/
- (void)configureToolView {
    UIView *toolContainerView               = [[UIView alloc]init];
    toolContainerView.backgroundColor       = [UIColor lightGrayColor];
    self.toolContainerView                  = toolContainerView;
    [self addSubview:toolContainerView];
    
    UIView *toolView                        = [[UIView alloc]init];
    toolView.backgroundColor                = [UIColor whiteColor];
    self.toolView                           = toolView;
    [self addSubview:toolView];
    
    UILabel *titleLabel                     = [[UILabel alloc]init];
    titleLabel.textColor                    = [UIColor lightGrayColor];
    titleLabel.font                         = [UIFont systemFontOfSize:15];
    titleLabel.text                         = @"请选择";
    self.titleLabel                         = titleLabel;
    [toolView addSubview:titleLabel];
    
    UIButton *titleButton                   = [[UIButton alloc]init];
    [titleButton setTitle:@"完成" forState:UIControlStateNormal];
    titleButton.titleLabel.font             = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchDown];
    self.titleButton                        = titleButton;
    [toolView addSubview:titleButton];
}

- (void)setDataSource:(id<GWLCustomPikerViewDataSource>)dataSource {
    _dataSource                             = dataSource;
    // 创建tableView
    [self configureTableView];
}

/**创建tableView*/
- (void)configureTableView {
    UIView *tableContainerView              = [[UIView alloc]init];
    self.tableContainerView                 = tableContainerView;
    [self addSubview:tableContainerView];
    
    NSInteger tableViewCount                = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInCustomPikerView:)]) {
        tableViewCount                          = [self.dataSource numberOfComponentsInCustomPikerView:self];
    }
    for (NSInteger i                        = 0; i < tableViewCount; i++) {
        UITableView *tableView                  = [self tableView];
        tableView.tag                           = 999+i;
        [tableContainerView addSubview:tableView];
        [self.tableViewArray addObject:tableView];
    }
    
    [self configureDataSource];
    
    UIView *indicatorView                   = [[UIView alloc]init];
    indicatorView.backgroundColor           = [UIColor blackColor];
    indicatorView.userInteractionEnabled    = NO;
    self.indicatorView                      = indicatorView;
    [tableContainerView insertSubview:indicatorView atIndex:0];
}

- (void)configureDataSource {
    NSInteger tableViewCount                = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInCustomPikerView:)]) {
        tableViewCount                          = [self.dataSource numberOfComponentsInCustomPikerView:self];
    }
    
    for (NSInteger i                        = 0; i < tableViewCount; i ++) {
        NSMutableArray *arrayM                  = [NSMutableArray array];
        [self.dataSourceArray addObject:arrayM];
        [self dataSourceByTableViewComponent:i];
    }
}

- (void)dataSourceByTableViewComponent:(NSInteger)component {
    NSInteger tableViewRowsInSection        = 0;
    if ([self.dataSource respondsToSelector:@selector(customPickerView:numberOfRowsInComponent:)]) {
        tableViewRowsInSection                  = [self.dataSource customPickerView:self numberOfRowsInComponent:component];
    }
    
    NSMutableArray *arrayM                  = [NSMutableArray array];
    for (NSInteger j                        = 0; j < tableViewRowsInSection; j ++) {
        GWLPikerItem *item                      = [[GWLPikerItem alloc]init];
        if ([self.dataSource respondsToSelector:@selector(customPickerView:titleForRow:forComponent:)]) {
            item.title                              = [self.dataSource customPickerView:self titleForRow:j forComponent:component];
        }
        [arrayM addObject:item];
    }
    [self.dataSourceArray replaceObjectAtIndex:component withObject:arrayM];
}

- (UITableView *)tableView {
    UITableView *tableView                  = [[UITableView alloc]init];
    tableView.backgroundColor               = [UIColor clearColor];
    tableView.showsVerticalScrollIndicator  = NO;
    tableView.dataSource                    = self;
    tableView.delegate                      = self;
    tableView.separatorStyle                = UITableViewCellSeparatorStyleNone;
    return tableView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat separatorH                      = 0.5;// 分割线高度
    CGFloat toolViewH                       = 44;// 工具条高度
    CGFloat margin                          = 15;// 左右间距
    
    _toolContainerView.size                 = CGSizeMake(self.width, toolViewH+separatorH);
    _toolView.size                          = CGSizeMake(_toolContainerView.width, toolViewH);
    
    _titleButton.width                      = 44;
    _titleButton.height                     = _toolView.height;
    _titleButton.X                          = _toolView.width - margin - _titleButton.width;
    
    _titleLabel.X                           = margin;
    _titleLabel.size                        = CGSizeMake(self.width-_titleButton.width-margin*2, _titleButton.height);
    
    CGFloat tableMargin                     = 20;// table间距
    CGFloat tableContainerViewY             = CGRectGetMaxY(_toolContainerView.frame) + tableMargin;
    _tableContainerView.frame               = CGRectMake(margin, tableContainerViewY, self.width-2*margin, self.height-tableContainerViewY-tableMargin);
    
    NSInteger index                         = 0;
    NSInteger tableViewCount                = self.tableViewArray.count;
    CGFloat tableViewW                      = _tableContainerView.width/tableViewCount;
    NSInteger inset                         = GWLDatePickerViewRow/2;
    for (UITableView *tableView in self.tableViewArray) {
        tableView.frame                         = CGRectMake(index*tableViewW, 0, tableViewW, _tableContainerView.height);
        tableView.contentInset                  = UIEdgeInsetsMake(inset*self.cellHeight, 0, inset*self.cellHeight, 0);
        tableView.contentOffset                 = CGPointMake(0, -inset*self.cellHeight);
        index++;
    }
    _indicatorView.frame                    = CGRectMake(0, inset*self.cellHeight, _tableContainerView.width, self.cellHeight);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *dataSourceArrayInSection       = self.dataSourceArray[tableView.tag-999];
    return dataSourceArrayInSection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GWLCustomPikerCell *cell                = [GWLCustomPikerCell cellWithTableView:tableView];
    NSArray *dataSourceArrayInSection       = self.dataSourceArray[tableView.tag-999];
    GWLPikerItem *item                      = dataSourceArrayInSection[indexPath.row];
    cell.item                               = item;
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
    NSInteger row                           = [self selectedCellIndex:scrollView];
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
        [self componentSelected:scrollView.tag-999];
    }
}

- (void)componentSelected:(NSInteger)component {
    if ([self.delegate respondsToSelector:@selector(customPikerViewDidSelectedComponent:row:)])
    {
        [self.delegate customPikerViewDidSelectedComponent:component row:[self selectedCellIndex:self.tableViewArray[component]]];
    }
}

/**选中cell中间*/
- (void)selectCellInCenter:(UIScrollView *)scrollView {
    NSInteger row                           = [self selectedCellIndex:scrollView];
    CGFloat newOffset                       = row*self.cellHeight;
    newOffset                               -= (self.tableContainerView.height/2.0-self.cellHeight/2.0);
    [scrollView setContentOffset:CGPointMake(0.0, newOffset) animated:YES];
}

/**选中cell的index*/
- (NSInteger)selectedCellIndex:(UIScrollView *)scrollView {
    CGFloat offset                          = scrollView.contentOffset.y;
    offset                                  += scrollView.contentInset.top;
    NSInteger mod                           = (NSInteger)offset%(NSInteger)self.cellHeight;
    CGFloat newValue                        = (mod >= self.cellHeight/2.0) ? offset+(self.cellHeight-mod) : offset-mod;
    NSInteger row                           = (NSInteger)(newValue/self.cellHeight);
    
    NSArray *dataSourceArrayInSection       = self.dataSourceArray[scrollView.tag-999];
    if (row > dataSourceArrayInSection.count-1) {
        row                                     = dataSourceArrayInSection.count-1;
    }
    return row;
}

/**高亮选中的cell*/
- (void)hightLightCellWithRowIndex:(NSInteger)cellIndex inComponent:(NSInteger)component {
    NSArray *itemArray                      = self.dataSourceArray[component];
    for (NSInteger i                        = 0;i < itemArray.count;i++) {
        GWLPikerItem *item                      = (GWLPikerItem *)itemArray[i];
        item.hightLight                         = (i == cellIndex);
    }
    UITableView *tableView                  = self.tableViewArray[component];
    [tableView reloadData];
}

/**完成按钮点击事件*/
- (void)titleButtonDidClick:(UIButton *)titleBtn {
    titleBtn.userInteractionEnabled         = NO;
    [self completeSelected];
    titleBtn.userInteractionEnabled         = YES;
}

- (void)completeSelected {
    if ([self.delegate respondsToSelector:@selector(customPikerViewCompleteSelect)]) {
        [self.delegate customPikerViewCompleteSelect];
    }else if ([self.delegate respondsToSelector:@selector(customPikerViewCompleteSelectedRows:)])
    {
        NSMutableArray *arrayM                  = [NSMutableArray array];
        for (UITableView *tableView in self.tableViewArray) {
            [arrayM addObject:@([self selectedCellIndex:tableView])];
        }
        [self.delegate customPikerViewCompleteSelectedRows:arrayM];
    }
}

#pragma mark - setter
- (void)setTitleLabelText:(NSString *)titleLabelText {
    _titleLabelText                         = titleLabelText;
    self.titleLabel.text                    = titleLabelText;
}

- (void)setTitleLabelColor:(UIColor *)titleLabelColor {
    _titleLabelColor                        = titleLabelColor;
    self.titleLabel.textColor               = titleLabelColor;
}

- (void)setTitleButtonText:(NSString *)titleButtonText {
    _titleButtonText                        = titleButtonText;
    [self.titleButton setTitle:titleButtonText forState:UIControlStateNormal];
}

- (void)setTitleButtonTextColor:(UIColor *)titleButtonTextColor {
    _titleButtonTextColor                   = titleButtonTextColor;
    [self.titleButton setTitleColor:titleButtonTextColor forState:UIControlStateNormal];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor                         = indicatorColor;
    [self.indicatorView setBackgroundColor:indicatorColor];
}

#pragma mark - events
- (void)reloadComponent:(NSInteger)component {
    if (self.tableViewArray.count >= component) {
        [self dataSourceByTableViewComponent:component];
        UITableView *tableView                  = self.tableViewArray[component];
        [tableView reloadData];
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
        [self hightLightCellWithRowIndex:0 inComponent:component];
    }
}

- (void)reloadAllComponents {
    for (NSInteger i                        = 0; i < self.tableViewArray.count; i ++) {
        [self reloadComponent:i];
    }
}

#pragma mark - layz loading
- (NSMutableArray *)tableViewArray {
    if (!_tableViewArray) {
        _tableViewArray                         = [NSMutableArray array];
    }
    return _tableViewArray;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray                        = [NSMutableArray array];
    }
    return _dataSourceArray;
}

@end
