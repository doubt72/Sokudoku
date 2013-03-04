//
//  Character.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "Character.h"
#import "Event.h"

@implementation Character

@synthesize literal;

- (BOOL)pronunciationCorrect:(NSString *)input {
    return [literal isEqualToString:input];
}

- (BOOL)startsWithPronunciation:(NSString *)input {
    for (int i = 1; i <= [input length]; i++) {
        if ([self pronunciationCorrect:[input substringToIndex:i]]) {
            return YES;
        }
    }
    return NO;
}

// Because characters are only tested in isolation when the string being tested is
// one character long, we weigh the results so that long strings affect the average
// time less than shorter strings
- (Event *)newEvent:(float)forLength :(float)time {
    float weight = 1.0 / (forLength * forLength);
    timesTested += weight;
    totalTime += time * weight;
    
    Event *event = [[Event alloc] init];
    [event setCharacter:self];
    [event setTimeStamp:[NSDate date]];
    [event setWeight:weight];
    [event setWeightedTime:totalTime];
    return event;
}

- (float)averageSpeed {
    return totalTime / timesTested;
}

- (void)addTag:(NSString *)tag {
    [tags addObject:tag];
}

- (BOOL)hasTag:(NSString *)tag {
    return [tags containsObject:tag];
}

- (void)addPronunciation:(NSString *)pronunciation {
    [pronunciations addObject:pronunciation];
}

- (id)init {
    if (self = [super init]) {
        tags = [NSMutableArray arrayWithCapacity:1];
        pronunciations = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

@end
