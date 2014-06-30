//
//  ViewController.h
//  Yet Another Text Clock
//
//  Created by Tim on 29.06.14.
//  Copyright (c) 2014 Loganbun Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GBGradientView/GBGradientView.h>

@interface ViewController : UIViewController <GBGradientViewDelegate>

@property IBOutlet UILabel *seg1;
@property IBOutlet UILabel *seg2;
@property IBOutlet UILabel *seg3;
@property IBOutlet UILabel *seg4;
@property IBOutlet UILabel *seg5;

@end
