//
//  PreferenceController.m
//  Trace It!
//
//  Created by Jeroen Bourgois on 13/10/09.
//  Copyright 2009 Jeroen Bourgois. All rights reserved.
//

#import "PreferenceController.h"
#import "AppController.h"

NSString * const JBPrefsAutoStartTrace = @"AutoStartTrace";
NSString * const JBPrefsTraceFileLocation = @"TraceFileLocation";
NSString * const JBPrefsPolicyFileLocation = @"PolicyFileLocation";
NSString * const JBPrefsAlwaysOnTop = @"AlwaysOnTop";
NSString * const JBPrefsShowInDock = @"ShowInDock";
NSString * const JBPrefsBackgroundColor = @"BackgroundColor";
NSString * const JBPrefsTextColor = @"TextColor";
NSString * const JBPrefsIsFirstRun = @"IsFirstRun";


NSString * const JBPrefsLabelColor1 = @"labelColor1";
NSString * const JBPrefsLabelColor2 = @"labelColor2";
NSString * const JBPrefsLabelColor3 = @"labelColor3";
NSString * const JBPrefsLabelColor4 = @"labelColor4";
NSString * const JBPrefsLabelColor5 = @"labelColor5";
NSString * const JBPrefsLabelColor6 = @"labelColor6";
NSString * const JBPrefsLabelColor7 = @"labelColor7";
NSString * const JBPrefsLabelColor8 = @"labelColor8";
NSString * const JBPrefsLabelColor9 = @"labelColor9";
NSString * const JBPrefsLabelColor10 = @"labelColor10";

NSString * const JBPrefsLabelText1 = @"labelText1";
NSString * const JBPrefsLabelText2 = @"labelText2";
NSString * const JBPrefsLabelText3 = @"labelText3";
NSString * const JBPrefsLabelText4 = @"labelText4";
NSString * const JBPrefsLabelText5 = @"labelText5";
NSString * const JBPrefsLabelText6 = @"labelText6";
NSString * const JBPrefsLabelText7 = @"labelText7";
NSString * const JBPrefsLabelText8 = @"labelText8";
NSString * const JBPrefsLabelText9 = @"labelText9";
NSString * const JBPrefsLabelText10 = @"labelText10";

@implementation PreferenceController

- (id) init
{
	NSLog(@"init");
	 if(![super initWithWindowNibName:@"Preferences"])
		return nil;
	
	return self;
}

// DEALLOC HERE!!!!

- (IBAction) browse:(id) sender
{
	// Create the File Open Dialog class.
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
	// Set properties for the dialog
	[openDlg setCanChooseFiles:YES];
	[openDlg setCanChooseDirectories:NO];
	[openDlg setTitle:@"Locate trace file"];
	[openDlg setCanCreateDirectories:NO];
	[openDlg setAllowsMultipleSelection:NO];
	
	// Display the dialog.  If the OK button was pressed,
	// process the file.
	if([openDlg runModalForDirectory:nil file:nil] == NSOKButton)
	{
		[traceFileLocation setStringValue:[openDlg filename]];
		[self changeTraceFileLocation];
	}	
}

- (IBAction) changeAutoStartTrace:(id) sender
{
	int state = [checkboxAutoStartTrace state];
	[[NSUserDefaults standardUserDefaults] setBool:state forKey:JBPrefsAutoStartTrace];
}

- (IBAction) changeAllwaysOnTop:(id) sender
{
	int state = [checkboxAllwaysOnTop state];
	[[NSUserDefaults standardUserDefaults] setBool:state forKey:JBPrefsAlwaysOnTop];
}

- (void) changeTraceFileLocation
{
	NSString* location = [traceFileLocation stringValue];
	[[NSUserDefaults standardUserDefaults] setObject:location forKey:JBPrefsTraceFileLocation];
}

