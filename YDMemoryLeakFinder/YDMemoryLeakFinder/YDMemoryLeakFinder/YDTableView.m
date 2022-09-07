//
//  YDTableView.m
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2022/9/7.
//

#import "YDTableView.h"
extern void*arrCheckName;
extern void*arrNoCheckName;

@interface YDTableView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation YDTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}


#pragma mark tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tempNoCheckArr = (__bridge NSArray*)arrNoCheckName;
    NSMutableArray *tempCheckArr = (__bridge NSMutableArray*)arrCheckName;
    if (section == 0) {
        return tempNoCheckArr.count;
    }else{
        return tempCheckArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:18];
    lab.numberOfLines = 0;
    lab.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    if (section == 0) {
        lab.text = @"未检测的成员变量(无法通过kvc取值或者swift设置了访问权限为private)";
    }else{
        lab.text = @"已检测的属性";
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    NSArray *tempNoCheckArr = (__bridge NSArray*)arrNoCheckName;
    NSMutableArray *tempCheckArr = (__bridge NSMutableArray*)arrCheckName;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section == 0) {
        cell.textLabel.text = tempNoCheckArr[indexPath.item];
    }else{
        cell.textLabel.text = tempCheckArr[indexPath.item];
    }
    return cell;
}

@end
