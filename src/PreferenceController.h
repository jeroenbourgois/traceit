//
//  PreferenceController.h
//  iPing
//
//  Created by Jeroen Bourgois on 13/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AppController;

// preferences constants
extern NSString * const JBPrefsAutoStartTrace;
extern NSString * const JBPrefsTraceFileLocation;
extern NSString * const JBPrefsPolicyFileLocation;
extern NSString * const JBPrefsAlwaysOnTop;
extern NSString * const JBPrefsShowInDock;
extern NSString * const JBPrefsBackgroundColor;
extern NSString * const JBPrefsTextColor;
extern NSString * const JBPrefsIsFirstRun;

extern NSString * const JBPrefsLabelColor1;
extern NSString * const JBPrefsLabelColor2;
extern NSString * const JBPrefsLabelColor3;
extern NSString * const JBPrefsLabelColor4;
extern NSString * const JBPrefsLabelColor5;
extern NSString * const JBPrefsLabelColor6;
extern NSString * const JBPrefsLabelColor7;
extern NSString * const JBPrefsLabelColor8;
extern NSString * const JBPrefsLabelColor9;
extern NSString * const JBPrefsLabelColor10;

extern NSString * const JBPrefsLabelText1; 
extern NSString * const JBPrefsLabelText2; 
extern NSString * const JBPrefsLabelText3; 
extern NSString * const JBPrefsLabelText4; 
extern NSString * const JBPrefsLabelText5; 
extern NSString * const JBPrefsLabelText6; 
extern NSString * const JBPrefsLabelText7; 
extern NSString * const JBPrefsLabelText8; 
extern NSString * const JBPrefsLabelText9; 
extern NSString * const JBPrefsLabelText10;

enum LabelType {
	LABEL1,
	LABEL2,
	LABEL3,
	LABEL4,
	LABEL5,
	LABEL6,
	LABEL7,
	LABEL8,
	LABEL9,
	LABEL10
};


@interface PreferenceController : NSWindowController
{
	IBOutlet NSButton *checkboxAutoStartTrace;
	IBOutlet NSButton *checkboxShowInDock;
	IBOutlet NSTextField *traceFileLocation;
	IBOutlet NSButton *checkboxAllwaysOnTop;
	IBOutlet NSColorWell *backgroundColorWell;
	IBOutlet NSColorWell *textColorWell;
	
	// colors & labels
	IBOutlet NSTextField *txtLabel1;
	IBOutlet NSTextField *txtLabel2;
	IBOutlet NSTextField *txtLabel3;
	IBOutlet NSTextField *txtLabel4;
	IBOutlet NSTextField *txtLabel5;
	IBOutlet NSTextField *txtLabel6;
	IBOutlet NSTextField *txtLabel7;
	IBOutlet NSTextField *txtLabel8;
	IBOutlet NSTextField *txtLabel9;
	IBOutlet NSTextField *txtLabel10;	
	
	IBOutlet NSColorWell *cwLabel1;
	IBOutlet NSColorWell *cwLabel2;
	IBOutlet NSColorWell *cwLabel3;
	IBOutlet NSColorWell *cwLabel4;
	IBOutlet NSColorWell *cwLabel5;
	IBOutlet NSColorWell *cwLabel6;
	IBOutlet NSColorWell *cwLabel7;
	IBOutlet NSColorWell *cwLabel8;
	IBOutlet NSColorWell *cwLabel9;
	IBOutlet NSColorWell *cwLabel10;
}

- (IBAction) browse:(id) sender;
- (IBAction) changeAutoStartTrace:(id) sender;
- (IBAction) changeAllwaysOnTop:(id) sender;

- (void) changeTraceFileLocation;
- (BOOL) autoStartTrace;
- (BOOL) showInDock;
- (BOOL) alwaysOnTop;

- (NSColor *) backgroundColor;
- (IBAction) setBackgroundColor:(id) sender;
- (NSColor *) textColor;
- (IBAction) setTextColor:(id) sender;

- (IBAction) setLabelColor:(id) sender;
- (void) updateLabelTexts;
- (NSColor *) labelColor:(int) labelType;
- (NSString *) labelText:(int) labelType;

- (NSString *) traceFileLocation;

- (void) textDidChange:(NSNotification *) aNotification;
- (void) updateAllwaysOnTop:(BOOL) allwaysOnTop;

@end