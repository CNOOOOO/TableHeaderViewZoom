//
//  FirstViewController.m
//  TableHeaderView下拉放大
//
//  Created by Mac1 on 2018/6/1.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "FirstViewController.h"

#define kImageHeight 300

@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*********************图片加在tableView.tableHeaderView上*********************/
    self.title = @"下拉放大header";
    [self setUpTableView];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - NAVI_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kImageHeight)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.headerImageView = [[UIImageView alloc] initWithFrame:self.headerView.bounds];
    self.headerImageView.image = [UIImage imageNamed:@"header"];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.clipsToBounds = YES;
    [self.headerView addSubview:self.headerImageView];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.tableView];
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
    if(offsetY <= 0) {
        CGFloat totalOffset = kImageHeight - offsetY;
        CGFloat scale = totalOffset / kImageHeight;
        //拉伸后的图片的frame应该是同比例缩放。
        self.headerImageView.frame = CGRectMake(- (width * scale - width) / 2, offsetY, width * scale, totalOffset);
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
