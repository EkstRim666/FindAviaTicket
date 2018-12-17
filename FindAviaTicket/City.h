//
//  City.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 17/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface City : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *timezone;
@property (strong, nonatomic) NSDictionary *translations;
@property (nonatomic) CLLocationCoordinate2D coordinate;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
