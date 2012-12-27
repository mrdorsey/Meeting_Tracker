//
//  Person.m
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/8/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "AppDelegate.h"
#import "MeetingTrackerPreferences.h"
#import "Person.h"

@implementation Person

NSString *defaultBillingRateKey = @"defaultBillingRateKey";

- (id)init
{
    return [self initWithName:@"<name>" rate:[[NSUserDefaults standardUserDefaults]
				 doubleForKey:defaultBillingRateKey]];
}

- (id)initWithName:(NSString *)aParticipantName rate:(double)aRate {
	
	if (self = [super init]) {
		[self setName:aParticipantName];
        [self setHourlyRate:[NSNumber numberWithDouble:aRate]];
	}
	
	return self;
}

- (void)dealloc
{
    [_name release];
    _name = nil;
	
    [_hourlyRate release];
    _hourlyRate = nil;
    
    [super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<Person %@ %@>",	[self name], [self hourlyRate]];
}

- (NSString *)name {
	return _name;
}

- (void)setName:(NSString*)aParticipantName
{
    if ( _name != aParticipantName )
    {
        [_name release];
        _name = [aParticipantName copy];
    }
}

- (NSNumber *)hourlyRate {
	return _hourlyRate;
}

- (void)setHourlyRate:(NSNumber*)anHourlyRate
{
    if ( _hourlyRate != anHourlyRate )
    {
        [_hourlyRate release];
        _hourlyRate = [anHourlyRate retain];
    }
}

+ (Person *)personWithName:(NSString *)newName hourlyRate:(double)billingRate
{
    Person *newPerson = [[[Person alloc] initWithName:newName rate:billingRate] autorelease];
	
    return newPerson;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:[self name] forKey:@"name"];
	[encoder encodeObject:[self hourlyRate] forKey:@"hourlyRate"];
}

- (id)initWithCoder:(NSCoder *)decoder {
	if(self = [super init]) {
		[self setName:[decoder decodeObjectForKey:@"name"]];
        [self setHourlyRate:[decoder decodeObjectForKey:@"hourlyRate"]];
	}
	
	return self;
}

@end
