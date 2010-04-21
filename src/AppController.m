//
//  AppController.m
//  traceit
//
//  Created by Jeroen Bourgois on 27/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

- (id) init
{
	[super init];
	return self;
}

+ (void) initialize
{
	// create defaults
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:JBPrefsAutoStartTrace];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:JBPrefsAlwaysOnTop];

	NSString *homeDir = NSHomeDirectory();
	NSMutableString *traceFileLocation = [NSMutableString stringWithString:homeDir];
	[traceFileLocation appendString:@"/Library/Preferences/Macromedia/Flash Player/Logs/flashlog.txt"];
	
	[defaultValues setObject:[NSString stringWithString:traceFileLocation] forKey:JBPrefsTraceFileLocation];	
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor blackColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsBackgroundColor];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor greenColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsTextColor];

	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor grayColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor1];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor redColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor2];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor orangeColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor3];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor whiteColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor4];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor whiteColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor5];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor purpleColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor6];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor greenColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor7];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor redColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor8];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor yellowColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor9];
	[defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[[NSColor yellowColor] colorUsingColorSpaceName:NSCalibratedRGBColorSpace]] forKey:JBPrefsLabelColor10];	

	[defaultValues setObject:[[NSString alloc] initWithString:@"INFO"]			forKey:JBPrefsLabelText1];
	[defaultValues setObject:[[NSString alloc] initWithString:@"ERROR"]			forKey:JBPrefsLabelText2];
	[defaultValues setObject:[[NSString alloc] initWithString:@"WARNING"]		forKey:JBPrefsLabelText3];
	[defaultValues setObject:[[NSString alloc] initWithString:@"PAGE_LOAD"]		forKey:JBPrefsLabelText4];
	[defaultValues setObject:[[NSString alloc] initWithString:@"PAGE_UNLOAD"]	forKey:JBPrefsLabelText5];
	[defaultValues setObject:[[NSString alloc] initWithString:@"BUTTON_CLICK"]	forKey:JBPrefsLabelText6];
	[defaultValues setObject:[[NSString alloc] initWithString:@"MESSAGE"]		forKey:JBPrefsLabelText7];
	[defaultValues setObject:[[NSString alloc] initWithString:@"CRITICAL"]		forKey:JBPrefsLabelText8];
	[defaultValues setObject:[[NSString alloc] initWithString:@"INIT"]			forKey:JBPrefsLabelText9];
	[defaultValues setObject:[[NSString alloc] initWithString:@"KILL"]			forKey:JBPrefsLabelText10];	
	
	// register defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)applicationDidFinishLaunching:(NSNotification *) aNotification
{
	NSLog(@"application finished launching");
	
	[self initUI];
	[self initTraceController];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError:) name:@"showError" object:nil ];
}

- (void) dealloc
{
	[super dealloc];
	[traceController release];
	[preferenceController release];
}


- (IBAction) clear:(id) sender 
{
	[txtOutput setString:@""];
	[self setStatus:@"Cleared!"];
}

- (IBAction) pauseTrace:(id) sender
{
	if(![traceController paused])
	{
		[traceController setPaused:YES];
		[self setStatus: @"Paused"];
	}
}

- (IBAction) resumeTrace:(id) sender
{
	if([traceController paused])
	{
		[traceController setPaused:NO];
		[pauseTraceMenuItem setTitle:@"Resume"];
		[self setStatus: @"Tracing ..."];
	}
}

- (IBAction) showPreferencePanel:(id) sender
{
	if(!preferenceController)
		preferenceController = [[PreferenceController alloc] init];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesClosed:) name:@"myType" object:nil ];
	
	[preferenceController showWindow:self];
}

- (void) preferencesClosed:(NSNotification *) notification
{
	[self clear: nil];
	[self startTrace];
	[self updateColors];
	[self saveAllwaysOnTop:[[NSUserDefaults standardUserDefaults] boolForKey:JBPrefsAlwaysOnTop]];
}

- (void) showError:(NSNotification *) notification
{
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setMessageText:@"The log file could not be found?"];
	[alert setInformativeText:@"Check if the location for the log file in the Preferences is ok."];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:mainWindow modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn)
	{
		[self showPreferencePanel:nil];
		NSLog(@"Modal ended");
    }
}

- (void) startTrace
{
	NSLog(@"AppController: _startTrace");
	
	[traceController stopTrace];
	[traceController release];
	
	traceController = [[TraceController alloc] initWithTextView: txtOutput controller: self];
	[traceController startTrace];
}

- (void) setStatus:(NSString *) message
{
	[mainWindow setTitle: message];
}

- (void) updateColors
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	NSData *backgroundColorData = [defaults objectForKey:JBPrefsBackgroundColor];
	NSData *textColorData = [defaults objectForKey:JBPrefsTextColor];
	
	[mainWindow setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:backgroundColorData]];

	[txtOutput setSelectedTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSColor colorWithDeviceRed:0.0314 green:0.2235 blue:0.0196 alpha:1.0], NSBackgroundColorAttributeName, nil]];
	[txtOutput setTextColor:[NSColor yellowColor]];

	
	[backgroundColorData release];
	[textColorData release];
	[defaults release];
}

- (void) initUserDefaults
{

}

- (void) initTraceController
{
	traceController = [[TraceController alloc] initWithTextView: txtOutput controller: self];
	if([[NSUserDefaults standardUserDefaults] objectForKey:JBPrefsAutoStartTrace])
	{
		[traceController startTrace];
	}
}

- (void) initUI
{
	// main window
	[mainWindow setOpaque:NO];
	
	// other
	[self initMenubarIcon];
	[self initAllwaysOnTop];
	
	// status
	[self setStatus: @"Trace it!: Ready for input"];
	
	// colors
	[self updateColors];
	
	// menu items
	[self pauseTrace:NULL];
}

- (void) initMenubarIcon
{
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
	 
	NSImage *statusImage = [NSImage imageNamed:@"menubar.png"];
	[statusItem setImage:statusImage];
	[statusItem setHighlightMode:YES];
	[statusItem setAction:@selector(toggleMainWindow:)];
}

- (IBAction) toggleMainWindow:(id) sender
{
	if ([mainWindow isVisible]) 
		[mainWindow orderOut:sender];
	else
		[mainWindow orderFront:sender];
}

- (void) saveAllwaysOnTop:(BOOL) allwaysOnTop
{
	if(!allwaysOnTop)
	{
		[alwaysOnTop setState: NSOffState];
		[mainWindow setLevel:NSNormalWindowLevel];
	}
	else
	{
		[alwaysOnTop setState:NSOnState];
		[mainWindow setLevel:NSFloatingWindowLevel];
	}
	
	[[NSUserDefaults standardUserDefaults] setBool:allwaysOnTop forKey:JBPrefsAlwaysOnTop];
}

- (IBAction) alwaysOnTop:(id) sender
{
	[self saveAllwaysOnTop:([alwaysOnTop state] == NSOnState)];
}

- (void) initAllwaysOnTop
{
	// always on top menu item
	[self saveAllwaysOnTop:[[NSUserDefaults standardUserDefaults] boolForKey:JBPrefsAlwaysOnTop]];
}

@end
