//
//  GraphView.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/14/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "GraphView.h"
#import "Package.h"
#import "Event.h"

@implementation GraphView

@synthesize package, tag, timeFrame, graphType;

- (BOOL) isFlipped {
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        timeFrame = 7;
        graphType = 0;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = [self bounds];
    float boundsX = rect.size.width;
    float boundsY = rect.size.height;
    
    float scale = boundsX / 60;
    
    [[NSColor colorWithCalibratedRed:0.25 green:0.25 blue:0.25 alpha:1.0] set];
    [NSBezierPath fillRect:rect];

    NSColor *baseColor = [NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.75
                                                   alpha:1.0];
    [baseColor set];
    
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:NSMakePoint(0 + scale*3, 0 + scale)];
    [line lineToPoint:NSMakePoint(0 + scale*3, boundsY - scale*2)];
    [line lineToPoint:NSMakePoint(boundsX - scale, boundsY - scale*2)];
    [line setLineWidth:1];
    [line stroke];

    NSFont *font = [NSFont systemFontOfSize:scale];
    NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:font,
                          NSFontAttributeName, baseColor,
                          NSForegroundColorAttributeName, nil];
    NSString *text = @"0";
    CGSize size = [text sizeWithAttributes:attr];
    [text drawAtPoint:NSMakePoint(scale*2.5 - size.width,
                                  boundsY - scale*1.5 - size.height) withAttributes:attr];
    
    int interval = timeFrame / 6;
    for (int i = interval; i <= timeFrame; i += interval) {
        text = [NSString stringWithFormat:@"%d", i - 1];
        size = [text sizeWithAttributes:attr];
        [text drawAtPoint:NSMakePoint(boundsX - (((float)i - 0.5) / (float)timeFrame) *
                                      (boundsX - scale*4) - scale - size.width/2,
                                      boundsY - scale/2 - size.height) withAttributes:attr];
    }
    
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:timeFrame];
    for (int i = 0; i < timeFrame; i++) {
        if (graphType == 0 || graphType == 3) {
            [data addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                             [NSNumber numberWithInt:0], nil]];
        } else if (graphType == 1) {
            [data addObject:[NSNumber numberWithFloat:0]];
        } else if (graphType == 2) {
            [data addObject:[NSNumber numberWithInt:0]];
        }
    }
    NSArray *events = [package allEvents:tag];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:now];
    long offset = (23 - [components hour]) * 60 * 60 + (59 - [components minute]) * 60 + (59 - [components second]) + 1;

    for (int i = 0; i < [events count]; i++) {
        Event *event = [events objectAtIndex:i];
        NSTimeInterval when = [[event timeStamp] timeIntervalSinceNow] - offset;
        int bucket = -when / 60 / 60 / 24;
        if (bucket >= timeFrame) {
            continue;
        }
        float unWeight = sqrtf([event weight]);
        float unWeightedTime = [event weightedTime] / [event weight] * unWeight;
        if (graphType == 0 || graphType == 3) {
            NSArray *oldObject = [data objectAtIndex:bucket];
            NSArray *newObject = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[[oldObject objectAtIndex:0] floatValue] + unWeightedTime], [NSNumber numberWithInt:[[oldObject objectAtIndex:1] intValue] + 1], nil];
            [data replaceObjectAtIndex:bucket withObject:newObject];
        } else if (graphType == 1) {
            [data replaceObjectAtIndex:bucket withObject:[NSNumber numberWithFloat:[[data objectAtIndex:bucket] floatValue] + unWeightedTime]];
        } else if (graphType == 2) {
            [data replaceObjectAtIndex:bucket withObject:[NSNumber numberWithInt:[[data objectAtIndex:bucket] intValue] + 1]];
        }
    }
    
    float maxValue = 0;
    float altMaxValue = 0;
    for (int i = 0; i < [data count]; i++) {
        if (graphType == 0) {
            float average = ([[[data objectAtIndex:i] objectAtIndex:0] floatValue] /
                             [[[data objectAtIndex:i] objectAtIndex:1] floatValue]);
            if (average > maxValue) {
                maxValue = average;
            }
        } else if (graphType == 1) {
            float value = [[data objectAtIndex:i] floatValue];
            if (value > maxValue) {
                maxValue = value;
            }
        } else if (graphType == 2) {
            int value = [[data objectAtIndex:i] intValue];
            if (value > maxValue) {
                maxValue = value;
            }
        } else if (graphType == 3) {
            float average = ([[[data objectAtIndex:i] objectAtIndex:0] floatValue] /
                             [[[data objectAtIndex:i] objectAtIndex:1] floatValue]);
            if (average > altMaxValue) {
                altMaxValue = average;
            }
            float value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
            if (value > maxValue) {
                maxValue = value;
            }
        }
    }
    if (graphType == 1 || graphType == 3) {
        text = [NSString stringWithFormat:@"%d", (int)maxValue / 60];
    } else if (graphType == 2) {
        text = [NSString stringWithFormat:@"%d", (int)maxValue];
    } else {
        text = [NSString stringWithFormat:@"%.1f", maxValue];
    }
    size = [text sizeWithAttributes:attr];
    [text drawAtPoint:NSMakePoint(scale*2.5 - size.width,
                                  scale*2 - size.height) withAttributes:attr];
    
    for (int i = 0; i < timeFrame; i++) {
        float value;
        if (graphType == 0) {
            if ([[[data objectAtIndex:i] objectAtIndex:1] intValue] != 0) {
                value = ([[[data objectAtIndex:i] objectAtIndex:0] floatValue] /
                                [[[data objectAtIndex:i] objectAtIndex:1] floatValue]);
            } else {
                value = 0;
            }
        } else if (graphType == 1) {
            value = [[data objectAtIndex:i] floatValue];
        } else if (graphType == 2) {
            value = [[data objectAtIndex:i] intValue];
        } else if (graphType == 3) {
            value = [[[data objectAtIndex:i] objectAtIndex:0] floatValue];
        }
        float width = (boundsX - scale*4) / (float)timeFrame;
        float start = scale*3 + (boundsX - scale*4) * (1 - (float)i / (float)timeFrame) - width;
        [[NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:1.0] set];
        rect = NSMakeRect(start + 1, scale + (boundsY - scale*3) * (1 - value / maxValue), width, (boundsY - scale*3) * (value / maxValue) - 1);
        [NSBezierPath fillRect:rect];
    }
    
    [[NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.25 alpha:1.0] set];

    float lastValue = 0;
    line = nil;
    if (graphType == 3) {
        for (int i = timeFrame - 1; i >= 0; i--) {
            float value = lastValue;
            if ([[[data objectAtIndex:i] objectAtIndex:1] intValue] != 0) {
                value = ([[[data objectAtIndex:i] objectAtIndex:0] floatValue] /
                         [[[data objectAtIndex:i] objectAtIndex:1] floatValue]);
                lastValue = value;
            }
            float width = (boundsX - scale*4) / (float)timeFrame;
            float start = scale*3 + (boundsX - scale*4) * (1 - ((float)i - 0.5) / (float)timeFrame) - width;
            if (line == nil) {
                line = [NSBezierPath bezierPath];
                [line moveToPoint:NSMakePoint(scale*3 + 1, scale + (boundsY - scale*3) * (1 - value / altMaxValue) - 1)];
                [line lineToPoint:NSMakePoint(start + 1, scale + (boundsY - scale*3) * (1 - value / altMaxValue) - 1)];
            } else {
                [line lineToPoint:NSMakePoint(start + 1, scale + (boundsY - scale*3) * (1 - value / altMaxValue) - 1)];
            }
        }
    }
    [line lineToPoint:NSMakePoint(boundsX - scale, scale + (boundsY - scale*3) * (1 - lastValue / altMaxValue) - 1)];
    [line setLineWidth:1];
    [line stroke];
}

@end
