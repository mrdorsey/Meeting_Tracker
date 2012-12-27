//
//  PrefsWindowController.m
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/27/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import "MeetingTrackerPreferences.h"
#import "PrefsWindowController.h"

@interface PrefsWindowController ()

@end

@implementation PrefsWindowController

- (id)init {
	self = [super initWithWindowNibName:@"PrefsWindowController"];
	return self;
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[[self defaultBillingRate] setStringValue:[NSString stringWithFormat:@"%ld", [defaults integerForKey:defaultBillingRateKey]]];
	[[self billingRateSlider] setIntegerValue:[defaults integerForKey:defaultBillingRateKey]];
}

- (IBAction)changeDefaultBillingRate:(id)sender {
	[[self defaultBillingRate] setStringValue:[NSString stringWithFormat:@"%ld",[[self billingRateSlider] integerValue]]];
	[[NSUserDefaults standardUserDefaults] setInteger:[[self billingRateSlider] integerValue] forKey:defaultBillingRateKey];
}

@end
