//
//  HistogramWindow.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/10/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MainWindow;
@class HistogramView;
@class Package;

@interface HistogramWindow : NSWindowController {
@package
    NSBox *boxView;
    NSButton *returnButton;
    NSPopUpButton *dataSets;
    
    MainWindow *parent;
    HistogramView *histogramView;
    
    Package *package;
}

@property IBOutlet NSView *boxView;
@property IBOutlet NSButton *returnButton;
@property IBOutlet NSPopUpButton *dataSets;

@property MainWindow *parent;
@property Package *package;

- (IBAction)doReturn:(id)sender;
- (IBAction)selectTag:(id)sender;

@end
