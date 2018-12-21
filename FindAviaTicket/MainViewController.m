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

#define dataManager [DataManager sharedInstance]
#define apiManager [APIManager sharedInstance]

@interface MainViewController ()<PlaceTableViewControllerDelegate>

@property (strong, nonatomic) UIView *placeContainerView;
@property (strong, nonatomic) UIButton *departureButton;
@property (strong, nonatomic) UIButton *arrivalButton;

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

#pragma mark - PlaceTableViewControllerDelegate
- (void)selectedPlace:(id)place
             withType:(PlaceType)placeType
          andDataType:(DataSourceType)dataType
{
    NSString *title;
    switch (dataType) {
        case DataSourceTypeCity: {
        City *city = (City *)place;
            title = city.name;
            break;
        }
        case DataSourceTypeAirport: {
        Airport *airport = (Airport *)place;
            title = airport.name;
            break;
        }
        case DataSourceTypeCountry:
            break;
    }
    switch (placeType) {
        case PlaceTypeDeparture:
            [self.departureButton setTitle:title forState:UIControlStateNormal];
            break;
        case PlaceTypeArrival:
            [self.arrivalButton setTitle:title forState:UIControlStateNormal];
            break;
    }
}
@end
