//
//  HomePageCustomCell.m
//  LiveBroadcast
//
//  Created by WCM on 16/12/16.
//  Copyright © 2016年 WCM. All rights reserved.
//

#import "HomePageCustomCell.h"
#import "HotModel.h"


@interface HomePageCustomCell  ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nickLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *viewNumberLabel;
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *playStateLabel;

@end

@implementation HomePageCustomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    self.height = 748/2;
    
    UIView *whiteBgView = [[UIView alloc] init];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteBgView];
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 21;
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.layer.borderColor = [UIColor purpleColor].CGColor;
    [whiteBgView addSubview:self.iconImageView];
    self.nickLabel = [[UILabel alloc] init];
    self.nickLabel.textColor = [UIColor lightGrayColor];
    self.nickLabel.font = [UIFont systemFontOfSize:14];
    [whiteBgView addSubview:self.nickLabel];
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.textColor = [UIColor lightGrayColor];
    self.cityLabel.font = [UIFont systemFontOfSize:12];
    [whiteBgView addSubview:self.cityLabel];
    self.viewNumberLabel = [[UILabel alloc] init];
    self.viewNumberLabel.textColor = [UIColor orangeColor];
    self.viewNumberLabel.font = [UIFont systemFontOfSize:14];
    self.viewNumberLabel.textAlignment = NSTextAlignmentRight;
    [whiteBgView addSubview:self.viewNumberLabel];
    UILabel *watchLabel = [[UILabel alloc] init];
    watchLabel.textColor = [UIColor lightGrayColor];
    watchLabel.font = [UIFont systemFontOfSize:12];
    watchLabel.text = @"在看";
    watchLabel.textAlignment = NSTextAlignmentRight;
    [whiteBgView addSubview:watchLabel];
    
    [whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(kScreenWidth,58.5));
      make.left.equalTo(self.mas_left);
      make.top.equalTo(self.mas_top);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(whiteBgView.mas_left).offset(10);
      make.top.equalTo(whiteBgView.mas_top).offset(10);
      make.width.mas_equalTo(42);
      make.bottom.equalTo(whiteBgView.mas_bottom).offset(-10);
    }];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.iconImageView.mas_right).offset(10);
      make.top.equalTo(self.iconImageView.mas_top).offset(5);
      make.size.mas_equalTo(CGSizeMake(100,14));
    }];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.nickLabel.mas_left);
      make.top.equalTo(self.nickLabel.mas_bottom).offset(7);
      make.size.mas_equalTo(CGSizeMake(100,14));
    }];
    [self.viewNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(whiteBgView.mas_right).offset(-10);
      make.top.equalTo(whiteBgView.mas_top).offset(12);
      make.size.mas_equalTo(CGSizeMake(50,14));
      make.left.equalTo(self.nickLabel.mas_right).offset(30);
    }];
    [watchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.viewNumberLabel.mas_right);
      make.top.equalTo(self.viewNumberLabel.mas_bottom).offset(8);
      make.size.mas_equalTo(CGSizeMake(50,12));
    }];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor colorFromHexString:@"#f0f8f6"];
    [self addSubview:bgView];
    self.posterImageView = [[UIImageView alloc] init];
    self.posterImageView.contentMode = UIViewContentModeScaleToFill;
    [bgView addSubview:self.posterImageView];
    self.playStateLabel = [[UILabel alloc] init];
    self.playStateLabel.layer.masksToBounds = YES;
    self.playStateLabel.layer.cornerRadius = 8;
    self.playStateLabel.textAlignment = NSTextAlignmentCenter;
    self.playStateLabel.textColor = [UIColor whiteColor];
    self.playStateLabel.text = @"直播";
    self.playStateLabel.font = [UIFont systemFontOfSize:14];
    self.playStateLabel.backgroundColor = [UIColor grayColor];
    self.playStateLabel.alpha = 0.7;
    self.playStateLabel.layer.borderWidth = 1;
    self.playStateLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.posterImageView addSubview:self.playStateLabel];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(whiteBgView.mas_bottom);
      make.left.equalTo(self.mas_left);
      make.size.mas_equalTo(CGSizeMake(kScreenWidth,316.5));
    }];
    [self.posterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(bgView.mas_top);
      make.left.equalTo(bgView.mas_left);
      make.size.mas_equalTo(CGSizeMake(kScreenWidth,307.5));

    }];
    [self.playStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.posterImageView.mas_top).offset(10);
      make.right.equalTo(self.posterImageView.mas_right).offset(-10);
      make.size.mas_equalTo(CGSizeMake(60,20));
    }];
    
  }
  return self;
}

-(void)setModel:(HotModel *)model{
  _model = model;
  self.nickLabel.text = self.model.creator.nick;
  self.cityLabel.text = self.model.city;
  self.viewNumberLabel.text = self.model.online_users;
  NSString *url = nil;
  if ([self.model.creator.portrait containsString:@"http"]) {
    url = self.model.creator.portrait;
  }else{
    url = [NSString stringWithFormat:@"http://img.meelive.cn/%@",self.model.creator.portrait];
  }
  [self.iconImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_room"]];
  [self.posterImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_room"]];
  
}

@end
