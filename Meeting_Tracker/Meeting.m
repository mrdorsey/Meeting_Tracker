//
//  Meeting.m
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/8/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

@implementation Meeting

NSString *personsBillingRateKeypath = @"hourlyRate";

- (id)init
{
	if (self = [super init]) {
		_personsPresent = [[NSMutableArray alloc] init];
		_computedTotalBillingRate = [[NSNumber numberWithDouble:0.0] retain];
	}
	return self;
}

- (void)dealloc
{
    [_startingTime release];
    _startingTime = nil;
	
	[_endingTime release];
    _endingTime = nil;
	
	[self stopObservingPersonsPresent];

	[_personsPresent release];
    _personsPresent = nil;
	
	[_computedTotalBillingRate release];
	_computedTotalBillingRate = nil;

    [super dealloc];
}

+ (NSSet *)keyPathsForValuesAffectingComputedTotalBillingRate
{
	return [NSSet setWithObject:@"personsPresent"];
}

+ (NSSet *)keyPathsForValuesAffectingTotalBillingRate
{
    return [NSSet setWithObject:@"personsPresent"];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<Meeting %lu participants %@/hour>", [self countOfPersonsPresent], [self totalBillingRate]];
}

- (NSDate *)startingTime {
	return _startingTime;
}

- (void)setStartingTime:(NSDate *)aStartingTime
{
    if ( _startingTime != aStartingTime )
    {
        [_startingTime release];
        _startingTime = [aStartingTime copy];
    }
}

- (NSDate *)endingTime {
	return _endingTime;
}

- (void)setEndingTime:(NSDate *)anEndingTime
{
    if ( _endingTime != anEndingTime )
    {
		[anEndingTime retain];
        [_endingTime release];
        _endingTime = anEndingTime;
    }
}

- (NSMutableArray *)personsPresent
{
	return _personsPresent;
}

- (BOOL)canStart {
	return ((self.personsPresent.count > 0) &&
			!self.startingTime);
}

- (BOOL)canStop {
	return ((!self.endingTime) && self.startingTime);
}

- (BOOL)canRepopulate {
	return (!self.startingTime);
}

- (void)stopObservingPersonsPresent {
	for(Person *person in [self personsPresent]) {
		[person removeObserver:self forKeyPath:personsBillingRateKeypath];
	}
}

- (void)startObservingPersonsPresent {
	for(Person *person in [self personsPresent]) {
		[person addObserver:self forKeyPath:personsBillingRateKeypath
					options:NSKeyValueObservingOptionNew context:nil];
	}
}

- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent {
    if ( _personsPresent != aPersonsPresent )
    {
		[aPersonsPresent retain];
		[self stopObservingPersonsPresent];
        [_personsPresent release];
        _personsPresent = aPersonsPresent;
		[self startObservingPersonsPresent];
		[self updateTotalBillingRate];
    }
}

- (void)addToPersonsPresent:(id)personsPresentObject {
	[[self personsPresent] addObject:personsPresentObject];
	[self updateTotalBillingRate];
}

- (void)removeFromPersonsPresent:(id)personsPresentObject {
	[[self personsPresent] removeObject: personsPresentObject];
	[self updateTotalBillingRate];
}

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx {
	[[[self personsPresent] objectAtIndex: idx] removeObserver:self forKeyPath:personsBillingRateKeypath];
	[[self personsPresent] removeObjectAtIndex: idx];
	[self updateTotalBillingRate];
}

- (void)insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx {
	[[self personsPresent] insertObject:anObject atIndex:idx];
	[self updateTotalBillingRate];
	[anObject addObserver:self forKeyPath:personsBillingRateKeypath
				  options:NSKeyValueObservingOptionNew context:nil];
}

- (NSUInteger)countOfPersonsPresent {
	return [[self personsPresent] count];
}

- (NSUInteger)elapsedSeconds {
	if([self startingTime] == nil) {
		return 0;
	}
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger secondFlag = NSSecondCalendarUnit;
	NSDate *endDate = [NSDate date];
	if([self endingTime] != nil) {
		endDate = [self endingTime];
	}
	NSDateComponents *components = [gregorian components:secondFlag
												fromDate:[self startingTime]
												toDate:endDate
												options:0];
	
	[gregorian release];
	return [components second];
}

- (double)elapsedHours {
	if([self startingTime] == nil) {
		return 0;
	}
	
	NSCalendar *gregorian = [[NSCalendar alloc]
							 initWithCalendarIdentifier:NSGregorianCalendar];
	NSUInteger hourFlag = NSHourCalendarUnit;
	NSDate *endDate = [NSDate date];
	if([self endingTime] != nil) {
		endDate = [self endingTime];
	}
	NSDateComponents *components = [gregorian components:hourFlag
												fromDate:[self startingTime]
												toDate:endDate
												options:0];
	
	[gregorian release];
	return [components hour];
}

