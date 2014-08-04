//
//  TJRPopoverView.m
//  内蒙中行
//
//  Created by rimi on 14-8-2.
//  Copyright (c) 2014年 brighttj. All rights reserved.
//

#import "TJRPopoverView.h"

@interface TJRPopoverView () <UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate>

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UITableViewController *tableVC;

// 初始化用户界面
- (void)initializeUserInterface;

@end

@implementation TJRPopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeUserInterface];
    }
    return self;
}

- (void)dealloc {
    
    [_dataSource release];
    [_tableVC release];
    [_popoverController release];
    [super dealloc];
}

/**
 *  初始化弹出框的用户界面
 */
- (void)initializeUserInterface {
    
    // 初始化弹出框中的列表视图
    self.tableVC = [[[UITableViewController alloc] init] autorelease];
    self.tableVC.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 180, 220) style:UITableViewStylePlain] autorelease];
    // 设置事件代理以及数据代理
    self.tableVC.tableView.delegate = self;
    self.tableVC.tableView.dataSource = self;
    
    // 初始化弹出框，弹出框中封装的必须是ViewController对象
    self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:self.tableVC] autorelease];
    // 设置弹出框大小
    self.popoverController.popoverContentSize = self.tableVC.tableView.bounds.size;
}

/**
 *  推出弹出框
 */
- (void)presentPopover {
    
    // 根据弹出框的大小，重置列表大小
    self.tableVC.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.popoverFromRect), CGRectGetHeight(self.popoverFromRect));
    // 推出弹出框
    // 参数1：弹出框大小
    // 参数2：由哪一个view弹出（注意：这里没有处理循环引用的情况，所以inView最好不要是superView）
    // 参数3：箭头方向
    // 参数4：是否需要动画效果
    [self.popoverController presentPopoverFromRect:_popoverFromRect inView:self.inView permittedArrowDirections:_arrowDiretion animated:YES];
}

/**
 *  重新加载弹出框数据
 *  用于弹出框数据的重用
 */
- (void)reloadPopover {
    
    [self.tableVC.tableView reloadData];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

#pragma mark - UITableViewDelegate methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"TJRPopoverViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    // 设置列表文字
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 当选中列表某行以后，触发代理方法，将选中行的下标返回
    [self.delegate popoverViewDidSelectAtIndex:indexPath.row];
}

@end