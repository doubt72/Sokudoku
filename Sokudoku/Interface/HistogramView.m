//
//  HistogramView.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/11/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "HistogramView.h"
#import "Package.h"

@implementation HistogramView
@synthesize package;
@synthesize tag;
@synthesize top;

- (BOOL) isFlipped {
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Get characters for graph
    NSArray *array = [package statsForTag:tag:top];
    
    NSScrollView *scrollView = [self enclosingScrollView];
    NSSize size = [scrollView contentSize];
    float boundsX = size.width;
    float boundsY = size.height;

    // Set up attributes for display
    NSColor *color = [NSColor darkGrayColor];
    NSFont *font = [NSFont systemFontOfSize:28];
    NSFont *timeFont = [NSFont systemFontOfSize:14];
    NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:font,
                          NSFontAttributeName, color, NSForegroundColorAttributeName, nil];
    NSDictionary *timeAttr = [[NSDictionary alloc] initWithObjectsAndKeys:timeFont,
                              NSFontAttributeName, color,
                              NSForegroundColorAttributeName, nil];
    NSString *testText = [[array objectAtIndex:0] objectAtIndex:0];
    CGSize textSize = [testText sizeWithAttributes:attr];

    // Find maximum character size
    for (int i = 0; i < [array count]; i++) {
        NSString *literal = [[array objectAtIndex:i] objectAtIndex:0];
        if (textSize.width < [literal sizeWithAttributes:attr].width) {
            textSize = [literal sizeWithAttributes:attr];
        }
    }

    // Calculate display bounds
    if (boundsY < textSize.height * [array count] + 20) {
        boundsY = textSize.height * [array count] + 20;
    }
    [self setFrameSize:NSMakeSize(boundsX, boundsY)];

    // Draw characters
    BOOL even = NO;
    float currentY = 10;
    for (int i = 0; i < [array count]; i++) {
        if (even) {
            // Draw alternate background
            NSRect rect = NSMakeRect(0, currentY, boundsX, textSize.height);
            [[NSColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:1.0] set];
            [NSBezierPath fillRect:rect];
        }
        NSString *literal = [[array objectAtIndex:i] objectAtIndex:0];
        float width = textSize.width;
        [literal drawAtPoint:NSMakePoint(boundsX - width - 10,
                                         currentY) withAttributes:attr];
        currentY += textSize.height;
        even = !even;
    }
    currentY = 10;

    // Find maximum length for longest bar
    float maxlength;
    if (top) {
        maxlength = [[[array objectAtIndex:0] objectAtIndex:1] floatValue];
    } else {
        maxlength = [[[array lastObject] objectAtIndex:1] floatValue];
    }

    // Draw bars a times for average speeds for characters
    for (int i = 0; i < [array count]; i++) {
        float time = [[[array objectAtIndex:i] objectAtIndex:1] floatValue];
        NSString *timeString = @"-----";
        if (time > 0) {
            int seconds = (int)time;
            int hundreds = (int)(time * 100) % 100;
            timeString = [NSString stringWithFormat:@"%.2d.%.2d", seconds, hundreds];
        }
        CGSize timeSize = [timeString sizeWithAttributes:timeAttr];
        float timeOffset = (timeSize.height - textSize.height) / 2;
        [timeString drawAtPoint:NSMakePoint(10, currentY - timeOffset)
                 withAttributes:timeAttr];
        float length = (boundsX - textSize.width - timeSize.width - 30) * (time / maxlength);
        float height = textSize.height * 0.5;
        float offset = textSize.height * 0.25;
        NSRect rect = NSMakeRect(timeSize.width + 15, currentY + offset, length, height);
        [[NSColor darkGrayColor] set];
        [NSBezierPath fillRect:rect];
        currentY += textSize.height;
    }
}

@end
