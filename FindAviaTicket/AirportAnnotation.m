//
//  AirportAnnotation.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 01/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import "AirportAnnotation.h"

@implementation AirportAnnotation

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                            title:(NSString *)title
                      andSubtitle:(NSString *)subtitle
{
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end
