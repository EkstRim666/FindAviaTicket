//
//  MapPrice.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 23/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapPrice : NSObject

@property (strong, nonatomic) City *origin;
@property (strong, nonatomic) City *destination;
@property (strong, nonatomic) NSDate *departure;
@property (strong, nonatomic) NSDate *returnDate;
@property (strong, nonatomic) NSNumber *numberOfChanges;
@property (strong, nonatomic) NSNumber *value;
@property (strong, nonatomic) NSNumber *distance;
@property (nonatomic) BOOL actual;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin:(City *)origin;

@end

NS_ASSUME_NONNULL_END
