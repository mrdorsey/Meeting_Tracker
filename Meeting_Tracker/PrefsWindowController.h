//
//  PrefsWindowController.h
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/27/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PrefsWindowController : NSWindowController

@property (assign) IBOutlet NSTextField *defaultBillingRate;
@property (assign) IBOutlet NSSlider *billingRateSlider;

- (IBAction)changeDefaultBillingRate:(id)sender;

@end
