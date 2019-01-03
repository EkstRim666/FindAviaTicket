//
//  NotificationCenter.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 03/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct Notification {
    __unsafe_unretained NSString *_Nullable title;
    __unsafe_unretained NSString *_Nonnull body;
    __unsafe_unretained NSDate *_Nonnull date;
    __unsafe_unretained NSURL *_Nullable imageURL;
} Notification;

NS_ASSUME_NONNULL_BEGIN

@interface NotificationCenter : NSObject

+(instancetype)sharedInstance;
-(void)registerService;
-(void)sendNotification:(Notification)notification;
Notification NotificationMake(NSString *_Nullable title, NSString *_Nonnull body, NSDate *_Nonnull date, NSURL *_Nullable imageURL);

@end

NS_ASSUME_NONNULL_END
