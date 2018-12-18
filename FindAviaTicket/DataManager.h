//
//  DataManager.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 17/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Airport.h"
#import "City.h"
#import "Country.h"

#define dataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

@property (strong, nonatomic) NSArray<Airport *> *airports;
@property (strong, nonatomic) NSArray<City *> *cities;
@property (strong, nonatomic) NSArray<Country *> *countries;

+(instancetype)sharedInstance;
-(void)loadData;
-(City *)cityForIATA:(NSString *)iata;

@end

NS_ASSUME_NONNULL_END
