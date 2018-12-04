//
//  DeparturePlaceViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 03/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "DeparturePlaceViewController.h"
#import "DataManager.h"

#define dataManager [DataManager sharedInstance]

#define reuseIdentifire @"cityTableViewCellSubtitle"

@interface DeparturePlaceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation DeparturePlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    self.data = [dataManager cities];
}

#pragma mark - PrepareUI
- (void)prepareUI {
    self.title = @"Departure";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifire];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifire];
    }
    City *city = [self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = city.code;
    return cell;
}

#pragma mark - UITableVievDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
