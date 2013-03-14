//
//  AppDelegate.m
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "AppDelegate.h"
#import "MainWindow.h"
#import "StartupWindow.h"

@implementation AppDelegate

@synthesize mainWindow, startupWindow;

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)startupFinished {
    [startupWindow close];
    
    mainWindow = [[MainWindow alloc] initWithWindowNibName:@"MainWindow"];
    [mainWindow showWindow:self];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    startupWindow = [[StartupWindow alloc] initWithWindowNibName:@"StartupWindow"];
    [startupWindow showWindow:self];
    
    [startupWindow setParent:self];
}

@end
