//
//  testMeeting.m
//  Meeting Tracker
//
//  Created by CP120 on 10/8/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import "testMeeting.h"
#import "Meeting.h"
#import "Person.h"

@implementation testMeeting

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreation
{
    Meeting *meeting = [[[Meeting alloc] init] autorelease];
    STAssertNotNil([meeting personsPresent], @"personsPresent is empty");
    
    NSUInteger expectedCount = 0U;
    // I like to use symbolic names for the expected return values, so that I remember
    // why they are what they are
    STAssertEquals(expectedCount, [meeting countOfPersonsPresent], @"count wrong %d",
                   [meeting countOfPersonsPresent]);
    double expectedRate = 0.;
    STAssertEqualsWithAccuracy(expectedRate, [[meeting totalBillingRate] doubleValue], 0.01,
                               @"rate wrong");
}

- (void)testDates
{
    Meeting *meeting = [[[Meeting alloc] init] autorelease];
    
    NSUInteger threeHours = 60U*60U*3U;
    NSDate *start = [NSDate date];
    // You could use a more complicated construction method for the starting date,
    // if you wanted the starting date to be the same in each run of the tests.
    // That would most easily be done with NSCalendar -dateFromComponents:, or perhaps
    // [NSDate dateWithTimeIntervalSinceReferenceDate:], but is more complicated than
    // I want you to handle right now.
    NSDate *end = [start dateByAddingTimeInterval:threeHours];

    [meeting setStartingTime:start];
    [meeting setEndingTime:end];
    STAssertEqualObjects(start, [meeting startingTime], @"assignment failed");
    STAssertEqualObjects(end, [meeting endingTime], @"assignment failed");
    STAssertEqualsWithAccuracy(threeHours, [meeting elapsedSeconds], .001, @"elapsed seconds wrong");
    STAssertEqualsWithAccuracy(3., [meeting elapsedHours], .001, @"elapsed hours wrong");
    
}

- (void)testInsertionAndComputation
{
    Meeting *meeting;
    meeting = [[[Meeting alloc] init] autorelease];
    
    [meeting insertObject:[Person personWithName:@"Groucho" hourlyRate:85.]
  inPersonsPresentAtIndex:0];
    [meeting insertObject:[Person personWithName:@"Harpo" hourlyRate:75.]
  inPersonsPresentAtIndex:0];
    [meeting insertObject:[Person personWithName:@"Chico" hourlyRate:65.]
  inPersonsPresentAtIndex:0];
    [meeting insertObject:[Person personWithName:@"Zeppo" hourlyRate:55.]
  inPersonsPresentAtIndex:0];
        [meeting insertObject:[Person personWithName:@"Gummo" hourlyRate:45.]
  inPersonsPresentAtIndex:0];
        [meeting insertObject:[Person personWithName:@"Karl" hourlyRate:0.]
  inPersonsPresentAtIndex:0];
    NSLog(@"%@ %@", meeting, [meeting personsPresent]);
    NSUInteger expectedCount = 6;
    STAssertEquals(expectedCount, [meeting countOfPersonsPresent], @"count wrong %d",
                   [meeting countOfPersonsPresent]);
    double expectedRate = 325.; // I computed this by hand, just added up the hourlyRate: arguments above
    STAssertEqualsWithAccuracy(expectedRate, [[meeting totalBillingRate] doubleValue], 0.01,
                               @"rate wrong");
}

- (void)testComputation
{
    Meeting *meeting = [[[Meeting alloc] init] autorelease];

    NSUInteger hoursToRun = 3U;
    NSUInteger threeHours = 60U*60U*hoursToRun;
    NSDate *start = [NSDate date];
    NSDate *end = [start dateByAddingTimeInterval:threeHours];

    [meeting setStartingTime:start];
    [meeting setEndingTime:end];

    [meeting insertObject:[Person personWithName:@"Groucho" hourlyRate:85.]
  inPersonsPresentAtIndex:0];
    [meeting insertObject:[Person personWithName:@"Harpo" hourlyRate:75.]
  inPersonsPresentAtIndex:0];

    // both of the expected values are hand computed
    double expectedRate = 160.;
    STAssertEqualsWithAccuracy(expectedRate, [[meeting totalBillingRate] doubleValue], 0.01,
                               @"rate wrong");
    double expectedCost = expectedRate * hoursToRun;
    STAssertEqualsWithAccuracy(expectedCost, [[meeting accruedCost] doubleValue], 0.01,
                               @"accrued cost wrong");
}

- (void)testFactories
{
    // very simple tests to make sure these methods exist and return non-empty meetings
    Meeting *captains = [Meeting meetingWithCaptains];
    STAssertTrue([captains countOfPersonsPresent] > 0, @"captains failed");
    Meeting *marxBrothers = [Meeting meetingWithMarxBrothers];
    STAssertTrue([marxBrothers countOfPersonsPresent] > 0, @"marxBrothers failed");
    Meeting *stooges = [Meeting meetingWithStooges];
    STAssertTrue([stooges countOfPersonsPresent] > 0, @"stooges failed");
}

@end
