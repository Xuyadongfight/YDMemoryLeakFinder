//
//  YDTableView.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2022/9/7.
//

#if DEBUG

#import "YDTableView.h"


extern NSMutableArray *propertys;

//MARK: -YDTableViewCellModel

@implementation YDTableViewCellModel

@end

//MARK: -YDTableViewCell
@interface YDTableViewCell : UITableViewCell

@property(strong,nonatomic)UILabel* labProperty;
@property(strong,nonatomic)UIImageView* imgCheck;

@property(strong,nonatomic)UIImage *imgUnChecked;
@property(strong,nonatomic)UIImage *imgCheckOk;
@property(strong,nonatomic)UIImage *imgCheckError;
@property(assign,nonatomic)CGSize imgSize;


@end

@implementation YDTableViewCell

- (CGSize)imgSize{
    return CGSizeMake(20, 20);
}

- (UIImage *)imgUnChecked{
    if (_imgUnChecked == nil) {
        UIGraphicsBeginImageContext(self.imgSize);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetLineCap(ctx, kCGLineCapRound);
    
        CGContextMoveToPoint(ctx, 2, self.imgSize.height/2);
        CGContextAddLineToPoint(ctx, self.imgSize.width - 2 * 2, self.imgSize.height/2);
        
        CGContextStrokePath(ctx);
        
        _imgUnChecked = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _imgUnChecked;
}

- (UIImage *)imgCheckOk{
    if (_imgCheckOk == nil) {
        UIGraphicsBeginImageContext(self.imgSize);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetLineCap(ctx, kCGLineCapRound);
    
        CGContextMoveToPoint(ctx, self.imgSize.width/4, self.imgSize.height/2);
        CGContextAddLineToPoint(ctx, self.imgSize.width/2, self.imgSize.height/3*2);
        CGContextAddLineToPoint(ctx, self.imgSize.width - 2 * 2, self.imgSize.height/4);
        
        CGContextStrokePath(ctx);
        
        _imgCheckOk = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _imgCheckOk;
}

- (UIImage *)imgCheckError{
    if (_imgCheckError == nil) {
        UIGraphicsBeginImageContext(self.imgSize);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetLineCap(ctx, kCGLineCapRound);
    
        CGContextMoveToPoint(ctx, 2, 2);
        CGContextAddLineToPoint(ctx, self.imgSize.width - 2 * 2, self.imgSize.height - 2 * 2);
        CGContextMoveToPoint(ctx, self.imgSize.width - 2 * 2, 2);
        CGContextAddLineToPoint(ctx, 2, self.imgSize.height - 2 * 2);
        
        CGContextStrokePath(ctx);
        
        _imgCheckError = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _imgCheckError;
}

- (UILabel *)labProperty{
    if (_labProperty == nil) {
        _labProperty = [[UILabel alloc] init];
        _labProperty.numberOfLines = 0;
        _labProperty.textColor = [UIColor lightGrayColor];
        _labProperty.textAlignment = NSTextAlignmentLeft;
        _labProperty.text = @"property";
    }
    return _labProperty;
}
- (UIImageView *)imgCheck{
    if (_imgCheck == nil) {
        _imgCheck = [[UIImageView alloc] init];
        _imgCheck.contentMode = UIViewContentModeCenter;
    }
    return _imgCheck;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    YDTableViewCell* temp = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    temp.selectionStyle = UITableViewCellSelectionStyleNone;
    [temp.contentView addSubview:self.labProperty];
    [temp.contentView addSubview:self.imgCheck];
    return temp;
}

-(void)loadModel:(YDTableViewCellModel*)model{
    self.labProperty.text = model.name;
    switch (model.status) {
        case unChecked:
            self.imgCheck.image = self.imgUnChecked;
            break;
        case checkedOk:
            self.imgCheck.image = self.imgCheckOk;
            break;
        case checkError:
            self.imgCheck.image = self.imgCheckError;
            break;
        default:
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat gapH = 10;
    CGSize labSize = CGSizeMake(self.bounds.size.width/2, self.bounds.size.height/3*2);
    self.labProperty.frame = CGRectMake(gapH,(self.bounds.size.height - labSize.height)/2,labSize.width ,labSize.height);
    
    CGSize imgSize = CGSizeMake(30, 30);
    self.imgCheck.frame = CGRectMake(self.bounds.size.width - imgSize.width - gapH, (self.bounds.size.height - imgSize.height)/2, imgSize.width, imgSize.height);
}

@end


//MARK: -YDTableView
@interface YDTableView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation YDTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return propertys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:18];
    lab.numberOfLines = 0;
    lab.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    lab.text = @" 所有属性";
    return lab;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor whiteColor];
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    if (cell == nil) {
        cell = [[YDTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    }
    YDTableViewCellModel *cellModel = propertys[indexPath.row];
    [cell loadModel:cellModel];
    return cell;
}

@end


#endif
