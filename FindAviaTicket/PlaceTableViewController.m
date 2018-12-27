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

@interface PlaceTableViewController () <UISearchResultsUpdating>

@property (assign, nonatomic) PlaceType placeType;
@property (strong, nonatomic) UISegmentedControl *navigationSegmentedControl;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *searchArray;
@property (strong, nonatomic) NSArray *resultArray;

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
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchResultsUpdater = self;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    
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
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierCell];
    }
    
    switch (self.navigationSegmentedControl.selectedSegmentIndex) {
        case 0: {
            City *city = [self.resultArray objectAtIndex:indexPath.row];
            cell.textLabel.text = city.name;
            cell.detailTextLabel.text = city.code;
            break;
        }
        case 1:
        default: {
            Airport *airport = [self.resultArray objectAtIndex:indexPath.row];
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
    [self.delegate selectedPlace:[self.resultArray objectAtIndex:indexPath.row] withType:self.placeType andDataType:dataType];
    self.searchController.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter
-(NSArray *)resultArray {
    return (self.searchController.isActive && (self.searchArray.count > 0) ? self.searchArray : self.dataArray);
}

#pragma mark - UISearchResultUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS[cd] %@", searchController.searchBar.text];
        self.searchArray = [self.dataArray filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    }
}
@end
