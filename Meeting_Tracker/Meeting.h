//
//  Meeting.h
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/8/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *personsBillingRateKeypath;

@interface Meeting : NSObject
{
	NSDate *_startingTime;
	NSDate *_endingTime;
	
	NSMutableArray *_personsPresent;
	NSNumber *_computedTotalBillingRate;
}

- (NSDate *)startingTime;
- (void)setStartingTime:(NSDate *)aStartingTime;
- (NSDate *)endingTime;
- (void)setEndingTime:(NSDate *)anEndingTime;
- (NSMutableArray *)personsPresent;
- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent;
- (NSNumber *)computedTotalBillingRate;
- (void)setComputedTotalBillingRate:(NSNumber *)aRate;

- (void)addToPersonsPresent:(id)personsPresentObject;
- (void)removeFromPersonsPresent:(id)personsPresentObject;

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx;

- (void)startObservingPersonsPresent;
- (void)stopObservingPersonsPresent;

- (NSUInteger)countOfPersonsPresent;
- (NSUInteger)elapsedSeconds;
- (double)elapsedHours;
- (NSString *)elapsedTimeDisplayString;

- (NSNumber *)accruedCost;
- (NSNumber *)totalBillingRate;
- (NSNumber *)fastEnumTotalBillingRate;
- (void)updateTotalBillingRate;

+ (Meeting *)meetingWithStooges;
+ (Meeting *)meetingWithCaptains;
+ (Meeting *)meetingWithMarxBrothers;

@end
