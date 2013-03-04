//
//  Character.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Character : NSObject {
@private
    NSString *literal;
    NSArray *pronunciations;
    
    float timesTested;
    float totalTime;
}

@property(copy) NSString *literal;
@property(copy) NSArray *pronunciation;

- (BOOL) pronunciationCorrect:(NSString *)input;
- (BOOL) startsWithPronunciation:(NSString *)input;

// withLength is the length of the total string that was tested; time is the total
// time.  From that, newEvent calculates the weighting internally
- (void) newEvent:(float)forLength:(float)time;

- (float) averageSpeed;

@end
