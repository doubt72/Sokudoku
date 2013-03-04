//
//  Character.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event;

@interface Character : NSObject {
@private
    NSString *literal;
    NSMutableArray *pronunciations;
    NSMutableArray *tags;
    
    float timesTested;
    float totalTime;
}

@property(copy) NSString *literal;

- (BOOL) pronunciationCorrect:(NSString *)input;
- (BOOL) startsWithPronunciation:(NSString *)input;

// withLength is the length of the total string that was tested; time is the total
// time.  From that, newEvent calculates the weighting internally
- (Event *) newEvent:(float)forLength:(float)time;

- (float) averageSpeed;

- (void) addTag:(NSString *)tag;
- (BOOL) hasTag:(NSString *)tag;

- (void) addPronunciation:(NSString *)pronunciation;

@end
