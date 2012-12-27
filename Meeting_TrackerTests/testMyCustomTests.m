//
//  testMyCustomTests.m
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/8/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "testMyCustomTests.h"
#import "Person.h"

@implementation testMyCustomTests

- (void) setUp
{
	[super setUp];
}

- (void) tearDown
{
	[super tearDown];
}

- (void) testParticipantName
{
	Person *person = [[[Person alloc] init] autorelease];
	[person setName:@"Groucho Marx"];
	STAssertEqualObjects(@"Groucho Marx", [person name], @"name wrong");
}

@end