- (void) awakeFromNib
{	
	[checkboxAutoStartTrace setState: [self autoStartTrace]];
	[checkboxShowInDock setState: [self showInDock]];	
	
	[checkboxAllwaysOnTop setState: [self alwaysOnTop]];
	
	[traceFileLocation setStringValue: [self traceFileLocation]];
	[backgroundColorWell setColor:[self backgroundColor]];
	[textColorWell setColor:[self textColor]];
	
	[cwLabel1 setColor:[self labelColor:LABEL1]];
	[cwLabel2 setColor:[self labelColor:LABEL2]];
	[cwLabel3 setColor:[self labelColor:LABEL3]];
	[cwLabel4 setColor:[self labelColor:LABEL4]];
	[cwLabel5 setColor:[self labelColor:LABEL5]];
	[cwLabel6 setColor:[self labelColor:LABEL6]];
	[cwLabel7 setColor:[self labelColor:LABEL7]];
	[cwLabel8 setColor:[self labelColor:LABEL8]];
	[cwLabel9 setColor:[self labelColor:LABEL9]];
	[cwLabel10 setColor:[self labelColor:LABEL10]];	

	[txtLabel1 setStringValue:[self labelText:LABEL1]];
	[txtLabel2 setStringValue:[self labelText:LABEL2]];
	[txtLabel3 setStringValue:[self labelText:LABEL3]];
	[txtLabel4 setStringValue:[self labelText:LABEL4]];
	[txtLabel5 setStringValue:[self labelText:LABEL5]];
	[txtLabel6 setStringValue:[self labelText:LABEL6]];
	[txtLabel7 setStringValue:[self labelText:LABEL7]];
	[txtLabel8 setStringValue:[self labelText:LABEL8]];
	[txtLabel9 setStringValue:[self labelText:LABEL9]];
	[txtLabel10 setStringValue:[self labelText:LABEL10]];
	
	// show the opacity slider in the color panel
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
}

- (void) windowWillClose:(NSNotification *) aNotification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"myType" object:nil];
}

- (NSString *) traceFileLocation
{
	return [[NSUserDefaults standardUserDefaults] stringForKey: JBPrefsTraceFileLocation];
}

- (BOOL) autoStartTrace
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:JBPrefsAutoStartTrace];
}
	
- (BOOL) alwaysOnTop
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:JBPrefsAlwaysOnTop];	
}

- (IBAction) setBackgroundColor:(id) sender
{
	NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[backgroundColorWell color]];
	[[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:JBPrefsBackgroundColor];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSColor *) backgroundColor
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *colorAsData = [defaults objectForKey:JBPrefsBackgroundColor];
	return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

- (IBAction) setTextColor:(id) sender
{
	NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[textColorWell color]];
	[[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:JBPrefsTextColor];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSColor *) textColor
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *colorAsData = [defaults objectForKey:JBPrefsTextColor];
	return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

- (NSColor *) labelColor:(int) labelType
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *color;
	
	switch (labelType)
	{
		case LABEL1:
			color = [defaults objectForKey:JBPrefsLabelColor1];
			break;
		case LABEL2:
			color = [defaults objectForKey:JBPrefsLabelColor2];
			break;
		case LABEL3:
			color = [defaults objectForKey:JBPrefsLabelColor3];
			break;
		case LABEL4:
			color = [defaults objectForKey:JBPrefsLabelColor4];
			break;
		case LABEL5:
			color = [defaults objectForKey:JBPrefsLabelColor5];
			break;
		case LABEL6:
			color = [defaults objectForKey:JBPrefsLabelColor6];
			break;
		case LABEL7:
			color = [defaults objectForKey:JBPrefsLabelColor7];
			break;
		case LABEL8:
			color = [defaults objectForKey:JBPrefsLabelColor8];
			break;
		case LABEL9:
			color = [defaults objectForKey:JBPrefsLabelColor9];
			break;
		case LABEL10:
			color = [defaults objectForKey:JBPrefsLabelColor10];
			break;			
	}
	
	return [NSKeyedUnarchiver unarchiveObjectWithData:color];
}

