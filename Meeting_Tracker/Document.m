//
//  Document.m
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/8/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "Document.h"
#import "Meeting.h"
#import "Person.h"

@interface Document ()

- (void)setMeeting:(Meeting *)aMeeting;
- (NSTimer *)timer;
- (void)setTimer:(NSTimer *)aTimer;
- (void)updateGUI:(NSTimer *)theTimer;

@end

@implementation Document : NSDocument

static void *documentKVOContext;

- (id)init
{
    if (self = [super init]) {
		_meeting = [[Meeting alloc] init];
	}
    return self;
}

- (void)dealloc
{
	for(Person *person in [_meeting personsPresent]) {
		[self stopObservingPerson:person];
	}
	
	[_meeting release];
	_meeting = nil;
	
	[_timer invalidate], [_timer release];
	_timer = nil;
	
	[super dealloc];
}

- (Meeting *)meeting {
	return _meeting;
}

- (void)setMeeting:(Meeting *)aMeeting
{
    if ( _meeting != aMeeting )
    {
		for(Person *person in [_meeting personsPresent]) {
			[self stopObservingPerson:person];
		}
		
        [aMeeting retain];
        [_meeting release];
        _meeting = aMeeting;
		
		for(Person *person in [_meeting personsPresent]) {
			[self startObservingPerson:person];
		}
    }
}

- (NSTimer *)timer {
	return _timer;
}

- (void)setTimer:(NSTimer *)aTimer
{
    if ( _timer != aTimer )
    {
		[_timer invalidate];
		[_timer release];
        _timer = [aTimer retain];
    }
}

- (IBAction)logMeeting:(id)sender {
	NSLog(@"%@", [self meeting]);
}

- (IBAction)startMeeting:(id)sender {
	NSDate *now = [NSDate date];
	NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[outputFormatter setDateFormat:@"MM/dd/yy hh:mm:ss a"];
	[[self startTimeLabel] setStringValue:[outputFormatter stringFromDate: now]];
	[[self meeting] setEndingTime:nil];
	[[self meeting] setStartingTime:now];
	[[self endTimeLabel] setStringValue:@""];
	[[self startMeetingButton] setEnabled:NO];
	[[self endMeetingButton] setEnabled:YES];
}

- (IBAction)endMeeting:(id)sender {
	NSDate *now = [NSDate date];
	NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[outputFormatter setDateFormat:@"MM/dd/yy hh:mm:ss a"];
	[[self endTimeLabel] setStringValue:[outputFormatter stringFromDate: now]];
	[[self meeting] setEndingTime:now];
	[[self startMeetingButton] setEnabled:YES];
	[[self endMeetingButton] setEnabled:NO];
}

- (IBAction)addPerson:(id)sender {
	NSWindow *w = [tableView window];
	
	BOOL editOver = [w makeFirstResponder:w];
	if(!editOver) {
		return;
	}
	
	NSUndoManager *undo = [self undoManager];
	
	if([undo groupingLevel] > 0) {
		[undo endUndoGrouping];
		[undo beginUndoGrouping];
	}
	
	Person *person = [arrayController newObject];
	[arrayController addObject:person];
	[self startObservingPerson:person];
	[arrayController rearrangeObjects];
	
	NSArray *arr = [arrayController arrangedObjects];
	
	NSUInteger row = [arr indexOfObjectIdenticalTo:person];
	
	[tableView editColumn:0 row:row withEvent:nil select:YES];
	
	[[undo prepareWithInvocationTarget:self]
	 removeObjectFromPersonsPresentAtIndex:row];
	
	if(![undo isUndoing]) {
		[undo setActionName:@"Add Person"];
	}
	
	[person release];
}

- (IBAction)removePerson:(id)sender {
	[self removeObjectFromPersonsPresentAtIndex:[arrayController selectionIndex]];
	[arrayController rearrangeObjects];
}

- (IBAction)populateMeetingWithStooges:(id)sender {
	[self setMeeting:[Meeting meetingWithStooges]];
}

- (IBAction)populateMeetingWithCaptains:(id)sender {
	[self setMeeting:[Meeting meetingWithCaptains]];
}

- (IBAction)populateMeetingWithMarxBros:(id)sender {
	[self setMeeting:[Meeting meetingWithMarxBrothers]];
}

- (void)startObservingPerson:(Person *)person {
	[person addObserver:self forKeyPath:@"hourlyRate" options:NSKeyValueObservingOptionOld context:&documentKVOContext];
}

- (void)stopObservingPerson:(Person *)person {
	[person removeObserver:self forKeyPath:@"hourlyRate"];
}

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue {
	[obj setValue:newValue forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if(context != &documentKVOContext) {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
		return;
	}
	
	NSUndoManager *undo = [self undoManager];
	id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
	
	if(oldValue == [NSNull null]) {
		oldValue = nil;
	}
	
	[[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
	[undo setActionName:@"Edit"];
}

- (void)insertObject:(Person *)person inPersonsPresentAtIndex:(NSUInteger)idx {
	NSUndoManager *undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self]
		removeObjectFromPersonsPresentAtIndex:idx];
	
	if(![undo isUndoing]) {
		[undo setActionName:@"Add Person"];
	}
	
	[self startObservingPerson:person];
	[[self meeting] insertObject:person inPersonsPresentAtIndex:idx];
}

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx {
	Person *person = [[[self meeting] personsPresent] objectAtIndex:idx];
	
	NSUndoManager *undo = [self undoManager];
	[[undo prepareWithInvocationTarget:self]
		insertObject:person inPersonsPresentAtIndex:idx];
	
	if(![undo isUndoing]) {
		[undo setActionName:@"Remove Person"];
	}
	
	[self stopObservingPerson:person];
	[[self meeting] removeObjectFromPersonsPresentAtIndex:idx];
}

- (IBAction)logParticipants:(id)sender {
	NSLog(@"%@", [[self meeting] personsPresent]);
}

- (NSString *)windowNibName
{
	return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];	
	[self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.2
													 target:self
												   selector:@selector(updateGUI:)
												   userInfo:nil
													repeats:YES]];
	[[self endMeetingButton] setEnabled:NO];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return [NSKeyedArchiver archivedDataWithRootObject:self.meeting];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
	Meeting *newMeeting;
	@try {
		newMeeting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	@catch (NSException *e) {
		if (outError) {
			NSDictionary *d =
			[NSDictionary dictionaryWithObject:@"Data is corrupted."
										forKey:NSLocalizedFailureReasonErrorKey];
			*outError = [NSError errorWithDomain:NSOSStatusErrorDomain
											code:unimpErr
										userInfo:d];
		}
		return NO;
	}
	self.meeting = newMeeting;
    return YES;
}

- (void)windowWillClose:(NSNotification *)notification
{
	[self setTimer:nil];
}

- (void)updateGUI:(NSTimer *)theTimer
{
	NSDate *now = [NSDate date];
	NSDateFormatter *outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[outputFormatter setDateFormat:@"MM/dd/yy hh:mm:ss a"];
	[[self currentTimeLabel] setStringValue:[outputFormatter stringFromDate: now]];
	
	[[self elapsedTimeLabel] setStringValue:[[self meeting] elapsedTimeDisplayString]];
	
	NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];

	[formatter setFormat:@"##0.00"];
	[[self accruedCostLabel] setStringValue:[NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[[self meeting] accruedCost]]]];
	
	[[self targetTotalBillingRateLabel] setStringValue:[NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[[self meeting] fastEnumTotalBillingRate]]]];
}

@end
