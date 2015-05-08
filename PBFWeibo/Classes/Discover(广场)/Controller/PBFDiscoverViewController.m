//
//  PBFDiscoverViewController.m
//  PBFWeibo
//
//  Created by apple on 15/5/7.
//  Copyright (c) 2015年 18970841357@163.com. All rights reserved.
//  广场(发现)

#import "PBFDiscoverViewController.h"
#import "IWSearchBar.h"

@interface PBFDiscoverViewController ()

@end

@implementation PBFDiscoverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    IWSearchBar *searchBar = [IWSearchBar searchBar];
    // 尺寸
    searchBar.frame = CGRectMake(0, 0, 300, 30);
    // 设置中间的标题内容
    self.navigationItem.titleView = searchBar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

@end
