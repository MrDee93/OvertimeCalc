//
//  LoadingView.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 02/11/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

-(instancetype)initWithLoadingMessage:(NSString*)message {
    if(self = [super init]) {
        self.alertController = [UIAlertController alertControllerWithTitle:message message:@"\n\n" preferredStyle:UIAlertControllerStyleAlert];
        
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.spinner.center = CGPointMake(130.0, 65.5);
        self.spinner.color = [UIColor blackColor];
        [self.alertController.view addSubview:self.spinner];
    }
    return self;
}

-(instancetype)init {
    if(self = [super init]) {
        self.alertController = [UIAlertController alertControllerWithTitle:@"Loading..." message:@"\n\n" preferredStyle:UIAlertControllerStyleAlert];
        self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.spinner.center = CGPointMake(130.0, 65.5);
        self.spinner.color = [UIColor blackColor];
        [self.alertController.view addSubview:self.spinner];
    }
    return self;
}
-(void)presentLoadingViewOnVC:(UIViewController*)viewController {
    [self.spinner startAnimating];
    [viewController presentViewController:self.alertController animated:YES completion:nil];
}
-(void)stopLoadingOnVC:(UIViewController*)viewController {
    [self.spinner stopAnimating];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)dealloc {
    self.spinner = nil;
    self.alertController = nil;
}
/*
-(void)showLoading {
    self.alertController = [UIAlertController alertControllerWithTitle:@"Loading..." message:@"\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(130.0, 65.5);
    spinner.color = [UIColor blackColor];
    [spinner startAnimating];
    [alertController.view addSubview:spinner];
    [self presentViewController:alertController animated:YES completion:^{
        // nil
    }];
    [self performSelector:@selector(stopAnimation:) withObject:spinner afterDelay:0.5];
    
}

-(void)stopAnimation:(UIActivityIndicatorView*)spinner {
    [spinner stopAnimating];
    spinner = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}*/

@end
