//
//  YDTableView.h
//  YDMemoryLeakFinder
//
//  Created by 徐亚东 on 2022/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum _YDCheckStatus{
    unChecked = 0,
    checkedOk = 1,
    checkError = 2
    
}YDCheckStatus;

@interface YDTableViewCellModel : NSObject
@property(strong,nonatomic)NSString *name;
@property(assign,nonatomic)YDCheckStatus status;
@end


@interface YDTableView : UITableView

@end

NS_ASSUME_NONNULL_END
