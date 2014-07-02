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
#import "UIColor+Utils.h"
#import "FontAwesomeKit.h"

@interface ViewController ()
@property (nonatomic, strong) UIColor *highColor;
@property (nonatomic, strong) UIColor *lowColor;
@property (nonatomic, strong) NSMutableArray *colors;
@property (nonatomic, strong) GBGradientView *backgroundView;
@property (nonatomic) BOOL keepColors;
@end

@implementation ViewController

@synthesize seg1;
@synthesize seg2;
@synthesize seg3;
@synthesize daytime;
@synthesize daytimeIcon;
@synthesize date;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Schedule time method
    [self refreshTime];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshTime) userInfo:nil repeats:YES];
    
    // Gradient animation
    [self backgroundSetup];
    
    // Prevent app from display sleep
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void) viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.backgroundView startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - animated background

- (UIColor *)highColor
{
    if (!_highColor) {
        _highColor = [UIColor softCyanColor];
    }
    
    return _highColor;
}

- (UIColor *)lowColor
{
    if (!_lowColor) {
        _lowColor = [UIColor lightBlueColor];
    }
    
    return _lowColor;
}

- (NSMutableArray *)colors
{
    if (_colors && (self.keepColors == NO)) {
        self.highColor = [UIColor nextColor:self.highColor];
        self.lowColor = [UIColor nextColor:self.lowColor];
    }
    
    self.keepColors = NO;
    
    _colors = [NSMutableArray array];
    
    [_colors addObject:(id)[self.highColor CGColor]];
    [_colors addObject:(id)[self.lowColor CGColor]];
    
    return _colors;
}

- (void) backgroundSetup {
    CGRect bounds = [[UIScreen mainScreen] bounds]; // portrait bounds
    bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
    
    self.backgroundView = [[GBGradientView alloc] initWithFrame: bounds
                                                    orientation:GBGradientViewOrientationHorizontal];
    self.backgroundView.delegate = self;
    self.backgroundView.animationDuration = 60.0f;
    self.backgroundView.animationDelay = 1.0f;
    
    [self.view addSubview:self.backgroundView];
    [self.view sendSubviewToBack:self.backgroundView];
    [self.backgroundView startAnimating];
    
    self.keepColors = false;
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
    return (m-rest+5); // round up
}

- (NSString*) minuteToText: (int) m {
    if([lang isEqualToString:@"de_DE"]){ //if language is de_DE
        if(m==0 || m==60 || m==30) return @"$HIDE$";
        else if (m%20==0) return @"Zwanzig";
        else if (m%15==0) return @"Viertel";
        else if (m%10==0) return @"Zehn";
        else return @"Fünf";
    }
    return @"Minutes";
}

- (NSString*) hoursToText: (int) h : (int) m {
    
    if([lang isEqualToString:@"de_DE"]){ //if language is de_DE
        
        if(25<=m) h++; // minutes to hour (+ 1)
        if(h>=12) h = h - 12; // convert to 12h format
        
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

- (NSString*) getPrefix: (int) m {
    if([lang isEqualToString:@"de_DE"]){ //if language is de_DE
        if (m==0 || m==30 || m==60) return @"$HIDE$";
        else if(m<=20 || m==35) return @"Nach";
        else if(40<=m || m==25) return @"Vor";
    }
    return @"Prefix";
}

- (NSString*) getDaytime {
    NSDate *currentTime = [NSDate date]; // get system date / time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    int h = [[formatter stringFromDate:currentTime] intValue];
    
    if([lang isEqualToString:@"de_DE"]){
        if(h < 6) return @"Nacht";
        else if(h >= 6 && h < 11) return @"Morgen";
        else if (h >= 11 && h < 13) return @"Mittag";
        else if (h >= 13 && h < 18) return @"Nachmittag";
        else if (h >= 18 && h < 22) return @"Abend";
        else return @"Nacht";
    }
    return @"Tageszeit";
}

- (FAKIonIcons*) getDaytimeIcon {
    NSDate *currentTime = [NSDate date]; // get system date / time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    int h = [[formatter stringFromDate:currentTime] intValue];
    NSLog(@"HH: %d",h);
    
    if(h >= 6 && h < 18){
        FAKIonIcons *Icon = [FAKIonIcons ios7SunnyIconWithSize:36];
        [Icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        return Icon;
    }
    
    FAKIonIcons *Icon = [FAKIonIcons ios7MoonIconWithSize:36];
    [Icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    return Icon;
}

- (NSString*) getDateString {
    NSDate *currentTime = [NSDate date]; // get system date / time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    [formatter setDateFormat:@"dd. MMMM YYYY"];
    return [formatter stringFromDate:currentTime];
}

- (NSMutableDictionary*) getTimeArray {
    NSMutableDictionary *time = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          @"", @"seg1",
                          @"", @"seg2",
                          @"", @"seg3",
                          @"", @"daytime",
                          nil];
    //Dictionary for text segments

    // ** Get current time
    int m = [self getRoundedTime:[self getTimeSegment:minute]];
    int h = [self getTimeSegment:hour];
    NSLog(@"H: %d, M: %d ", h,m);
    
    // if language is de_DE ...
    if([lang isEqualToString:@"de_DE"]){
        // 1. Set minute label
        [time setObject:[self minuteToText:m] forKey:@"seg1"];
        // 2. Set prefix label
        [time setObject:[self getPrefix:m] forKey:@"seg2"];
        // 3. Set hour label
        NSString* hourlabel = @"";
        if(m==0 || m==60) hourlabel = @"Punkt ";
        else if(25<=m && m<=35) hourlabel = @"Halb ";
        [time setObject:[NSString stringWithFormat:@"%@%@",hourlabel,[self hoursToText:h:m]] forKey:@"seg3"];
        // 4. Set daytime label
        [time setObject:[self getDaytime] forKey:@"daytime"];
    }
    return time;
}

- (void) updateLabel:(RQShineLabel*)label :(NSString*)text {
    if(label.busy || (![label.text isEqualToString:text])){
        if (label.isVisible) {
            label.busy = true;
            [label fadeOutWithCompletion:^{
                label.text = text;
                if(![text isEqualToString:@"$HIDE$"]) [label shine];
                label.busy = false;
            }];
        }
        else {
            label.text = text;
            if(![text isEqualToString:@"$HIDE$"]) [label shine];
        }
    }
}

- (void) refreshTime {
    NSDictionary *time = [self getTimeArray];
    [self updateLabel:seg1 :[[time valueForKey:@"seg1"] uppercaseString]];
    [self updateLabel:seg2 :[[time valueForKey:@"seg2"] uppercaseString]];
    [self updateLabel:seg3 :[[time valueForKey:@"seg3"] uppercaseString]];
    [self updateLabel:date :[[self getDateString] uppercaseString]];
    [self updateLabel:daytime :[[time valueForKey:@"daytime"] uppercaseString]];
    daytimeIcon.attributedText = [[self getDaytimeIcon] attributedString];
    
}

#pragma mark  - gradient view delegate

- (NSArray *)gradientColorsForGradientView:(GBGradientView *)gradientView
{
    return [self.colors mutableCopy];
}

@end
