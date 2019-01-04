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
#import "CoreDataHelper.h"
#import "AirportAnnotation.h"

#define dataManager [DataManager sharedInstance]
#define apiManager [APIManager sharedInstance]
#define coreDataHelper [CoreDataHelper sharedInstance]

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
    
    self.mapView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad:) name:dataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:locationServiceDidUpdateCurrentLocation object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dataManagerLoadDataDidComplete object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:locationServiceDidUpdateCurrentLocation object:nil];
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation class] == MKUserLocation.class) return nil;
    MKMarkerAnnotationView *markerView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"airportsPin"];
    if (!markerView) {
        markerView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"airportsPin"];
        markerView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
    }
    markerView.canShowCallout = YES;
    if ([annotation class] == AirportAnnotation.class) {
        markerView.annotation = (AirportAnnotation *)annotation;
    } else {
        markerView.annotation = annotation;
    }
    return markerView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    AirportAnnotation *annotation = view.annotation;
    if ([coreDataHelper isFavorite:[dataManager mapPriceForTitleAnnotation:annotation.title] withFavorite:favoriteMapPrice]) {
        [coreDataHelper removeFromFavorite:[dataManager mapPriceForTitleAnnotation:annotation.title] withFavoriteClassofElement:FavoriteClassOfElementMapPrice andFavorite:favoriteMapPrice];
    } else {
        [coreDataHelper addToFavorite:[dataManager mapPriceForTitleAnnotation:annotation.title] withFavorite:favoriteMapPrice];
    }
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
#pragma mark - Setter
-(void)setPrices:(NSArray *)prices {
    [self.mapView removeAnnotations:self.mapView.annotations];
    dataManager.mapPrice = prices;
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            AirportAnnotation *annotation = [[AirportAnnotation alloc] initWithCoordinate:price.destination.coordinate title:[NSString stringWithFormat:@"%@ (%@)",price.destination.name, price.destination.code] andSubtitle:[NSString stringWithFormat:@"%@ rub", price.value]];
            [self.mapView addAnnotation:annotation];
        });
    }
}

#pragma mark - PrepareUI
-(void)prepareUI {
    self.title = NSLocalizedString(@"titleMapVC", nil);
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
}

@end