- (NSString *)elapsedTimeDisplayString {
	
	NSUInteger elapsedSeconds = [self elapsedSeconds];
	NSUInteger displaySeconds, displayMinutes, displayHours;
	displayHours = elapsedSeconds / 3600;
	displayMinutes = (elapsedSeconds / 60) % 60;
	displaySeconds = elapsedSeconds % 60;
	
	return [NSString stringWithFormat:@"%0ld:%02ld:%02ld", displayHours, displayMinutes, displaySeconds];
}

- (NSNumber *)accruedCost {
	double accruedCost = 0;
	
	for (Person *person in [self personsPresent]) {
		accruedCost = accruedCost + ([[person hourlyRate] doubleValue] / 3600) * [self elapsedSeconds];
	}
	
	return [NSNumber numberWithDouble:accruedCost];
}

- (NSNumber *)fastEnumTotalBillingRate {
	double totalRate = 0;
	
	for (Person * person in [self personsPresent]) {
		totalRate = totalRate + [[person hourlyRate] doubleValue];
	}
	
	return [NSNumber numberWithDouble:totalRate];
}

- (NSNumber *)totalBillingRate {
	double totalRate = 0;
	
	for (Person * person in [self personsPresent]) {
		totalRate = totalRate + [[person hourlyRate] doubleValue];
	}
	
	return [NSNumber numberWithDouble:totalRate];
}

- (NSNumber *)computedTotalBillingRate {
	return _computedTotalBillingRate;
}

- (void)setComputedTotalBillingRate:(NSNumber *)newRate {
	if ( _computedTotalBillingRate != newRate )
    {
		[newRate retain];
        [_computedTotalBillingRate release];
        _computedTotalBillingRate = newRate;
    }
}

- (void)updateTotalBillingRate {
	[self setComputedTotalBillingRate:[self fastEnumTotalBillingRate]];
}

+ (Meeting *)meetingWithStooges {
	Meeting *stoogeMeeting = [[[Meeting alloc] init] autorelease];
	
	[stoogeMeeting insertObject:[Person personWithName:@"Larry" hourlyRate:3.]inPersonsPresentAtIndex:0];
	[stoogeMeeting insertObject:[Person personWithName:@"Moe" hourlyRate:6.]inPersonsPresentAtIndex:0];
	[stoogeMeeting insertObject:[Person personWithName:@"Curly" hourlyRate:9.]inPersonsPresentAtIndex:0];
	
	[stoogeMeeting startObservingPersonsPresent];
	
    return stoogeMeeting;
}

+ (Meeting *)meetingWithCaptains {
	Meeting *captainMeeting = [[[Meeting alloc] init] autorelease];
	
	[captainMeeting insertObject:[Person personWithName:@"Kirk" hourlyRate:1.]inPersonsPresentAtIndex:0];
	[captainMeeting insertObject:[Person personWithName:@"Picard" hourlyRate:2.]inPersonsPresentAtIndex:0];
	[captainMeeting insertObject:[Person personWithName:@"Sisko" hourlyRate:3.]inPersonsPresentAtIndex:0];
	[captainMeeting insertObject:[Person personWithName:@"Janeway" hourlyRate:4.]inPersonsPresentAtIndex:0];
	[captainMeeting insertObject:[Person personWithName:@"Archer" hourlyRate:5.]inPersonsPresentAtIndex:0];
	[captainMeeting insertObject:[Person personWithName:@"Riker" hourlyRate:6.]inPersonsPresentAtIndex:0];
	
	[captainMeeting startObservingPersonsPresent];
	
    return captainMeeting;
}

+ (Meeting *)meetingWithMarxBrothers {
	Meeting *marxMeeting = [[[Meeting alloc] init] autorelease];
	
	[marxMeeting insertObject:[Person personWithName:@"Chico" hourlyRate:11.]inPersonsPresentAtIndex:0];
	[marxMeeting insertObject:[Person personWithName:@"Harpo" hourlyRate:22.]inPersonsPresentAtIndex:0];
	[marxMeeting insertObject:[Person personWithName:@"Groucho" hourlyRate:33.]inPersonsPresentAtIndex:0];
	[marxMeeting insertObject:[Person personWithName:@"Gummo" hourlyRate:44.]inPersonsPresentAtIndex:0];
	[marxMeeting insertObject:[Person personWithName:@"Zeppo" hourlyRate:55.]inPersonsPresentAtIndex:0];
	
	[marxMeeting startObservingPersonsPresent];
	
    return marxMeeting;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:[self startingTime] forKey:@"startingTime"];
	[encoder encodeObject:[self endingTime] forKey:@"endingTime"];
	[encoder encodeObject:[self personsPresent] forKey:@"personsPresent"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if(self = [super init]) {
		_startingTime = [[decoder decodeObjectForKey:@"startingTime"] retain];
		_endingTime = [[decoder decodeObjectForKey:@"endingTime"] retain];
		_personsPresent = [[decoder decodeObjectForKey:@"personsPresent"] retain];
	}
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self updateTotalBillingRate];
	[self willChangeValueForKey:@"computedTotalBillingRate"];
    [self didChangeValueForKey:@"computedTotalBillingRate"];
}

@end
