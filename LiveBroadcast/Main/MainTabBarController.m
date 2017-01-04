//
//  MainTabBarController.m
//  LiveBroadcast
//
//  Created by WCM on 16/12/16.
//  Copyright © 2016年 WCM. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomePageViewController.h"
#import "MyViewController.h"
#import "MainNavController.h"

#define kClassKey   @"rootVCClassString"
#define kImgKey     @"imageName"
#define kSelImgKey  @"selectedImageName"

@interface MainTabBarController ()
{
  NSArray *childItemsArray;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.tabBar.width,self.tabBar.height)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    [self createChildViewControllers];
    [self createCenterButton];
  

}

-(void)createChildViewControllers{
  
  childItemsArray = @[
                      @{kClassKey  : @"HomePageViewController",
                        kImgKey    : @"tab_live",
                        kSelImgKey : @"tab_live_p"},
                      
                      @{kClassKey  : @"MyViewController",
                        kImgKey    : @"tab_me",
                        kSelImgKey : @"tab_me_p"},];
  
  [childItemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
    UIViewController *vc = [NSClassFromString(dict[kClassKey]) new];
    MainNavController *nav = [[MainNavController alloc] initWithRootViewController:vc];
    UITabBarItem *item = nav.tabBarItem;
    item.image = [UIImage imageNamed:dict[kImgKey]];
    item.selectedImage = [[UIImage imageNamed:dict[kSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置item.title位置偏移
    item.imageInsets = UIEdgeInsetsMake(6, 0,-6, 0);
    [self addChildViewController:nav];
  }];
  
  //隐藏阴影线
  [[UITabBar appearance] setShadowImage:[UIImage new]];
  [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
  
}

-(void)createCenterButton{
  UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [centerBtn setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateNormal];
  [centerBtn setImage:[UIImage imageNamed:@"tab_launch"] forState:UIControlStateHighlighted];
  centerBtn.center = CGPointMake(self.tabBar.width/2,self.tabBar.height/2 - 15);
  centerBtn.bounds = CGRectMake(0, 0, 100, 100);
  [self.tabBar addSubview:centerBtn];
  
}



@end
