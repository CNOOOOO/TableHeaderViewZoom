//
//  SecondViewController.m
//  TableHeaderView下拉放大
//
//  Created by Mac1 on 2018/6/1.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "SecondViewController.h"

#define kImageHeight 300

@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *navigationView;//自定义导航栏
@property (nonatomic, strong) UIButton *backButton;//返回按钮
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*********************图片加在self.view上*********************/
    [self setUpTableView];
    [self setUpNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setUpNavigationBar {
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, NAVI_HEIGHT)];
    self.navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, STATUS_BAR_HEIGHT, 40, NAVI_BAR_HEIGHT);
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
    [self.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:self.backButton];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH*0.6, NAVI_BAR_HEIGHT)];
    self.titleLabel.center = CGPointMake(kSCREEN_WIDTH*0.5, STATUS_BAR_HEIGHT + (NAVI_HEIGHT - STATUS_BAR_HEIGHT)/2);
    self.titleLabel.text = @"下拉放大header";
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationView addSubview:self.titleLabel];
    [self.view addSubview:self.navigationView];
}

//返回
- (void)backButtonClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.contentInset = UIEdgeInsetsMake(kImageHeight,0,0,0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.contentOffset = CGPointMake(0, -kImageHeight);
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kImageHeight)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerImageView = [[UIImageView alloc] initWithFrame:self.headerView.bounds];
    self.headerImageView.image = [UIImage imageNamed:@"header"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    [self.headerView addSubview:self.headerImageView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.headerView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%d行",(int)indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = kSCREEN_WIDTH;
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY:%f",offsetY);
    if(offsetY <= -kImageHeight) {
        CGFloat scale = -offsetY / kImageHeight;
        //拉伸后的图片的frame应该是同比例缩放。
        self.headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kImageHeight);
        self.headerImageView.frame = CGRectMake(- (width * scale - width) / 2, 0, width * scale, -offsetY);
        self.navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        self.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
    }else {
        //如果想让图片悬浮把else中的代码注释即可
        CGFloat alpha = (kImageHeight + offsetY) / (kImageHeight - NAVI_HEIGHT);
        self.navigationView.backgroundColor = [UIColor colorWithWhite:1 alpha:alpha];
        self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:alpha];
        [self.backButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateNormal];
        [self.backButton setImage:[UIImage imageNamed:@"iconfont-fanhui"] forState:UIControlStateSelected];
        self.headerView.frame = CGRectMake(0, -offsetY - kImageHeight, kSCREEN_WIDTH, kImageHeight);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
