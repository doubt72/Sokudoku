//
//  GraphWindow.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/10/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class GraphView;
@class MainWindow;
@class Package;

@interface GraphWindow : NSWindowController {
@private
    NSButton *returnButton;

    NSPopUpButton *dataSet;
    NSPopUpButton *graphType;
    NSPopUpButton *timeFrame;
    
    GraphView *graphView;
    MainWindow *parent;
    
    Package *package;
}

@property IBOutlet NSButton *returnButton;
@property IBOutlet NSPopUpButton *dataSet;
@property IBOutlet NSPopUpButton *graphType;
@property IBOutlet NSPopUpButton *timeFrame;

@property IBOutlet GraphView *graphView;
@property MainWindow *parent;

@property Package *package;

- (IBAction)doReturn:(id)sender;
- (IBAction)changeDataSet:(id)sender;
- (IBAction)changeGraphType:(id)sender;
- (IBAction)changeTimeFrame:(id)sender;

@end
