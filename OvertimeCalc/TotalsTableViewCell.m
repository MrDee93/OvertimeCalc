//
//  TotalsTableViewCell.m
//  OvertimeCalc
//
//  Created by Dayan Yonnatan on 03/06/2016.
//  Copyright © 2016 Dayan Yonnatan. All rights reserved.
//

#import "TotalsTableViewCell.h"
#import "AppDelegate.h"

@implementation TotalsTableViewCell

@synthesize setPayButton = _setPayButton;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)setPayrate:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Set Payrate" message:@"What is your pay per hour?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }];
    
    UIAlertAction *submit = [UIAlertAction actionWithTitle:@"Set" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Payrate: £%@", [alertController.textFields firstObject].text);
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancel];
    [alertController addAction:submit];
    
    
    UIViewController *root = (UIViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [root presentViewController:alertController animated:YES completion:nil];
}
@end
