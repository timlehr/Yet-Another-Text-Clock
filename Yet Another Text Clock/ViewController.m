//
//  ViewController.m
//  Yet Another Text Clock
//
//  Created by Tim on 29.06.14.
//  Copyright (c) 2014 Loganbun Software. All rights reserved.
//

static const NSString *lang = @"de_DE"; // Language (hardcoded for now)

// *** Time segment constants
static const int minute = 1;
static const int hour = 2;
// *** end constants

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //Gradient Test
//    GBGradientView *gradientView = [[GBGradientView alloc] initWithFrame:self.view.bounds
//                                                            orientation:GBGradientViewOrientationHorizontal];
//    gradientView.delegate = self;
//    gradientView.animationDuration = 3.0f;
//    gradientView.animationDelay = 3.0f;
//    
//    [self.view addSubview:gradientView];
//    [gradientView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - time display & calculations

- (int) getTimeSegment: (int) segment {
    NSDate *currentTime = [NSDate date]; // get system date / time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if(segment==minute) {
        [formatter setDateFormat:@"mm"]; // get just the minutes
    }
    else if (segment==hour) {
        [formatter setDateFormat:@"hh"]; // get just the hours
    } else {
        return -1; // return -1 in case something is not right
    }
    
    return [[formatter stringFromDate:currentTime] intValue]; // returns value as int
}

- (int) getRoundedTime: (int) m {
    int rest = m%5; // modulo with 5
    if(rest==0) return m; // Already in 5min interval
    else if (rest==1 || rest==2) return m-rest; // round down
    return m-rest+5; // round up
}

- (NSString*) minuteToText: (int) m {
    if([lang isEqualToString:@"de_DE"]){ //if language is de_DE
        switch (m) {
            case 0:
                return @"";
                break;
            case 5:
                return @"Fünf";
                break;
            case 10:
                return @"Zehn";
                break;
            case 15:
                return @"Viertel";
                break;
            case 20:
                return @"Zwanzig";
                break;
            default:
                break;
        }
    }
    return @"Minutes";
}

- (NSString*) hoursToText: (int) h {
    if(h>=12) h = h - 12; // convert to 12h format
    if([lang isEqualToString:@"de_DE"]){ //if language is de_DE
        switch (h) {
            case 1:
                return @"Eins";
                break;
            case 2:
                return @"Zwei";
                break;
            case 3:
                return @"Drei";
                break;
            case 4:
                return @"Vier";
                break;
            case 5:
                return @"Fünf";
                break;
            case 6:
                return @"Sechs";
                break;
            case 7:
                return @"Sieben";
                break;
            case 8:
                return @"Acht";
                break;
            case 9:
                return @"Neun";
                break;
            case 10:
                return @"Zehn";
                break;
            case 11:
                return @"Elf";
                break;
            case 0:
                return @"Zwölf";
                break;
            default:
                break;
        }
    }
    return @"Hour";
}

- (NSArray*) getTimeArray {
    NSArray *time = [[NSArray alloc] initWithObjects:@"seg1",nil,@"seg2",nil,@"seg3",nil,@"seg4",nil,@"seg5",nil, nil]; //Array for text segments
    int m = [self getRoundedTime:[self getTimeSegment:minute]];
    int h = [self getTimeSegment:hour];
    
    if([lang isEqualToString:@"de_DE"]){ //if language is de_DE
        // special cases for minutes / hours ...
        switch (m) {
            case 0: // full hour
                [time setValue:@"Punkt" forKey:@"seg1"];
                [time setValue:[self hoursToText:h] forKey:@"seg5"];
                break;
            case 30: // half hour
                [time setValue:[self minuteToText:m] forKey:@"seg2"];
                [time setValue:@"Halb" forKey:@"seg4"];
                [time setValue:[self hoursToText:h] forKey:@"seg5"];
            default:
                [time setValue:[self minuteToText:m] forKey:@"seg2"];
                [time setValue:[self hoursToText:h] forKey:@"seg5"];
                break;
        }
    }
    return time;
}


#pragma mark  - gradient view delegate

//- (NSArray *)gradientColorsForGradientView:(GBGradientView *)gradientView
//{
//    //
//}
//
//- (void)gradientViewAnimationDidStop:(GBGradientView *)gradientView
//{
//    //
//}

@end
