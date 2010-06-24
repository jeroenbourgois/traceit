//
//  TraceController.m
//  traceit
//
//  Created by Jeroen Bourgois on 27/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TraceController.h"
#import "AppController.h"
#import "LogItem.h"
#import "PreferenceController.h"

@implementation TraceController

- (id) init
{
	if(self = [super init])
	{
		NSLog(@"TraceController: INIT");
		
		loglines = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (id) initWithTextView:(NSTextView*)textview controller:(AppController*) controller
{
	if(self = [super init])
	{
		txt = textview;
		appController = controller;		
		
		[self init];
    }
    
	return self;
}

- (void) dealloc
{
	[super dealloc];
	[task dealloc];
}

- (void) startTrace
{
	// is the task running
	if(task) {
		[task interrupt];
	} else {
		task = [[NSTask alloc] init];
		[task setLaunchPath:@"/usr/bin/tail"];
		NSArray* args = [NSArray arrayWithObjects:@"-f", [[NSUserDefaults standardUserDefaults] stringForKey:JBPrefsTraceFileLocation], nil];
		[task setArguments:args];
		
		[pipe release];
		pipe = [[NSPipe alloc] init];
		[task setStandardOutput:pipe];
		
		NSFileHandle* fh = [pipe fileHandleForReading];
		
		NSNotificationCenter* nc;
		nc = [NSNotificationCenter defaultCenter];
		[nc removeObserver:self];
		[nc addObserver: self selector:@selector(dataReady:) name:NSFileHandleReadCompletionNotification object:fh];
		[nc addObserver:self selector:@selector(taskTerminated:) name:NSTaskDidTerminateNotification object:task];
		
		[task launch];
		
		[fh readInBackgroundAndNotify];
	}
}

- (void) dataReady:(NSNotification *) n
{
	NSData* d = [NSData alloc];
	d = [[n userInfo] valueForKey:NSFileHandleNotificationDataItem];
	
	//NSLog(@"TraceController: dataReady:%d bytes", [d length]);
	
	if([d length])
	{
	
		// get the read string from the data
		NSString *dataLine = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
		
		unsigned length = [dataLine length];
		unsigned paraStart = 0, paraEnd = 0, contentsEnd = 0;
		
		NSMutableArray *lines = [NSMutableArray array];
		NSRange currentRange;
		
		while (paraEnd < length)
		{
			
			[dataLine getParagraphStart:&paraStart end:&paraEnd contentsEnd:&contentsEnd forRange:NSMakeRange(paraEnd, 0)];
			currentRange = NSMakeRange(paraStart, contentsEnd - paraStart);
			[lines addObject:[dataLine substringWithRange:currentRange]];
			
		}
		
		// create attributes for the strings	
		NSFont *font = [NSFont fontWithName:@"Monaco" size:10.0f];
		NSMutableDictionary *attrsDictionary =	[NSMutableDictionary dictionaryWithObject:font	forKey:NSFontAttributeName];
		
		NSMutableString *line;
		for (line in lines)
		{
			if([line isEqualToString:@""] || [line isEqualToString:@" "])
			{
				NSLog(@"Trace added empty item");
			} 
			else
			{
				LogItem *logItem = [[LogItem alloc] initWithLogline:line];
				[loglines addObject:logItem];			
				
				// check for keywords (ERROR, WARNING, ...) and set attributes when required
				NSColor* color = [self getColorForLine:line];
				[attrsDictionary setObject:color forKey: NSForegroundColorAttributeName];

				
				// convert the data from the read string to an attributed string and append it to the textview
				// also, first add a newline to the string (so it looks good in the textview)
				NSMutableString *textviewLine = [[NSMutableString alloc] initWithString:line];
				[textviewLine appendString:@"\n"];
				
				NSAttributedString* attributedLine;
				attributedLine = [[NSAttributedString alloc] initWithString:textviewLine attributes:attrsDictionary];
				
				if(!paused && [self isClearLine: line])
				{
					[self clearTextview];
				}
				else if(!paused)
				{
					[self appendAttributedString:attributedLine];
					[self scrollTextViewToEnd:[line length]];
				}
				
			}
		}

		[self updateStatus];
	}
	
	// if the task is running, start reading again
	if(task)
		[[pipe fileHandleForReading] readInBackgroundAndNotify];
}

- (BOOL) isClearLine:(NSString *) line
{
	BOOL found = ([line rangeOfString:@"CLEAR"].location != NSNotFound);	
	return found;
}

- (void) clearTextview
{
	[txt setString:@""];
}

- (NSColor *) getColorForLine:(NSString *) line
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *textColor;
	
	// this now is bound to a fixed number of line options (3), not very flexible ...
	if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText1]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor1];
		NSLog(@"Label text 1: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText1]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText2]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor2];
		NSLog(@"Label text 2: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText2]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText3]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor3];
		NSLog(@"Label text 3: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText3]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText4]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor4];
		NSLog(@"Label text 4: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText4]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText5]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor5];
		NSLog(@"Label text 5: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText5]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText6]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor6];
		NSLog(@"Label text 6: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText6]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText7]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor7];
		NSLog(@"Label text 7: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText7]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText8]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor8];
		NSLog(@"Label text 8: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText8]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText9]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor9];
		NSLog(@"Label text 9: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText9]]);
	}else if([line rangeOfString:[defaults stringForKey:JBPrefsLabelText10]].length != 0){
		textColor = [defaults objectForKey:JBPrefsLabelColor10];
		NSLog(@"Label text 10: %@", [[NSString alloc] initWithString: [defaults stringForKey:JBPrefsLabelText10]]);
	}else{
	   textColor = [defaults objectForKey:JBPrefsTextColor];
	}
	
	NSColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:textColor];

	NSLog(@"%@", color);

	
	return color;
}

- (void) updateStatus
{
	NSLayoutManager *layoutManager = [txt layoutManager];
	unsigned numberOfLines, index, numberOfGlyphs =	[layoutManager numberOfGlyphs];
	NSRange lineRange;
	for (numberOfLines = 0, index = 0; index < numberOfGlyphs; numberOfLines++){
		(void) [layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
		index = NSMaxRange(lineRange);
	}
	
	NSString* countAsString = [[NSString alloc] initWithFormat: @"%@%d%@", @"Tracing... (line count: ", numberOfLines, @")"];
	[appController setStatus: countAsString];
}

- (void) appendAttributedString:(NSAttributedString *) string
{
	NSTextStorage* ts = [txt textStorage];
	[ts appendAttributedString:string];
}

- (void) scrollTextViewToEnd:(int) length
{
	 NSRange endRange;
	 
	 endRange.location = [[txt textStorage] length];
	 endRange.length = length;
	 
	 [txt scrollRangeToVisible:endRange];
}

- (void) taskTerminated:(NSNotification *) notification 
{
	NSLog(@"Task terminated");
	
    if ([[notification object] terminationStatus] == 1)
	{
        NSLog(@"Task failed.");
		[[NSNotificationCenter defaultCenter] postNotificationName:@"showError" object:nil ];
	}
	
	[task release];
	task = nil;
	
	[pipe release];
}

- (void) stopTrace
{
	[task interrupt];
	[task release];
	task = nil;
	
	[pipe release];
}

- (BOOL) paused
{
	return paused;
}

- (void) setPaused:(BOOL) value
{
	paused = value;
	
	if(paused)
	{
		[task suspend];
	}
	else 
	{
		[task resume];
	}
}

@end
