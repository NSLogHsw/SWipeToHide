//
//  ViewController.m
//  SWipeToHide
//
//  Created by Shiwen Huang on 2018/5/23.
//  Copyright © 2018年 Shiwen Huang. All rights reserved.
//

#import "ViewController.h"
#import "SWipeToHide.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && ScreenHeight == 812.0)
#define NavBarHeight (Is_Iphone_X ? 88 : 64)
#define StatusBarHeight (Is_Iphone_X ? 24 : 0)
#define TabbarHeight (Is_Iphone_X ? 83 : 49)
#define SafeBottomHeight (Is_Iphone_X ? 34 : 0)

@interface ViewController ()
<
 UITableViewDelegate,
 SWipeToHideDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong,nonatomic)UIView * headView;
@property (strong, nonatomic) SWipeToHide *swipeToHide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _swipeToHide = [[SWipeToHide alloc]init];
    _swipeToHide.scrollDistance = 100;
    _swipeToHide.delegate = self;
    
    self.tableView.tableHeaderView = self.headView;
    self.tableView.delegate = (id<UITableViewDelegate>)_swipeToHide;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self updateElements];
    
}
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
        _headView.backgroundColor = [UIColor purpleColor];
    }
    return _headView;
}

- (void)updateElements {
    SWipeToHide *swipeToHide = _swipeToHide;
    CGFloat percentHidden = swipeToHide.percentHidden;
    
    self.bottomCons.constant = -percentHidden * (44.0+SafeBottomHeight);
    self.headView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:(1.0 - percentHidden)];
}

#pragma mark - AFUSwipeToHide delegate

- (void)swipeToHide:(SWipeToHide *)swipeToHide didUpdatePercentHiddenInteractively:(BOOL)interactive {
    [self updateElements];
    
    if (!interactive) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.45 initialSpringVelocity:0.0 options:0 animations:^{
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}
#pragma mark - Just a simple table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Item %i", ((int)indexPath.row + 1)];
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
