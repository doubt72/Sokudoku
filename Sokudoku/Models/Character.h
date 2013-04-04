//
//  Character.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
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

#import <Foundation/Foundation.h>
@class Event;

@interface Character : NSObject {
@private
    NSString *literal;
    NSMutableArray *pronunciations;
    NSMutableArray *tags;
    
    float timesTested;
    float totalTime;
    
    float incorrectAnswers;
    float correctAnswers;
}

@property(copy) NSString *literal;
@property float incorrectAnswers, correctAnswers;

// withLength is the length of the total string that was tested; time is the total
// time.  From that, newEvent calculates the weighting internally
- (Event *) newEventForLength:(int)length withTime:(float)time wasCorrect:(BOOL)correct;

// Average Speed; for character selection purposes (when picking which characters to
// drill) returns 10.0 for not-yet-drilled characters
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
- (NSArray *)appendAllPronunciations:(NSArray *)list withLiterals:(BOOL)includeLiteral;

- (void)reset;

@end
