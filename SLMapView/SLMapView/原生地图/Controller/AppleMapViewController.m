//
//  AppleMapViewController.m
//  SLMapView
//
//  Created by 光头强 on 16/8/26.
//  Copyright © 2016年 Ls. All rights reserved.
//

#import "AppleMapViewController.h"
#import "ViewController.h"
#import "SLLocationViewController.h"
#import "SLWeatherViewController.h"
#import "SLLineViewController.h"

static NSString * const AppleItemsIdentifier =@"AppleItemsIdentifier";
@interface AppleMapViewController ()
@property (nonatomic, strong) NSArray *items;
@end

@implementation AppleMapViewController
- (NSArray *)items {
    return @[@"CoreLocation定位",@"添加自定义大头针",@"自定义大头针应用",@"地图路径划线"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"苹果地图";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:AppleItemsIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AppleItemsIdentifier];
    cell.textLabel.text = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[SLLocationViewController alloc] init] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[[SLWeatherViewController alloc] init] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[[SLLineViewController alloc] init] animated:YES];
            break;
            
        default:
            break;
    }
}

@end
