//
//  ProgressView.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 02/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProgressView : UIView

+(instancetype)sharedInstance;
-(void)show:(void(^)(void))comletion;
-(void)dismiss:(void(^)(void))completion;

@end

NS_ASSUME_NONNULL_END
