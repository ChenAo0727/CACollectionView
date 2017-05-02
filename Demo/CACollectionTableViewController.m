//
//  CACollectionTableViewController.m
//  CACollectionView
//
//  Created by chenao on 17/5/2.
//  Copyright © 2017年 chenao. All rights reserved.
//

#import "CACollectionTableViewController.h"
#import "ExampleViewController.h"
#import "CASpringEngine.h"
@interface CACollectionTableViewController ()
@end

@implementation CACollectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Example";
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExampleViewController *vc = [[ExampleViewController alloc]init];
    vc.type = indexPath.section;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
