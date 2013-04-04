//
//  GraphView.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/14/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License"); you
// may not use this file except in compliance with the License. You may
// obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
// implied. See the License for the specific language governing
// permissions and limitations under the License.

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
        graphType = AVG_SPEED;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = [self bounds];
    float boundsX = rect.size.width;
    float boundsY = rect.size.height;
    
    float scale = boundsX / 60;

    // Draw view background
    [[NSColor colorWithCalibratedRed:0.25 green:0.25 blue:0.25 alpha:1.0] set];
    [NSBezierPath fillRect:rect];

    // Draw axes (with values)
    NSColor *baseColor = [NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.75
                                                   alpha:1.0];
    [baseColor set];
    
    NSBezierPath *line = [NSBezierPath bezierPath];
    [line moveToPoint:NSMakePoint(0 + scale*3, 0 + scale)];
    [line lineToPoint:NSMakePoint(0 + scale*3, boundsY - scale*2)];
    [line lineToPoint:NSMakePoint(boundsX - scale, boundsY - scale*2)];
    [line setLineWidth:1];
    [line stroke];

    // Set text attributes
    NSFont *font = [NSFont systemFontOfSize:scale];
    NSDictionary *attr = [[NSDictionary alloc] initWithObjectsAndKeys:font,
                          NSFontAttributeName, baseColor,
                          NSForegroundColorAttributeName, nil];
    NSString *text = @"0";
    CGSize size = [text sizeWithAttributes:attr];
    [text drawAtPoint:NSMakePoint(scale*2.5 - size.width,
                                  boundsY - scale*1.5 - size.height) withAttributes:attr];

    // Draw value intervals (days) on graph bottom
    int interval = timeFrame / 6;
    for (int i = interval; i <= timeFrame; i += interval) {
        text = [NSString stringWithFormat:@"%d", i - 1];
        size = [text sizeWithAttributes:attr];
        [text drawAtPoint:NSMakePoint(boundsX - (((float)i - 0.5) / (float)timeFrame) *
                                      (boundsX - scale*4) - scale - size.width/2,
                                      boundsY - scale/2 - size.height) withAttributes:attr];
    }

    // Calculate data to graph -- initialize array for graph elements
    NSMutableArray *data = [NSMutableArray arrayWithCapacity:timeFrame];
    for (int i = 0; i < timeFrame; i++) {
        if (graphType == AVG_SPEED) {
            [data addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:0], nil]];
        } else if (graphType == STUDY_TIME) {
            [data addObject:[NSNumber numberWithFloat:0]];
        } else if (graphType == CHARACTER_COUNT) {
            [data addObject:[NSNumber numberWithInt:0]];
        } else if (graphType == STUDY_TIME_WITH_SPEED) {
            [data addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:0], nil]];
        } else if (graphType == CORRECT_RATE_WITH_COUNT || graphType == CORRECT_RATE) {
            [data addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0],
                             [NSNumber numberWithFloat:0], nil]];
        }
    }
    NSArray *events = [package eventsForTag:tag];

    // Calculate offset (i.e., offset to calculate beginning of yesterday = 1 day ago)
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:now];
    long offset = (23 - [components hour]) * 60 * 60 + (59 - [components minute]) * 60 + (59 - [components second]) + 1;

    // Calculate data for graph from events
    for (int i = 0; i < [events count]; i++) {
        Event *event = [events objectAtIndex:i];
        NSTimeInterval when = [[event timeStamp] timeIntervalSinceNow] - offset;
        int bucket = -when / 60 / 60 / 24;
        if (bucket >= timeFrame) {
            continue;
        }
        float weight = [event weight];
        float weightedTime = [event weightedTime];
        float partialTime = [event partialTime];
        if (graphType == AVG_SPEED) {
            NSArray *oldObject = [data objectAtIndex:bucket];
            NSArray *newObject = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[[oldObject objectAtIndex:0] floatValue] + weightedTime],
                                  [NSNumber numberWithFloat:[[oldObject objectAtIndex:1] floatValue] + weight], nil];
            [data replaceObjectAtIndex:bucket withObject:newObject];
        } else if (graphType == STUDY_TIME) {
            [data replaceObjectAtIndex:bucket withObject:[NSNumber numberWithFloat:[[data objectAtIndex:bucket] floatValue] + partialTime]];
        } else if (graphType == CHARACTER_COUNT) {
            [data replaceObjectAtIndex:bucket withObject:[NSNumber numberWithInt:[[data objectAtIndex:bucket] intValue] + 1]];
        } else if (graphType == STUDY_TIME_WITH_SPEED) {
            NSArray *oldObject = [data objectAtIndex:bucket];
            NSArray *newObject = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[[oldObject objectAtIndex:0] floatValue] + weightedTime],
                                  [NSNumber numberWithFloat:[[oldObject objectAtIndex:1] floatValue] + weight],
                                  [NSNumber numberWithFloat:[[oldObject objectAtIndex:2] floatValue] + partialTime], nil];
            [data replaceObjectAtIndex:bucket withObject:newObject];
        } else if (graphType == CORRECT_RATE_WITH_COUNT || graphType == CORRECT_RATE) {
            float currCorrect = [[[data objectAtIndex:bucket] objectAtIndex:0] floatValue];
            float currInCorrect = [[[data objectAtIndex:bucket] objectAtIndex:1] floatValue];
            float currEvent = [event correct];
            if (currEvent > 0) {
                currCorrect += currEvent;
            } else {
                currInCorrect += -currEvent;
            }
            [data replaceObjectAtIndex:bucket
                            withObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:currCorrect], [NSNumber numberWithFloat:currInCorrect], nil]];
        }
    }

    // Find maximum values to caligraph data bars
    float maxValue = 0;
    float altMaxValue = 0;
    for (int i = 0; i < [data count]; i++) {
        if (graphType == AVG_SPEED) {
            float average = ([[[data objectAtIndex:i] objectAtIndex:0] floatValue] /
                             [[[data objectAtIndex:i] objectAtIndex:1] floatValue]);
            if (average > maxValue) {
                maxValue = average;
            }
        } else if (graphType == STUDY_TIME) {
            float value = [[data objectAtIndex:i] floatValue];
            if (value > maxValue) {
                maxValue = value;
            }
        } else if (graphType == CHARACTER_COUNT) {
            int value = [[data objectAtIndex:i] intValue];
            if (value > maxValue) {
                maxValue = value;
            }
        } else if (graphType == STUDY_TIME_WITH_SPEED) {
            float average = ([[[data objectAtIndex:i] objectAtIndex:0] floatValue] /
                             [[[data objectAtIndex:i] objectAtIndex:1] floatValue]);
            if (average > altMaxValue) {
                altMaxValue = average;
            }
            float value = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
            if (value > maxValue) {
                maxValue = value;
            }
        } else if (graphType == CORRECT_RATE_WITH_COUNT) {
            int currCorrect = [[[data objectAtIndex:i] objectAtIndex:0] intValue];
            int currInCorrect = [[[data objectAtIndex:i] objectAtIndex:1] intValue];
            if (currCorrect + currInCorrect > maxValue) {
                maxValue = currInCorrect + currCorrect;
            }
            if ((float)currInCorrect / (float)(currCorrect + currInCorrect) > altMaxValue) {
                altMaxValue = (float)currInCorrect / (float)(currCorrect + currInCorrect);
            }
        } else if (graphType == CORRECT_RATE) {
            int currCorrect = [[[data objectAtIndex:i] objectAtIndex:0] intValue];
            int currInCorrect = [[[data objectAtIndex:i] objectAtIndex:1] intValue];
            if ((float)currInCorrect / (float)(currCorrect + currInCorrect) > maxValue) {
                maxValue = (float)currInCorrect / (float)(currCorrect + currInCorrect);
            }
        }
    }
    // Display maximum value on graph
    if (graphType == STUDY_TIME || graphType == STUDY_TIME_WITH_SPEED) {
        text = [NSString stringWithFormat:@"%d", (int)maxValue / 60];
    } else if (graphType == CHARACTER_COUNT || graphType == CORRECT_RATE_WITH_COUNT) {
        text = [NSString stringWithFormat:@"%d", (int)maxValue];
    } else if (graphType == CORRECT_RATE) {
        text = [NSString stringWithFormat:@"%.1f", maxValue * 100];
    } else {
        text = [NSString stringWithFormat:@"%.1f", maxValue];
    }
    size = [text sizeWithAttributes:attr];
    [text drawAtPoint:NSMakePoint(scale*2.5 - size.width,
                                  scale*2 - size.height) withAttributes:attr];

    // Draw data bars
    for (int i = 0; i < timeFrame; i++) {
        float value = 0;
        if (graphType == AVG_SPEED) {
            if ([[[data objectAtIndex:i] objectAtIndex:1] intValue] != 0) {
                value = ([[[data objectAtIndex:i] objectAtIndex:0] floatValue] /
                                [[[data objectAtIndex:i] objectAtIndex:1] floatValue]);
            } else {
                value = 0;
            }
        } else if (graphType == STUDY_TIME) {
            value = [[data objectAtIndex:i] floatValue];
        } else if (graphType == CHARACTER_COUNT) {
            value = [[data objectAtIndex:i] intValue];
        } else if (graphType == STUDY_TIME_WITH_SPEED) {
            value = [[[data objectAtIndex:i] objectAtIndex:2] floatValue];
        } else if (graphType == CORRECT_RATE_WITH_COUNT) {
            value = ([[[data objectAtIndex:i] objectAtIndex:0] intValue] +
                     [[[data objectAtIndex:i] objectAtIndex:1] intValue]);
        } else if (graphType == CORRECT_RATE) {
            int currCorrect = [[[data objectAtIndex:i] objectAtIndex:0] intValue];
            int currInCorrect = [[[data objectAtIndex:i] objectAtIndex:1] intValue];
            if (currCorrect + currInCorrect > 0) {
                value = (float)currInCorrect / (float)(currCorrect + currInCorrect);
            }
        }
        float width = (boundsX - scale*4) / (float)timeFrame;
        float start = scale*3 + (boundsX - scale*4) * (1 - (float)i / (float)timeFrame) - width;
        if (graphType == CORRECT_RATE_WITH_COUNT) {
            [[NSColor colorWithCalibratedRed:0.25 green:0.5 blue:0.25 alpha:1.0] set];
        } else {
            [[NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:1.0] set];
        }
        rect = NSMakeRect(start + 1, scale + (boundsY - scale*3) * (1 - value / maxValue), width, (boundsY - scale*3) * (value / maxValue) - 1);
        [NSBezierPath fillRect:rect];
        
        if (graphType == CORRECT_RATE_WITH_COUNT) {
            value = [[[data objectAtIndex:i] objectAtIndex:1] intValue];
            start = scale*3 + (boundsX - scale*4) * (1 - (float)i / (float)timeFrame) - width;
            [[NSColor colorWithCalibratedRed:0.65 green:0.25 blue:0.25 alpha:1.0] set];
            rect = NSMakeRect(start + 1, scale + (boundsY - scale*3) * (1 - value / maxValue), width, (boundsY - scale*3) * (value / maxValue) - 1);
            [NSBezierPath fillRect:rect];
        }
    }

    // Draw line for average speed for combination graph
    [[NSColor colorWithCalibratedRed:0.75 green:0.75 blue:0.25 alpha:1.0] set];

    float lastValue = 0;
    line = nil;
    if (graphType == STUDY_TIME_WITH_SPEED || graphType == CORRECT_RATE_WITH_COUNT) {
        for (int i = timeFrame - 1; i >= 0; i--) {
            float value = lastValue;
            if (graphType == STUDY_TIME_WITH_SPEED) {
                if ([[[data objectAtIndex:i] objectAtIndex:1] intValue] != 0) {
                    value = ([[[data objectAtIndex:i] objectAtIndex:0] floatValue] /
                             [[[data objectAtIndex:i] objectAtIndex:1] floatValue]);
                    lastValue = value;
                }
            } else if (graphType == CORRECT_RATE_WITH_COUNT) {
                int currCorrect = [[[data objectAtIndex:i] objectAtIndex:0] intValue];
                int currInCorrect = [[[data objectAtIndex:i] objectAtIndex:1] intValue];
                if (currCorrect + currInCorrect > 0) {
                    value = (float)currInCorrect / (float)(currCorrect + currInCorrect);
                    lastValue = value;
                }
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
        [line lineToPoint:NSMakePoint(boundsX - scale, scale + (boundsY - scale*3) * (1 - lastValue / altMaxValue) - 1)];
        [line setLineWidth:1];
        [line stroke];
    }
}

@end
