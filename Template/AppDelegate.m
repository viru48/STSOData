//
//  AppDelegate.m
//  Template
//
//  Created by Stadelman, Stan on 8/4/14.
//  Copyright (c) 2014 Stan Stadelman. All rights reserved.
//

#import "AppDelegate.h"
#import "LogonHandler.h"
#import "DataController.h"
#import "SODataOfflineStore.h"

#define kDefiningRequest1 @"TravelagencyCollection"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    [SODataOfflineStore GlobalInit];

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
    
/*
    Specify whether the DataController should operate in 'Online' or 'Offline' mode.  
    
    'Offline' mode uses the local database, that is synchronized via Mobilink.  All requests for 
    OData resources, that are included in the scope of the "defining requests" are read & written 
    to the local database.
    
    Requests for OData resources that are outside the scope of the defining requests, when in 
    Offline mode, or all (*) requests when in Online mode, are sent over the network.
*/
    [DataController shared].workingMode = WorkingModeOffline;
    [DataController shared].definingRequests = @[kDefiningRequest1];
    
/*
    Set applicationId for the application. This should match the applicationId in the SMP Admin 
    console.  
*/
    [[LogonHandler shared].logonManager setApplicationId:@"flight"];

/*
    Application is designed to collect information on the device, OS, and application, as well as
    developer-specified analytic information.  Requires HANA Cloud Platform, Mobile Services.

    Defaults to YES.  Set to NO, to disable usage collection.

    [LogonHandler shared].collectUsageData = NO;
*/

/*
    Always invoke logonManager logon at application launch.  This unlocks the DataVault, executes 
    registration if necessary, obtains credentials and connection settings, etc.  When logon 
    completes, the kLogonFinished notification is emitted by LogonHandler.
*/

    [[LogonHandler shared].logonManager logon];
    
    }

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [SODataOfflineStore GlobalFini];
}

@end
