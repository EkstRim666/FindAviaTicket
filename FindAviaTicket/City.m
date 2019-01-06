//
//  City.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 17/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "City.h"

@implementation City

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _name = [dictionary valueForKey:@"name"];
        _code = [dictionary valueForKey:@"code"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        _timezone = [dictionary valueForKey:@"time_zone"];
        _translations = [dictionary valueForKey:@"name_translations"];
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if (coords && ![coords isEqual:[NSNull null]]) {
            NSNumber *lat = [coords valueForKey:@"lat"];
            NSNumber *lon = [coords valueForKey:@"lon"];
            if (![lat isEqual:[NSNull null]] && ![lon isEqual:[NSNull null]]) {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
        [self localizeName];
    }
    return self;
}

-(void)localizeName {
    if (!self.translations) return;
    NSString *localed = [[NSLocale currentLocale].localeIdentifier substringToIndex:2];
    if (localed) {
        if ([self.translations valueForKey:localed]) {
            _name = [self.translations valueForKey:localed];
        }
    }
}

@end
