//
//  AppController.h
//  traceit
//
//  Created by Jeroen Bourgois on 27/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TraceController;
@class PreferenceController;
@class PolicyFileController;

@interface AppController : NSObject {
	IBOutlet NSTextView* txtOutput;
	IBOutlet NSButton* btnPause;
	IBOutlet NSWindow* mainWindow;
	IBOutlet NSView* mainView;
	IBOutlet NSMenuItem *alwaysOnTop;
	NSStatusItem* statusItem;
	IBOutlet NSToolbarItem *pauseTraceToolbarItem;
	IBOutlet NSToolbarItem *resumeTraceToolbarItem;
	IBOutlet NSMenuItem *pauseTraceMenuItem;
	
	TraceController* traceController;
	PolicyFileController* policyFileController;
	PreferenceController* preferenceController;
}

- (IBAction) clear:(id) sender;
- (IBAction) showPreferencePanel:(id) sender;
- (IBAction) pauseTrace:(id) sender;
- (IBAction) resumeTrace:(id) sender;
- (IBAction) toggleMainWindow:(id) sender;
- (IBAction) alwaysOnTop:(id) sender;
- (IBAction) deleteSharedObject:(id) sender;

- (void) startTrace;
- (void) setStatus:(NSString *) message;

- (void) initTraceController;
- (void) initPolicyFileController;
- (void) initUI;
- (void) initUserDefaults;
- (void) initMenubarIcon;
- (void) initAllwaysOnTop;
- (void) saveAllwaysOnTop:(BOOL) allwaysOnTop;
- (void) updateColors;

- (void) preferencesClosed:(NSNotification *) notification;
- (void) showError:(NSNotification *) notification;

- (void) checkForFirstRun;
- (void) showFirstRunDialog;

@end
