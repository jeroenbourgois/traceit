//
//  PolicyFileController.h
//  traceit
//
//  Created by Jeroen Bourgois on 26/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AppController;

@interface PolicyFileController : NSObject {
	NSTask* task;
	NSTextView* txt;	
	NSMutableArray *loglines;
	NSPipe* pipe;
	BOOL paused;
	AppController* appController;
}

- (id) initWithTextView:(NSTextView*)textview controller:(AppController*) controller;

- (NSColor *) getColorForLine:(NSString *) line;
- (void) appendAttributedString:(NSAttributedString *) string;
- (void) scrollTextViewToEnd:(int) length;
- (void) updateStatus;
- (void) taskTerminated:(NSNotification *) note;
- (void) startTrace;

@end
