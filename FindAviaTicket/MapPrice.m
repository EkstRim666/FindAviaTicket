//
//  MapPrice.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 23/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "MapPrice.h"

#define dataManager [DataManager sharedInstance]

@implementation MapPrice

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
                       withOrigin:(City *)origin
{
    self = [super init];
    if (self) {
        _origin = origin;
        _destination = [dataManager cityForIATA:[dictionary valueForKey:@"destination"]];
        _departure = [self dateFromString:[dictionary valueForKey:@"depart_date"]];
        _returnDate = [self dateFromString:[dictionary valueForKey:@"return_date"]];
        _numberOfChanges = [dictionary valueForKey:@"number_of_changes"];
        _value = [dictionary valueForKey:@"value"];
        _distance = [dictionary valueForKey:@"distance"];
        _actual = [[dictionary valueForKey:@"actual"] boolValue];
    }
    return self;
}

-(NSDate *_Nullable)dateFromString:(NSString *)dateString {
    if (!dateString) {
        return nil;
    } else {
        NSDateFormatter *dateFormater = [NSDateFormatter new];
        dateFormater.dateFormat = @"yyyy-MM-dd";
        return [dateFormater dateFromString:dateString];
    }
}

@end
