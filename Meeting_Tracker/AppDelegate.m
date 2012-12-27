//
//  AppDelegate.m
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/27/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "AppDelegate.h"
#import "MeetingTrackerPreferences.h"
#import "PrefsWindowController.h"

@implementation AppDelegate

- (id)init
{
	if (self = [super init]) {
		[self registerStandardDefaults];
	}
	return self;
}

- (IBAction)showPreferencesEditingWindow:(id)sender {
	if(!_preferencesEditingWindow)
		self.preferencesEditingWindow = [[[PrefsWindowController alloc] init] autorelease];
	
	[self.preferencesEditingWindow showWindow:sender];
}

- (void)registerStandardDefaults {
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithDouble:50.0] forKey:defaultBillingRateKey];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}
@end
