//
//  History.h
//  Sokudoku
//
//  Created by Douglas Triggs on 3/3/13.
//  Copyright (c) 2013 Douglas Triggs. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Event;

@interface History : NSObject {
@private
    NSMutableArray *events;
}

- (void) addEvent:(Event *)event;

- (void) save:(NSString *)fileName;
- (void) load:(NSString *)fileName;

- (void) clear;

- (NSArray *) allEvents;

@end
