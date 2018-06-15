//
//  SWipeToHide.m
//  SWipeToHide
//
//  Created by Shiwen Huang on 2018/5/23.
//  Copyright © 2018年 Shiwen Huang. All rights reserved.
//

#import "SWipeToHide.h"

@interface SWipeToHide()
{
    CGFloat _dragStartPosition;
    BOOL _isDragging;
}
@end

@implementation SWipeToHide

- (instancetype)init {
    self = [super init];
    if (self) {
        _scrollDistance = 50.0;
    }
    return self;
}

- (void)beginDragAtPosition:(CGFloat)position {
    _dragStartPosition = MAX(position, 0.0);
    _isDragging = YES;
}

- (void)scrollToPosition:(CGFloat)position {
    if (position <= 0.0) {
        [self _setPercentHidden:0.0 interactive:NO];
    }
    else if (_isDragging)
    {
        if (position < _scrollDistance)
        {
            CGFloat newPercentHidden = position/_scrollDistance;
            if (newPercentHidden < _percentHidden) {
                [self _setPercentHidden:newPercentHidden interactive:YES];
                return;
            }
        }
        
        if (_percentHidden < 1.0)
        {
            CGFloat diff = position - _dragStartPosition;
            
            [self _setPercentHidden:(diff / _scrollDistance) interactive:YES];
            
            if (diff < 0.0) {
                _dragStartPosition = position;
            }
        }
    }
}

- (void)endDragAtTargetPosition:(CGFloat)position velocity:(CGFloat)velocity {
    _isDragging = NO;
    
    BOOL shouldHide = YES;
    
    if (velocity < 0.0 ||
        (velocity == 0.0 && _percentHidden == 0.0) ||
        (position < _scrollDistance))
    {
        shouldHide = NO;
    }
    
    [self _setPercentHidden:shouldHide ? 1.0 : 0.0 interactive:NO];
}

- (void)_setPercentHidden:(CGFloat)percent interactive:(BOOL)interactive {
    if (percent < 0.0) percent = 0.0;
        if (percent > 1.0) percent = 1.0;
            
            if (percent == _percentHidden) return;
    
    _percentHidden = percent;
    
    [self.delegate swipeToHide:self didUpdatePercentHiddenInteractively:interactive];
}

@end

@implementation SWipeToHide(Delegate)

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self beginDragAtPosition:scrollView.contentOffset.y + scrollView.contentInset.top];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self endDragAtTargetPosition:targetContentOffset->y + scrollView.contentInset.top velocity:velocity.y];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollToPosition:scrollView.contentOffset.y + scrollView.contentInset.top];
}

@end
