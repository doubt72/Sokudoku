//
//  Character.m
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import "Character.h"

@implementation Character

@synthesize literal;
@synthesize pronunciation;

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
- (void)newEvent:(float)forLength :(float)time {
    float weight = 1.0 / (forLength * forLength);
    timesTested += weight;
    totalTime += time * weight;
}

- (float)averageSpeed {
    return totalTime / timesTested;
}

@end
