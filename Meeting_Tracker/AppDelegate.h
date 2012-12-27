//
//  AppDelegate.h
//  Meeting_Tracker
//
//  Created by Michael Dorsey on 10/27/12.
//  Copyright (c) 2012 Michael Dorsey. All rights reserved.
//

@class PrefsWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain) PrefsWindowController *preferencesEditingWindow;
- (IBAction)showPreferencesEditingWindow:(id)sender;
- (void)registerStandardDefaults;
@end
