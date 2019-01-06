//
//  Ticket.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 21/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Ticket : NSObject

@property (strong, nonatomic) NSString *airline;
@property (strong, nonatomic) NSString *from;
@property (strong, nonatomic) NSString *to;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *flightNumber;
@property (strong, nonatomic) NSDate *departure;
@property (strong, nonatomic) NSDate *returnDate;
@property (strong, nonatomic) NSDate *expires;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
