//
//  Person.h
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/8/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
	NSString *_name;
	NSNumber *_hourlyRate;
}

- (NSString *)name;
- (void)setName:(NSString *)aParticipantName;
- (NSNumber *)hourlyRate;
- (void)setHourlyRate:(NSNumber *)anHourlyRate;

+ (Person *)personWithName:(NSString *)name
				hourlyRate:(double)rate;
- (id)initWithName:(NSString *)aParticipantName rate:(double)aRate;

@end
