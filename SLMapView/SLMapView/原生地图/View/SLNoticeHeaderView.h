//
//  GTQNoticeHeaderView.h
//  GTQCitySelector
//
//  Created by 光头强 on 16/7/21.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LocationBlock)(NSString *city);

@interface SLNoticeHeaderView : UIView
/** 提示文字 */
@property (nonatomic, strong) UILabel *noticeLabel;
/** 定位回调 */
@property (nonatomic, copy) LocationBlock block;
/** 是否定位成功 */
@property (nonatomic, assign) BOOL isLoaction;

@end
