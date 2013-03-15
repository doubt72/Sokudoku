//
//  GraphView.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/14/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class Package;

@interface GraphView : NSView {
@private
    Package *package;

    NSString *tag;
    int timeFrame;
    int graphType;
}

@property Package *package;
@property NSString *tag;
@property int timeFrame, graphType;

@end