- (IBAction) setLabelColor:(id) sender
{	
	NSData *colorAsData;
	NSString *key;
	
	if(sender == cwLabel1)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel1 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor1];
	}
	else if(sender == cwLabel2)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel2 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor2];		
	}
	else if(sender == cwLabel3)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel3 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor3];	
	}
	else if(sender == cwLabel4)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel4 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor4];
	}
	else if(sender == cwLabel5)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel5 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor5];
	}
	else if(sender == cwLabel6)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel6 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor6];
	}
	else if(sender == cwLabel7)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel7 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor7];	
	}
	else if(sender == cwLabel8)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel8 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor8];		
	}
	else if(sender == cwLabel9)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel9 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor9];	
	}
	else if(sender == cwLabel10)
	{
		colorAsData = [NSKeyedArchiver archivedDataWithRootObject:[cwLabel10 color]];
		key = [[NSString alloc] initWithString: JBPrefsLabelColor10];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:colorAsData forKey:key];
	
	[colorAsData release];
	[key release];
}
	
- (NSString *) labelText:(int) labelType
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *text;
	
	switch (labelType)
	{
		case LABEL1:
			text = [defaults stringForKey:JBPrefsLabelText1];
			break;
		case LABEL2:
			text = [defaults stringForKey:JBPrefsLabelText2];
			break;
		case LABEL3:
			text = [defaults stringForKey:JBPrefsLabelText3];
			break;
		case LABEL4:
			text = [defaults stringForKey:JBPrefsLabelText4];
			break;
		case LABEL5:
			text = [defaults stringForKey:JBPrefsLabelText5];
			break;
		case LABEL6:
			text = [defaults stringForKey:JBPrefsLabelText6];
			break;
		case LABEL7:
			text = [defaults stringForKey:JBPrefsLabelText7];
			break;
		case LABEL8:
			text = [defaults stringForKey:JBPrefsLabelText8];
			break;
		case LABEL9:
			text = [defaults stringForKey:JBPrefsLabelText9];
			break;
		case LABEL10:
			text = [defaults stringForKey:JBPrefsLabelText10];
			break;
	}
	
	return text;
}

- (void) updateLabelTexts
{	
	NSString *label;
	
	label = [txtLabel1 stringValue];	
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText1];
	
	label = [txtLabel2 stringValue];	
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText2];
	
	label = [txtLabel3 stringValue];	
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText3];
	
	label = [txtLabel4 stringValue];
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText4];
	
	label = [txtLabel5 stringValue];
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText5];
	
	label = [txtLabel6 stringValue];
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText6];
	
	label = [txtLabel7 stringValue];
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText7];
	
	label = [txtLabel8 stringValue];
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText8];
	
	label = [txtLabel9 stringValue];
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText9];
	
	label = [txtLabel10 stringValue];
	[[NSUserDefaults standardUserDefaults] setObject:label forKey:JBPrefsLabelText10];
	
	[label release];
}

- (BOOL) showInDock
{
	/*
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:JBPrefsShowInDock];
	 */
	return false;
}

- (void) textDidChange:(NSNotification *) aNotification
{
	if([aNotification object] == traceFileLocation)
	{
		[self changeTraceFileLocation];
	}
	else
	{
		[self updateLabelTexts];
	}
}

- (void) controlTextDidChange:(NSNotification *) aNotification
{
	if([aNotification object] == traceFileLocation)
	{
		[self changeTraceFileLocation];
	}
	else
	{
		[self updateLabelTexts];
	}	
}

- (void) updateAllwaysOnTop:(BOOL) allwaysOnTop
{
	NSLog(@"updateAllwaysOnTop: %d", allwaysOnTop);
	[checkboxAllwaysOnTop setState:NSOnState];
	[[NSUserDefaults standardUserDefaults] setBool:allwaysOnTop forKey:JBPrefsAlwaysOnTop];
}

@end
