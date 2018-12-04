//
//  ArrivalTableViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 03/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "ArrivalTableViewController.h"
#import "DataManager.h"
#import "CityTableViewCell.h"

#define dataManager [DataManager sharedInstance]

#define reuseIdentifire @"cityTableViewCell"

@interface ArrivalTableViewController ()

@property (nonatomic, strong) NSArray *data;

@end

@implementation ArrivalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [dataManager cities];
    
    [self.tableView registerClass:[CityTableViewCell class] forCellReuseIdentifier:reuseIdentifire];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifire forIndexPath:indexPath];
    City *city = [self.data objectAtIndex:indexPath.row];
    cell.cityName.text = city.name;
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
