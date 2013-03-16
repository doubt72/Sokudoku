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

// withLength is the length of the total string that was tested; time is the total
// time.  From that, newEvent calculates the weighting internally
- (Event *) newEvent:(float)forLength:(float)time;

// Average Speed; for character selection purposes (when picking which characters to
// drill) returns 5.0 for not-yet-drilled characters
- (float) averageSpeed;

// Whether or not the character has been drilled on yet
- (BOOL) tested;

- (void) addTag:(NSString *)tag;
- (BOOL) hasTag:(NSString *)tag;

- (void) addPronunciation:(NSString *)pronunciation;

// For loading and saving character records
- (NSMutableDictionary *) toDictionary;
- (void) fromDictionary:(NSMutableDictionary *)dict;

// This is used for generating all possible pronunciations (for testing correct answers).
// This takes a list and appends all the possible pronunciation to the end of the
// supplied strings and returns them in a list
- (NSArray *)appendAllPronunciations:(NSArray *)list;

- (void)reset;

@end
