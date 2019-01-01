//
//  AirportAnnotation.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 01/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AirportAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title andSubtitle:(NSString *)subtitle;

@end

NS_ASSUME_NONNULL_END
