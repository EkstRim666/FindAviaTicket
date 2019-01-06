//
//  LocationService.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 22/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "LocationService.h"
#import <UIKit/UIKit.h>

#define uiAplication [UIApplication sharedApplication]

@interface LocationService () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation LocationService

-(instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Wrong" message:@"unable to determine current location" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleDefault handler:nil]];
        [uiAplication.keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (!self.currentLocation) {
        _currentLocation = [locations lastObject];
        [self.locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:locationServiceDidUpdateCurrentLocation object:self.currentLocation];
    }
}

@end
