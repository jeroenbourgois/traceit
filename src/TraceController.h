//
//  TraceController.h
//  traceit
//
//  Created by Jeroen Bourgois on 27/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class AppController;

@interface TraceController : NSObject {
	NSTask* task;
	NSTextView* txt;	
	NSMutableArray *loglines;
	NSPipe* pipe;
	AppController* appController;
	BOOL paused;
}

- (id) initWithTextView:(NSTextView*)textview controller:(AppController*) controller;

- (NSColor *) getColorForLine:(NSString *) line;
- (void) appendAttributedString:(NSAttributedString *) string;
- (void) scrollTextViewToEnd:(int) length;
- (void) updateStatus;
- (void) startTrace;
- (void) stopTrace;

- (void) setPaused:(BOOL) value;
- (BOOL) paused;

- (void) taskTerminated:(NSNotification *) note;

@end
