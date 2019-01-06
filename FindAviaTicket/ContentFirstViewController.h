//
//  ContentFirstViewController.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 02/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContentFirstViewController : UIViewController

@property (strong, nonatomic) NSString *contentText;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) int index;

@end

NS_ASSUME_NONNULL_END
