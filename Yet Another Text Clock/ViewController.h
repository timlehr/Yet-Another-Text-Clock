//
//  ViewController.h
//  Yet Another Text Clock
//
//  Created by Tim on 29.06.14.
//  Copyright (c) 2014 Loganbun Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GBGradientView/GBGradientView.h>
#import "RQShineLabel.h"

@interface ViewController : UIViewController <GBGradientViewDelegate>

@property IBOutlet RQShineLabel *seg1;
@property IBOutlet RQShineLabel *seg2;
@property IBOutlet RQShineLabel *seg3;
@property IBOutlet RQShineLabel *daytime;
@property IBOutlet RQShineLabel *daytimeIcon;
@property IBOutlet RQShineLabel *date;

@end
