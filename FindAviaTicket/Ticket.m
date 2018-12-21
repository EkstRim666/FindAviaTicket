//
//  Ticket.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 21/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "Ticket.h"

@implementation Ticket

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        _airline = [dictionary valueForKey:@"airline"];
        _price =[dictionary valueForKey:@"price"];
        _flightNumber = [dictionary valueForKey:@"flight_number"];
        _departure = dateFromString([dictionary valueForKey:@"departure_at"]);
        _returnDate = dateFromString([dictionary valueForKey:@"return_at"]);
        _expires = dateFromString([dictionary valueForKey:@"expires_at"]);
    }
    return self;
}

NSDate *dateFromString(NSString *dateString) {
    if (!dateString) return nil;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSString *correctStringDate = [dateString stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    correctStringDate = [correctStringDate stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:correctStringDate];
}

@end
