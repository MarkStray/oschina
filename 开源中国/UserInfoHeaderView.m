//
//  UserInfoHeaderView.m
//  开源中国
//
//  Created by qianfeng01 on 15/5/14.
//  Copyright (c) 2015年 LYuan. All rights reserved.
//

#import "UserInfoHeaderView.h"
#import "UIImageView+WebCache.h"
#import "LYHelper.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "AppDelegate.h"
#import "BlogViewController.h"

@implementation UserInfoHeaderView
- (void)awakeFromNib{
    self.portraitImageView.userInteractionEnabled = YES;
    self.portraitImageView.layer.masksToBounds = YES;
    self.portraitImageView.layer.cornerRadius = 25;
    self.messageButton.layer.masksToBounds = YES;
    self.messageButton.layer.cornerRadius = 5;
    self.followerButton.layer.masksToBounds = YES;
    self.followerButton.layer.cornerRadius = 5;
    
    self.segmentControll.tintColor = K_TABBAR_COLOR;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:K_GRAY_COLOR};
    [self.segmentControll setTitleTextAttributes:dict forState:UIControlStateNormal];
    NSDictionary *dict2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:K_BLUE_COLOR};
    [self.segmentControll setTitleTextAttributes:dict2 forState:UIControlStateSelected];
    self.segmentControll.selectedSegmentIndex = -1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)UpDateHeaderViewWithModel:(UserInfoModel *)model complete:( void (^) (BaseViewController *baseVC) )completeCB{
    // 保存
    self.completeBlocks = completeCB;
    self.model = model;
    
    [self.portraitImageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
    self.authorLabel.text = model.name;
    self.scoreLabel.text = model.score;
    self.followersLabel.text = model.followers;
    self.fansLabel.text = model.fans;
    NSInteger second = [LYHelper getSecondNowToDate:model.latestonline formater:@"yyyy-MM-dd HH-mm-ss"];
    if (second >= 24*60*60) {
        self.latestonlineLabel.text = [NSString stringWithFormat:@"上次登录: %ld天前",second/24/60/60];
    }else if (second >= 60*60){
        self.latestonlineLabel.text = [NSString stringWithFormat:@"上次登录: %ld小时前",second/60/60];
    }else if (second >= 60){
        self.latestonlineLabel.text = [NSString stringWithFormat:@"上次登录: %ld分钟前",second/60];
    }else{
        self.latestonlineLabel.text = [NSString stringWithFormat:@"上次登录: 1分钟前"];
    }
    // 加载 资料视图的 数据  默认让 该视图 隐藏
    self.popView = [[[NSBundle mainBundle] loadNibNamed:@"PopInfoView" owner:nil options:nil] lastObject];
    self.popView.frame = CGRectMake((kScreenSize.width-300)/2, kScreenSize.height/2-150, 300, 200);
    [self.popView updateUIWithModel:model];
    self.popView.hidden = YES;
    [self addSubview:self.popView];
}

- (IBAction)segmentClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        BlogViewController *blog = [[BlogViewController alloc] init];
        blog.authoruid = self.model.uid;
        [self callBackBlockWithController:blog];
    }else if (sender.selectedSegmentIndex == 1) {
        self.popView.hidden = NO;
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1001:
            break;
        case 1002:
        case 1003:{
            FrientListViewController *friend = [[FrientListViewController alloc] init];
            friend.uid = self.model.uid;
            [self callBackBlockWithController:friend];
        }
            break;
        case 1004:{
            [self leaveMessage];
        }
            break;
        case 1005:{// 关注
            [self addFollower];
        }
            break;
        default:
            break;
    }
}
- (void)leaveMessage{
    if ([AppDelegate globalDelegate].myAuthorId) {
        LeaveMsgViewController *leaveMsg = [[LeaveMsgViewController alloc] init];
        leaveMsg.model = self.model;
        [self callBackBlockWithController:leaveMsg];
    }else{
        [LYHelper alphaFadeAnimationOnView:self WithTitle:@"用户未登录"];
    }
    
}

- (void)callBackBlockWithController:(BaseViewController *)baseVC{
    if (self.completeBlocks) {
        self.completeBlocks(baseVC);
    }
}
// 关注 post http://www.oschina.net/action/api/user_updaterelation
// hisuid=96666&newrelation=1&uid=2352281 关注
// hisuid=96666&newrelation=0&uid=2352281 取消关注
/*
 <?xml version="1.0" encoding="UTF-8"?>
 <oschina><result><errorCode>-1</errorCode><errorMessage>您已经对Ta添加关注</errorMessage></result><relation>2</relation><notice><atmeCount>0</atmeCount><msgCount>0</msgCount><reviewCount>0</reviewCount><newFansCount>0</newFansCount><newLikeCount>0</newLikeCount></notice></oschina>
 
 <?xml version="1.0" encoding="UTF-8"?>
 <oschina><result><errorCode>1</errorCode><errorMessage>取消关注成功</errorMessage></result><relation>3</relation><notice><atmeCount>0</atmeCount><msgCount>0</msgCount><reviewCount>0</reviewCount><newFansCount>0</newFansCount><newLikeCount>0</newLikeCount></notice></oschina>
 */
- (void)addFollower{
    if ([AppDelegate globalDelegate].myAuthorId) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *relation = nil;
        if ([self.followerButton.titleLabel.text isEqualToString:@"关注"]) {
            relation = @"1";
        }else if ([self.followerButton.titleLabel.text isEqualToString:@"取消关注"]){
            relation = @"0";
        }
        NSString *myUid = [AppDelegate globalDelegate].myAuthorId;
        [manager POST:@"http://www.oschina.net/action/api/user_updaterelation" parameters:@{@"hisuid":self.model.uid,@"newrelation":relation,@"uid":myUid}  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (responseObject) {
                GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseObject encoding:NSUTF8StringEncoding error:nil];
                GDataXMLElement *ele = [[doc nodesForXPath:@"//result" error:nil] lastObject];
                NSInteger flag = [[ele stringValueByName:@"errorCode"] integerValue];
                NSLog(@"flag__flag:%ld",flag);
                if (flag == 1) {
                    [self.followerButton setTitle:@"取消关注" forState:UIControlStateNormal];
                    
                }else if (flag == -1){
                    [self.followerButton setTitle:@"关注" forState:UIControlStateNormal];
                    
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"addFollower__failed:%@",error);
        }];

    }else{
        [LYHelper alphaFadeAnimationOnView:self WithTitle:@"用户未登录"];
    }
}

@end
