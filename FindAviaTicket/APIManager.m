//
//  APIManager.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 18/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "APIManager.h"

#define API_URL_IP_ADDRESS @"https://api.ipify.org/?format=json"
#define API_URL_CITY_FROM_IP @"https://www.travelpayouts.com/whereami?ip="

#define dataManager [DataManager sharedInstance]
#define uiAplication [UIApplication sharedApplication]
#define urlSession [NSURLSession sharedSession]

@implementation APIManager

+(instancetype)sharedInstance {
    static APIManager *instance;
    static dispatch_once_t apiManageronceToken;
    dispatch_once(&apiManageronceToken, ^{
        instance = [APIManager new];
    });
    return instance;
}

-(void)load:(NSString *)urlString
withCompletion:(void (^)(id _Nullable result))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [uiAplication setNetworkActivityIndicatorVisible:YES];
    });
    [[urlSession dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [uiAplication setNetworkActivityIndicatorVisible:NO];
        });
        completion([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
    }] resume];
}

-(void)ipAddressWithCompletion:(void (^)(NSString *ipAddress))completion {
    [self load:API_URL_IP_ADDRESS withCompletion:^(id  _Nullable result) {
        NSDictionary *json = result;
        completion([json valueForKey:@"ip"]);
    }];
}

-(void)cityForCurrentIP:(void (^)(City *city))completion {
    [self ipAddressWithCompletion:^(NSString *ipAddress) {
        [self load:[NSString stringWithFormat:@"%@%@", API_URL_CITY_FROM_IP, ipAddress] withCompletion:^(id  _Nullable result) {
            NSDictionary *json = result;
            NSString *iata = [json valueForKey:@"iata"];
            if (iata) {
                City *city =[dataManager cityForIATA:iata];
                if (city) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(city);
                    });
                }
            }
        }];
    }];
}

@end
