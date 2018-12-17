//
//  PlaceTableViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 17/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "PlaceTableViewController.h"
#import "DataManager.h"

#define reuseIdentifierCell @"placeTableViewCell"

#define dataManager [DataManager sharedInstance]

@interface PlaceTableViewController ()

@property (assign, nonatomic) PlaceType placeType;
@property (strong, nonatomic) UISegmentedControl *navigationSegmentedControl;
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation PlaceTableViewController

-(instancetype)initWithType:(PlaceType)type {
    self = [super init];
    if (self) {
        _placeType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

#pragma mark - PrepareUI
-(void)prepareUI {
    self.navigationController.navigationBar.tintColor = UIColor.blackColor;
    
    self.navigationSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
    self.navigationSegmentedControl.tintColor = UIColor.blackColor;
    self.navigationSegmentedControl.selectedSegmentIndex = 0;
    [self.navigationSegmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.navigationSegmentedControl;
    [self changeSource];
    
    switch (self.placeType) {
        case PlaceTypeDeparture:
            self.title = @"Departure";
            break;
        case PlaceTypeArrival:
            self.title = @"Arrival";
            break;
    }
}

-(void)changeSource {
    switch (self.navigationSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.dataArray = [dataManager cities];
            break;
        case 1:
        default:
            self.dataArray = [dataManager airports];
            break;
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierCell];
    }
    
    switch (self.navigationSegmentedControl.selectedSegmentIndex) {
        case 0: {
            City *city = [self.dataArray objectAtIndex:indexPath.row];
            cell.textLabel.text = city.name;
            cell.detailTextLabel.text = city.code;
            break;
        }
        case 1:
        default: {
            Airport *airport = [self.dataArray objectAtIndex:indexPath.row];
            cell.textLabel.text = airport.name;
            cell.detailTextLabel.text = airport.code;
            break;
        }
    }
    return cell;
}

#pragma mark - Table delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = (int)self.navigationSegmentedControl.selectedSegmentIndex + 1;
    [self.delegate selectedPlace:[self.dataArray objectAtIndex:indexPath.row] withType:self.placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
