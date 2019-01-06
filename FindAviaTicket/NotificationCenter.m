//
//  NotificationCenter.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 03/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import "NotificationCenter.h"
#import <UserNotifications/UserNotifications.h>

@interface NotificationCenter () <UNUserNotificationCenterDelegate>

@end

@implementation NotificationCenter

+(instancetype)sharedInstance {
    static NotificationCenter *instance;
    static dispatch_once_t notificationCenterOnceToken;
    dispatch_once(&notificationCenterOnceToken, ^{
        instance = [NotificationCenter new];
    });
    return instance;
}

-(void)registerService {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"request authorization succeeded!");
        }
    }];
}

-(void)sendNotification:(Notification)notification {
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    content.title = notification.title;
    content.body = notification.body;
    content.sound = [UNNotificationSound defaultSound];
    
    if (notification.imageURL) {
        UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:notification.imageURL options:nil error:nil];
        if (attachment) {
            content.attachments = @[attachment];
        }
    }
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar componentsInTimeZone:[NSTimeZone systemTimeZone] fromDate:notification.date];
    NSDateComponents *newComponents = [NSDateComponents new];
    newComponents.calendar = calendar;
    newComponents.timeZone = [NSTimeZone defaultTimeZone];
    newComponents.month = components.month;
    newComponents.day = components.day;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Notification" content:content trigger:[UNCalendarNotificationTrigger triggerWithDateMatchingComponents:newComponents repeats:NO]];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}

Notification NotificationMake(NSString *_Nullable title, NSString *_Nonnull body, NSDate *_Nonnull date, NSURL *_Nullable imageURL) {
    Notification notification;
    notification.title = title;
    notification.body = body;
    notification.date = date;
    notification.imageURL = imageURL;
    return notification;
}

@end
