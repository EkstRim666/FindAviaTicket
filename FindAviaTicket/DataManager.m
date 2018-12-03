//
//  DataManager.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 28/11/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property (nonatomic, strong) NSMutableArray *countriesArray;
@property (nonatomic, strong) NSMutableArray *citiesArray;
@property (nonatomic, strong) NSMutableArray *airportsArray;

@end

@implementation DataManager

+(instancetype)sharedInstance {
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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

-(NSMutableArray *)createObjectFromArray:(NSArray *)array
                                withType:(DataSourceType)type
{
    NSMutableArray *results = [NSMutableArray new];
    for (NSDictionary *jsonObject in array) {
        switch (type) {
            case DataSourceTypeCountry:
                [results addObject:[[Country alloc] initWithDictionary:jsonObject]];
                break;
            case DataSourceTypeCity:
                [results addObject:[[City alloc] initWithDictionary:jsonObject]];
                break;
            case DataSourceTypeAirport:
                [results addObject:[[Airport alloc] initWithDictionary:jsonObject]];
                break;
        }
    }
    return results;
}

-(void)loadData {
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSArray *countriesJsonArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        self.countriesArray = [self createObjectFromArray:countriesJsonArray withType:DataSourceTypeCountry];
        
        NSArray *citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        self.citiesArray = [self createObjectFromArray:citiesJsonArray withType:DataSourceTypeCity];
        
        NSArray *airportsJsonArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        self.airportsArray = [self createObjectFromArray:airportsJsonArray withType:DataSourceTypeAirport];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete object:nil];
        });
        NSLog(@"Complete load data");
    });
}

-(NSArray *)countries {
    return self.countriesArray;
}

-(NSArray *)cities {
    return self.citiesArray;
}

-(NSArray *)airports {
    return self.airportsArray;
}

@end
