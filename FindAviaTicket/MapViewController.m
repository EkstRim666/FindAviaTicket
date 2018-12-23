//
//  MapViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 23/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "MapViewController.h"
#import "LocationService.h"
#import <MapKit/MapKit.h>
#import "DataManager.h"
#import "APIManager.h"

#define dataManager [DataManager sharedInstance]
#define apiManager [APIManager sharedInstance]

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) LocationService *locationService;
@property (strong, nonatomic) City *origin;
@property (strong, nonatomic) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [dataManager loadData];
    
    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad:) name:dataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:locationServiceDidUpdateCurrentLocation object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:locationServiceDidUpdateCurrentLocation object:nil];
}

#pragma mark - Work with Notifications
-(void)dataDidLoad:(NSNotification *)notification {
    self.locationService = [LocationService new];
}

-(void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [self.mapView setRegion:region animated:YES];
    if(currentLocation) {
        self.origin = [dataManager cityForLocation:currentLocation];
        if (self.origin) {
            [apiManager mapPricesFor:self.origin withCompletion:^(NSArray * _Nonnull prices) {
                self.prices = prices;
            }];
        }
    }
}

-(void)setPrices:(NSArray *)prices {
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [MKPointAnnotation new];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)",price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%@ rub", price.value];
            annotation.coordinate = price.destination.coordinate;
            [self.mapView addAnnotation:annotation];
        });
    }
}

#pragma mark - PrepareUI
-(void)prepareUI {
    self.title = @"Map price";
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
}

@end
