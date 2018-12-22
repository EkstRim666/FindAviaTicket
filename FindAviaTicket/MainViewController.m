//
//  MainViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 27/11/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "PlaceTableViewController.h"
#import "APIManager.h"
#import "TicketsTableViewController.h"

#define dataManager [DataManager sharedInstance]
#define apiManager [APIManager sharedInstance]

@interface MainViewController ()<PlaceTableViewControllerDelegate>

@property (strong, nonatomic) UIView *placeContainerView;
@property (strong, nonatomic) UIButton *departureButton;
@property (strong, nonatomic) UIButton *arrivalButton;
@property (strong, nonatomic) UIButton *searchButton;
@property (assign, nonatomic) SearchRequest searchRequest;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [dataManager loadData];

    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad:) name:dataManagerLoadDataDidComplete object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dataManagerLoadDataDidComplete object:nil];
}

#pragma mark - Work with notifications
-(void)dataDidLoad:(NSNotification *)notification {
    [self.departureButton setEnabled:YES];
    [self.arrivalButton setEnabled:YES];
    
    [apiManager cityForCurrentIP:^(City *city) {
        [self selectedPlace:city withType:PlaceTypeDeparture andDataType:DataSourceTypeCity];
    }];
}

#pragma mark - PrepareUI
-(void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Search";
    
    self.placeContainerView = [[UIView alloc] initWithFrame:CGRectMake(20, (CGRectGetMaxY(self.navigationController.navigationBar.frame) + 40), (UIScreen.mainScreen.bounds.size.width - 40), 170)];
    self.placeContainerView.backgroundColor = UIColor.whiteColor;
    self.placeContainerView.layer.shadowColor = [[UIColor.blackColor colorWithAlphaComponent:0.1] CGColor];
    self.placeContainerView.layer.shadowOffset = CGSizeZero;
    self.placeContainerView.layer.shadowRadius = 20;
    self.placeContainerView.layer.shadowOpacity = 1;
    self.placeContainerView.layer.cornerRadius = 6;
    [self.view addSubview:self.placeContainerView];
    
    self.departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.departureButton setTitle:@"Departure" forState:UIControlStateNormal];
    self.departureButton.tintColor = UIColor.blackColor;
    self.departureButton.frame = CGRectMake(10, 20, (self.placeContainerView.frame.size.width - 20), 60);
    self.departureButton.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.3];
    self.departureButton.layer.cornerRadius = 4;
    [self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.departureButton setEnabled:NO];
    [self.placeContainerView addSubview:self.departureButton];
    
    self.arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.arrivalButton setTitle:@"Arrival" forState:UIControlStateNormal];
    self.arrivalButton.tintColor = UIColor.blackColor;
    self.arrivalButton.frame = CGRectMake(10, (CGRectGetMaxY(self.departureButton.frame) + 10), (self.placeContainerView.frame.size.width - 20), 60);
    self.arrivalButton.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.3];
    self.arrivalButton.layer.cornerRadius = 4;
    [self.arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrivalButton setEnabled:NO];
    [self.placeContainerView addSubview:self.arrivalButton];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    self.searchButton.tintColor = UIColor.whiteColor;
    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    self.searchButton.frame = CGRectMake(30, (CGRectGetMaxY(self.placeContainerView.frame) + 30), (UIScreen.mainScreen.bounds.size.width - 60), 60);
    self.searchButton.backgroundColor = UIColor.blackColor;
    self.searchButton.layer.cornerRadius = 8;
    [self.searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
}

#pragma mark - IBAction
-(void)placeButtonDidTap:(UIButton *)sender{
    PlaceTableViewController *placeTableViewController;
    if ([sender isEqual:self.departureButton]) {
        placeTableViewController = [[PlaceTableViewController alloc] initWithType:PlaceTypeDeparture];
    } else if ([sender isEqual:self.arrivalButton]) {
        placeTableViewController = [[PlaceTableViewController alloc] initWithType:PlaceTypeArrival];
    }
    placeTableViewController.delegate = self;
    [self.navigationController pushViewController:placeTableViewController animated:YES];
}

-(void)searchButtonDidTap:(UIButton *)sender{
    [apiManager ticketsWithRequest:self.searchRequest withCompletion:^(NSArray * _Nonnull tickets) {
        if (tickets.count > 0) {
            TicketsTableViewController *ticketTableViewController = [[TicketsTableViewController alloc] initWithTickets:tickets];
            [self.navigationController showViewController:ticketTableViewController sender:self];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wrong" message:@"No tickets found for this destination" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

#pragma mark - PlaceTableViewControllerDelegate
- (void)selectedPlace:(id)place
             withType:(PlaceType)placeType
          andDataType:(DataSourceType)dataType
{
    NSString *title;
    NSString *code;
    switch (dataType) {
        case DataSourceTypeCity: {
        City *city = (City *)place;
            title = city.name;
            code = city.code;
            break;
        }
        case DataSourceTypeAirport: {
        Airport *airport = (Airport *)place;
            title = airport.name;
            code = airport.code;
            break;
        }
        case DataSourceTypeCountry:
            break;
    }
    switch (placeType) {
        case PlaceTypeDeparture:
            [self.departureButton setTitle:title forState:UIControlStateNormal];
            _searchRequest.origin = code;
            break;
        case PlaceTypeArrival:
            [self.arrivalButton setTitle:title forState:UIControlStateNormal];
            _searchRequest.destionation = code;
            break;
    }
}
@end
