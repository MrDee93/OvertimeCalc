//
//  LoadingView.h
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 02/11/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoadingView : NSObject

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UIAlertController *alertController;

// Init methods
-(instancetype)initWithLoadingMessage:(NSString*)message;
-(instancetype)init;

// Functions
-(void)presentLoadingViewOnVC:(UIViewController*)viewController;
-(void)stopLoadingOnVC:(UIViewController*)viewController;


@end
