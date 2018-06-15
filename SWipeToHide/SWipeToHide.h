//
//  SWipeToHide.h
//  SWipeToHide
//
//  Created by Shiwen Huang on 2018/5/23.
//  Copyright © 2018年 Shiwen Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol SWipeToHideDelegate;

@interface SWipeToHide : NSObject

@property (nonatomic, weak) id<SWipeToHideDelegate> delegate;

//介于0到1之间的值表示隐藏
//使用此值更新工具栏、导航栏等。

@property (nonatomic) float percentHidden;

//用户需要滚动到完全隐藏视图。
@property (nonatomic) CGFloat scrollDistance;

// UIScrollview委托调用
- (void)beginDragAtPosition:(CGFloat)position;
- (void)endDragAtTargetPosition:(CGFloat)position velocity:(CGFloat)velocity;
- (void)scrollToPosition:(CGFloat)position;

@end

@protocol SWipeToHideDelegate <NSObject>
 //只要上面三个方法调用就会执行这个代理方法，同样是让UIScrollview委托调用
- (void)swipeToHide:(SWipeToHide *)swipeToHide didUpdatePercentHiddenInteractively:(BOOL)interactive;

@end

// 这个类也可以直接用作ScReVIEW委托。
@interface SWipeToHide(Delegate)<UIScrollViewDelegate>
@end
