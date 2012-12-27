//
//  Document.h
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/8/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;

@interface Document : NSDocument
{
    Meeting *_meeting;
	NSTimer *_timer;
	NSNumber *_defaultBillingRate;
	
	IBOutlet NSTableView *tableView;
	IBOutlet NSArrayController *arrayController;
}

@property (assign) IBOutlet NSButton *startMeetingButton;
@property (assign) IBOutlet NSButton *endMeetingButton;
@property (assign) IBOutlet NSTextField *currentTimeLabel;
@property (assign) IBOutlet NSTextField *startTimeLabel;
@property (assign) IBOutlet NSTextField *endTimeLabel;
@property (assign) IBOutlet NSTextField *elapsedTimeLabel;
@property (assign) IBOutlet NSTextField *accruedCostLabel;
@property (assign) IBOutlet NSTextField *targetTotalBillingRateLabel;

- (Meeting *)meeting;

- (IBAction)logMeeting:(id)sender;
- (IBAction)logParticipants:(id)sender;
- (IBAction)startMeeting:(id)sender;
- (IBAction)endMeeting:(id)sender;

- (IBAction)addPerson:(id)sender;
- (IBAction)removePerson:(id)sender;
- (IBAction)populateMeetingWithStooges:(id)sender;
- (IBAction)populateMeetingWithCaptains:(id)sender;
- (IBAction)populateMeetingWithMarxBros:(id)sender;

@end
