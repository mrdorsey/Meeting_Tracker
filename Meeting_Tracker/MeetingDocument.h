//
//  MeetingDocument.h
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/15/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;
@interface MeetingDocument : NSDocument
{
    Meeting *_meeting;
	NSTimer *_timer;
}
@property (assign) IBOutlet NSTextField *currentTimeLabel;

- (Meeting *)meeting;

- (IBAction)logMeeting:(id)sender;
- (IBAction)logParticipants:(id)sender;

@end
