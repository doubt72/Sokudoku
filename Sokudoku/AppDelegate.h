//
//  AppDelegate.h
//  Sokudoku
//
//  Created by Douglas Triggs on 2/26/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MainWindow;
@class StartupWindow;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    MainWindow *mainWindow;
    StartupWindow *startupWindow;
}

@property MainWindow *mainWindow;
@property StartupWindow *startupWindow;

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender;

- (void) startupFinished;

@end
