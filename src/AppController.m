//
//  AppController.m
//  traceit
//
//  Created by Jeroen Bourgois on 27/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"
#import "PolicyFileController.h"
#import "TraceController.h"
#import <Carbon/Carbon.h>

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
	
	NSMutableString *policyFileLocation = [NSMutableString stringWithString:homeDir];
	[policyFileLocation appendString:@"/Library/Preferences/Macromedia/Flash Player/Logs/policyfiles.txt"];
	[defaultValues setObject:[NSString stringWithString:policyFileLocation] forKey:JBPrefsPolicyFileLocation];
	
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
	
	[defaultValues setObject: [NSNumber numberWithBool:YES] forKey:JBPrefsIsFirstRun];
	
	// register defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)applicationDidFinishLaunching:(NSNotification *) aNotification
{
	NSLog(@"application finished launching");
	
	NSString * version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString * buildNo = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildNumber"];
	NSString * buildDate = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBuildDate"];
	NSLog(@"Application Version: %@ Build No: %@ Build Date: %@",version,buildNo,buildDate);
	
	[self initUI];
	[self checkForFirstRun];

	
	//[self initPolicyFileController];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showError:) name:@"showError" object:nil ];
	

}

- (void)awakeFromNib
{
	NSLog(@"okokokok");
	[self setDockStatus];	
}


- (void) setDockStatus {
	// this should be called from the application delegate's applicationDidFinishLaunching
	// method or from some controller object's awakeFromNib method
	// Neat dockless hack using Carbon from <a href="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it" title="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it">http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-...</a>
	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"JBPrefsShowInDock"])
	{
		NSLog(@"will show in dock and enable menu bar");
		ProcessSerialNumber psn = { 0, kCurrentProcess };
		// display dock icon
		TransformProcessType(&psn, kProcessTransformToForegroundApplication);
		// enable menu bar
		SetSystemUIMode(kUIModeNormal, 0);
		// switch to Dock.app
		[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil];
		// switch back
		[[NSApplication sharedApplication] activateIgnoringOtherApps:TRUE];
	} else 
	{
		NSLog(@"will not show in dock and enable menu bar");
	}
}

- (void) dealloc
{
	[super dealloc];
	//[traceController release];
	[policyFileController release];
	[preferenceController release];
}

- (void) checkForFirstRun
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if([defaults boolForKey:JBPrefsIsFirstRun] == YES)
		[self showFirstRunDialog];
	else
		[self initTraceController];
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
		[pauseTraceToolbarItem setImage: [NSImage imageNamed:@"play.png"]];
		[self setStatus: @"Paused"];
		NSLog(@"image change pause");
	}else{
		[self resumeTrace: NULL];
	}
}

- (IBAction) resumeTrace:(id) sender
{

	NSLog(@"image change resume");
	[pauseTraceToolbarItem setImage: [NSImage imageNamed:@"pause.png"]];
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

- (void) showFirstRunDialog
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:JBPrefsIsFirstRun];
	
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"Preferences"];	
	[alert addButtonWithTitle:@"Quit"];	
	[alert setMessageText:@"Hi there!"];
	[alert setInformativeText:@"It's the first time you run Trace It, and it won't be your last.\n\nBut to get started you NEED the Adobe Flash Debug Player and the flashlog.txt in place.\n\nHead over to the Adobe website to get the debug player and follow the instructions.\n\nOr if you are ready to go, set the location for the flashlog.txt in the Preferences."];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:mainWindow modalDelegate:self didEndSelector:@selector(firstRunDialogDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)firstRunDialogDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn)
	{
		[self showPreferencePanel:nil];
	}
	else if(returnCode == NSAlertSecondButtonReturn)
	{
		NSLog(@"QUIT");
		exit(0);
	}
}


- (void) showError:(NSNotification *) notification
{
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	[alert addButtonWithTitle:@"Preferences"];
	[alert addButtonWithTitle:@"Quit"];
	[alert setMessageText:@"Woops!"];
	[alert setInformativeText:@"Where is your flashlog file at? \nCheck the Preferences and make sure you have the Flash Debug player properly installed and configured."];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:mainWindow modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn)
	{
		[self showPreferencePanel:nil];
    }
	else if (returnCode == NSAlertSecondButtonReturn)
	{
		[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:JBPrefsIsFirstRun];
		exit(0);
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

- (void) initPolicyFileController
{
	policyFileController = [[PolicyFileController alloc] initWithTextView: txtOutput controller: self];
	[policyFileController startTrace];
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
		[mainWindow orderFrontRegardless];
}

- (void) saveAllwaysOnTop:(BOOL) allwaysOnTop
{
	if(allwaysOnTop)
	{
		[alwaysOnTop setState: NSOffState];
		[mainWindow setLevel:NSNormalWindowLevel];
	}
	else
	{
		[alwaysOnTop setState:NSOnState];
		[mainWindow setLevel:NSFloatingWindowLevel];
	}
	
	[preferenceController updateAllwaysOnTop:allwaysOnTop];
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

- (IBAction) deleteSharedObjects:(id) sender
{
	NSFileManager *fm;
	fm = [NSFileManager defaultManager];
	BOOL isDir;
	
	NSString *homeDir = NSHomeDirectory();
	NSMutableString *sharedObjectsLocation = [NSMutableString stringWithString:homeDir];
	[sharedObjectsLocation appendString:@"/Library/Preferences/Macromedia/Flash Player/#SharedObjects/"];

	
	NSDirectoryEnumerator *de = [fm enumeratorAtPath:sharedObjectsLocation];
	NSString *f;
	NSString *fqn;
	while ((f = [de nextObject]))
	{
		// make the filename |f| a fully qualifed filename
		fqn = [sharedObjectsLocation stringByAppendingString:f];
		if ([fm fileExistsAtPath:fqn isDirectory:&isDir] && isDir)
		{
			if ([fm removeItemAtPath: fqn error: NULL]  == YES)
				NSLog (@"Remove successful");
			else
				NSLog (@"Remove failed");
			
			// append a / to the end of all directory entries
			fqn = [fqn stringByAppendingString:@"/"];
		}
	}
}

- (IBAction) toggleFilter:(id) sender
{
	NSLog(@"toggleFilter, %d", [btnFilterToggle state]);
	if([btnFilterToggle state] == NSOnState)
	{
		[traceController filter:TRUE];
	}
	else
	{
		[traceController filter:FALSE];
	}
}

@end
