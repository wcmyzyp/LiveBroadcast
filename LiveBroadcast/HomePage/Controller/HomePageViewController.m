//
//  HomePageViewController.m
//  LiveBroadcast
//
//  Created by WCM on 16/12/16.
//  Copyright © 2016年 WCM. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageCustomCell.h"
#import "HotModel.h"
#import "PlayerViewController.h"
#import "HotModel.h"


//static NSString *homeUrl = @"http://116.211.167.106/api/live/aggregation?uid=133825214&interest=1";
//static NSString *secondUrl = @"http://116.211.167.106/api/live/infos?lc=0000000000000042&cc=TG0001&cv=IK3.8.00_Iphone&proto=7&idfa=DE997F23-2029-4CAC-AA76-1049746F7C4C&idfv=8AEE8D81-C7F6-4769-B6A1-5CE5B4977ACD&devi=29b9c265ac9937268a43949187b76fa66a5f3b25&osversion=ios_9.300000&ua=iPhone6_2&imei=&imsi=&uid=315073764&sid=20i1eidV7wVVFb1cRuAOrPyfi0i1kexaw9Oz0uL4nlqemenGOnqmUl&conn=wifi&mtid=dfa1629b767b55517be946514dfdc5e5&mtxid=d0c2826fd2e&logid=43,5,124&id=1481888794573135%2C1481888824486070%2C1481887875499024%2C1481888956741229%2C1481889004656618&multiaddr=1&s_sg=4c67e0382bd41bdbafb040a78b366c07&s_sc=100&s_st=1481888581";

static NSString *inkeUrl = @"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1";

static NSString *identifier = @"cell";

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    self.navigationItem.title = @"热门";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"global_background"] forBarMetrics:UIBarMetricsDefault];
  
  self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight) style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
  self.tableView.hidden = YES;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:self.tableView];
  
  [self requestData];
  
}

-(void)requestData{
  
  [NetWorkManager JSONDataWithHomeUrl:inkeUrl success:^(id json) {
    NSLog(@"json ====== %@",json);
    self.dataArray = [HotModel mj_objectArrayWithKeyValuesArray:json[@"lives"]];
    self.tableView.hidden = NO;
    [self.tableView reloadData];
  } fail:^{
    NSLog(@"请求失败");
  }];
}



#pragma mark UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  HomePageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    cell = [[HomePageCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.model = self.dataArray[indexPath.row];
  return cell;
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  return 748/2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
  HotModel *model = self.dataArray[indexPath.row];
  
  NSString *url = nil;
  if ([model.creator.portrait containsString:@"http"]) {
    url = model.creator.portrait;
  }else{
    url = [NSString stringWithFormat:@"http://img.meelive.cn/%@",model.creator.portrait];
  }

  PlayerViewController *VC = [[PlayerViewController alloc] init];
  VC.liveUrl = model.stream_addr;
  VC.imageUrl = url;
  VC.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:VC animated:YES];
  
}


// 导航栏隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
//  NSLog(@"offset---scroll:%f",scrollView.contentOffset.y);
  
  //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
  UIPanGestureRecognizer* pan = scrollView.panGestureRecognizer;
  //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
  CGFloat velocity = [pan velocityInView:scrollView].y;
//  NSLog(@"velocity ===== %f",velocity);
  
  if (velocity<-5) {
    
    //向上拖动，隐藏导航栏
    [self.navigationController setNavigationBarHidden:true animated:true];
    [self hideTabbar];
  }
  else if (velocity>5) {
    //向下拖动，显示导航栏
    [self.navigationController setNavigationBarHidden:false animated:true];
    [self showTabBar];
  }
  else if(velocity==0){
    
    //停止拖拽
  }
}

-(void)hideTabbar{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:1];
  for(UIView *view in self.tabBarController.view.subviews)
  {
    if([view isKindOfClass:[UITabBar class]])
    {
      [view setFrame:CGRectMake(view.frame.origin.x,kScreenHeight + 50,view.frame.size.width, view.frame.size.height)];
    }
    else
    {
      
      [view setFrame:CGRectMake(view.frame.origin.x,view.frame.origin.y,view.frame.size.width,kScreenHeight)];
    }
  }
  [UIView commitAnimations];
}

- (void)showTabBar{
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:1];
  for(UIView *view in self.tabBarController.view.subviews)
  {
    
    if([view isKindOfClass:[UITabBar class]])
    {
      [view setFrame:CGRectMake(view.frame.origin.x, kScreenHeight-view.frame.size.height, view.frame.size.width, view.frame.size.height)];
    }
    else
    {
      [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, kScreenHeight-49)];
    }
  }
  
  [UIView commitAnimations];
}

//懒加载
-(NSMutableArray*)dataArray{
  if (!_dataArray) {
    _dataArray = [NSMutableArray array];
  }
  return _dataArray;
}


@end
