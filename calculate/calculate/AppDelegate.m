//
//  AppDelegate.m
//  Calculate
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#define MIXPANEL_TOKEN @"f2f7c8d0d12bd422fdc9b1ef6d6ab0b2"

#import "AppDelegate.h"

#import <Crashlytics/Crashlytics.h>
#import "Mixpanel.h"

#import "Calculator.h"
#import "CalculatorViewController.h"

@implementation AppDelegate

Calculator *calculator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    calculator = [[Calculator alloc] init];
    
    CalculatorViewController *defaultView = (CalculatorViewController *)self.window.rootViewController;
    defaultView.calculator = calculator;
    
    // Crashlytics
    [Crashlytics startWithAPIKey:@"d8e4a998430741c25fc8939d85d1dee852ab2fb9"];
    
    // Initialize the library with your
    // Mixpanel project token, MIXPANEL_TOKEN
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    
    // Later, you can get your instance with
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"hh:mm a" options:0 locale:[NSLocale currentLocale]]];
    
    [mixpanel track:@"Test" properties:@{
        @"Opened": [dateFormatter stringFromDate:[NSDate date]],
        @"Plan": @"Free"
    }];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
