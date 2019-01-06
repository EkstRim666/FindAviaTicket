//
//  DataManager.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 17/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+(instancetype)sharedInstance {
    static DataManager *instance;
    static dispatch_once_t dataManagerOnceToken;
    dispatch_once(&dataManagerOnceToken, ^{
        instance = [DataManager new];
    });
    return instance;
}

-(NSArray *)arrayFromFileName:(NSString *)fileName
                     ofType:(NSString *)type
{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}

-(NSArray *)createObjectsFromArray:(NSArray *)array
                          withType:(DataSourceType)type
{
    NSMutableArray *results = [NSMutableArray new];
    for (NSDictionary *jsonObject in array) {
        switch (type) {
            case DataSourceTypeCountry: {
                Country *country = [[Country alloc] initWithDictionary:jsonObject];
                [results addObject:country];
                break;
            }
            case DataSourceTypeCity: {
                City *city = [[City alloc] initWithDictionary:jsonObject];
                [results addObject:city];
                break;
            }
            case DataSourceTypeAirport: {
                Airport *airport = [[Airport alloc] initWithDictionary:jsonObject];
                [results addObject:airport];
                break;
            }
        }
    }
    return [NSArray arrayWithArray:results];
}

-(void)loadData {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJsonArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        self->_countries = [self createObjectsFromArray:countriesJsonArray withType: DataSourceTypeCountry];
        
        NSArray *citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        self->_cities = [self createObjectsFromArray:citiesJsonArray withType: DataSourceTypeCity];
        
        NSArray *airportsJsonArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        self->_airports = [self createObjectsFromArray:airportsJsonArray withType: DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:dataManagerLoadDataDidComplete object:nil];
        });
    });
}

-(City *)cityForIATA:(NSString *)iata {
    if (iata) {
        for (City *city in self.cities) {
            if ([city.code isEqualToString:iata]) {
                return city;
            }
        }
    }
    return nil;
}

-(City *)cityForLocation:(CLLocation *)location {
    for (City *city in self.cities) {
        if (ceilf(city.coordinate.latitude) == ceilf(location.coordinate.latitude) && ceilf(city.coordinate.longitude) == ceilf(location.coordinate.longitude)) {
            return city;
        }
    }
    return nil;
}

-(MapPrice *)mapPriceForTitleAnnotation:(NSString *)titleAnnotation {
    NSString *search = [titleAnnotation componentsSeparatedByString:@" "][0];
    for (MapPrice *mapPrice in self.mapPrice) {
        if ([mapPrice.destination.name isEqualToString:search]) {
            return mapPrice;
        }
    }
    return nil;
}

@end
