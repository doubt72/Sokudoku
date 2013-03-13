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
    NSScrollView *scrollView;
    NSButton *returnButton;
    NSPopUpButton *dataSets;
    NSPopUpButton *subset;
    
    MainWindow *parent;
    HistogramView *histogramView;
    
    Package *package;
    
    BOOL top;
}

@property IBOutlet NSScrollView *scrollView;
@property IBOutlet NSButton *returnButton;
@property IBOutlet NSPopUpButton *dataSets;
@property IBOutlet NSPopUpButton *subset;
@property IBOutlet HistogramView *histogramView;

@property MainWindow *parent;
@property Package *package;

- (IBAction)doReturn:(id)sender;
- (IBAction)selectTag:(id)sender;
- (IBAction)selectSubset:(id)sender;

@end
