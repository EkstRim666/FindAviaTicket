//
//  ProgressView.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 02/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import "ProgressView.h"

#define uiAplication [UIApplication sharedApplication]

@implementation ProgressView {
    BOOL isActive;
}

+(instancetype)sharedInstance {
    static ProgressView *instance;
    static dispatch_once_t progressViewOnceToken;
    dispatch_once(&progressViewOnceToken, ^{
        instance = [[ProgressView alloc] initWithFrame:uiAplication.keyWindow.bounds];
        [instance setup];
    });
    return instance;
}

-(void)createPlanes {
    for (int i = 1; i < 6; i++) {
        UIImageView *plane = [[UIImageView alloc] initWithFrame:CGRectMake(-50, ((float)i * 50 + 100), 50, 50)];
        plane.tag = i;
        plane.image = [UIImage imageNamed:@"plane"];
        [self addSubview:plane];
    }
}

-(void)setup {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"cloud"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [self addSubview:backgroundImageView];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blurView.frame = self.bounds;
    [self addSubview:blurView];
    
    [self createPlanes];
}

-(void)startAnimating:(NSInteger)planeId {
    if (!isActive) return;
    if (planeId >= 6) planeId = 1;
    
    UIImageView *plane = [self viewWithTag:planeId];
    if (plane) {
        [UIView animateWithDuration:1 animations:^{
            plane.frame = CGRectMake(self.bounds.size.width, plane.frame.origin.y, 50, 50);
        } completion:^(BOOL finished) {
            plane.frame = CGRectMake(-50, plane.frame.origin.y, 50, 50);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startAnimating:(planeId + 1)];
        });
    }
}

-(void)show:(void (^)(void))comletion {
    self.alpha = 0;
    isActive = YES;
    [self startAnimating:1];
    [uiAplication.keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        comletion();
    }];
}

-(void)dismiss:(void (^)(void))completion {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self->isActive = NO;
        if (completion) {
            completion();
        }
    }];
}

@end
