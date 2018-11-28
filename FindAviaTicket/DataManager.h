//
//  DataManager.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 28/11/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"
#import "City.h"
#import "Airport.h"

#define kDataManagerLoadDataDidComplete @"DataManagerLoadDataDidComplete"

typedef enum DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;

+(instancetype)sharedInstance;
-(void)loadData;

@end

NS_ASSUME_NONNULL_END
