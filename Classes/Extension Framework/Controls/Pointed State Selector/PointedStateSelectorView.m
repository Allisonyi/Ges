//
//  PointedStateSelectorView.m
//  Ges
//
//  Created by NeoJF on 28/07/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

/**
 * Custom view for selecting a "pointed state" for an operation. This state
 * can be: enabled, disabled, or unset (resp. green, red, and grey).
 *
 * This view allows binding to the "selectedState" value. However, this value binding
 * is currently implemented for a single bind only. Multiple bindings on this value
 * will not be correctly handled.
 *
 * TODO:
 *	- Could use separate image objects to represent the rounds and the selection frame in
 * a cached manner.
 *  - Allow multiple bindings on the "selectedState" value.
 *	- When multiple selection is enabled, draw a specific rollover to indicate selected
 * choice can be removed by clicking them again (red or black rollover).
 */

#import "PointedStateSelectorView.h"

static NSString *unsetEventDataString = @"unset";
static NSString *disabledEventDataString = @"disabled";
static NSString *enabledEventDataString = @"enabled";

@implementation PointedStateSelectorView

#pragma mark -
#pragma mark === Object's life ===

- (id)initWithFrame:(NSRect)frameRect {
	selectedState = 0;
	rolloverState = 0;
    self = [super initWithFrame:frameRect];
	
	if (self != nil) {
	
		unsetImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_grey_10x10.png"]];
		enabledImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_green_10x10.png"]];
		disabledImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_red_10x10.png"]];

		unsetDisabledImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_grey_disabled_10x10.png"]];
		enabledDisabledImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_green_disabled_10x10.png"]];
		disabledDisabledImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_red_disabled_10x10.png"]];

		selectionBezierPath = [constructSelectionBezierPath() retain];
		
		unsetTrackingRectTag = enabledTrackingRectTag = disabledTrackingRectTag = 0;
	}
    return self;
}

/*
 * Performs tasks once the nib has been loaded.
 *	- Add tracking rectangles for the view's areas.
 */
- (void)awakeFromNib {
	[self setTrackingRectangles];
}


#pragma mark -
#pragma mark === Drawing ===

- (void)drawRect:(NSRect)rect {
	NSPoint point = rect.origin;
	point.x += 3;
	point.y += 3;
	
	if (enabled) {
		NSBezierPath *bezierPath = [selectionBezierPath copy];
		NSAffineTransform *translate = [NSAffineTransform transform];
		
		if (selectedState) {
			// At least one state is selected.
			if (selectedState & UNSET) {
				// "Unset" state selected.
				[[NSColor whiteColor] set];
				[bezierPath fill];
				[[NSColor colorWithDeviceRed:0.3 green:0.3 blue:0.5 alpha:1] set];
				[bezierPath stroke];
			}
			if (selectedState & DISABLED) {
				// "Disabled" state selected.
				[translate translateXBy:17 yBy:0];
				[bezierPath transformUsingAffineTransform:translate];
				[[NSColor whiteColor] set];
				[bezierPath fill];
				[[NSColor colorWithDeviceRed:0.3 green:0.3 blue:0.5 alpha:1] set];
				[bezierPath stroke];
			}
			if (selectedState & ENABLED) {
				// "Enabled" state selected.
				[translate translateXBy:(selectedState & DISABLED ? 0 : 34) yBy:0];
				[bezierPath transformUsingAffineTransform:translate];
				[[NSColor whiteColor] set];
				[bezierPath fill];
				[[NSColor colorWithDeviceRed:0.3 green:0.3 blue:0.5 alpha:1] set];
				[bezierPath stroke];
			}
		}
		
		translate = [NSAffineTransform transform];
		bezierPath = [selectionBezierPath copy];
		
		if (rolloverState && !(rolloverState & selectedState)) {
			if (rolloverState & UNSET) {
				// Rollover on "Unset" state.
				[[NSColor colorWithDeviceRed:0 green:0 blue:0.2 alpha:0.3] set];
				[bezierPath fill];
				[[NSColor colorWithDeviceRed:0.3 green:0.3 blue:0.5 alpha:1] set];
				[bezierPath stroke];
			}
			else if (rolloverState & DISABLED) {
				// Rollover on "Disabled" state.
				[translate translateXBy:17 yBy:0];
				[bezierPath transformUsingAffineTransform:translate];
				[[NSColor colorWithDeviceRed:0 green:0 blue:0.2 alpha:0.3] set];
				[bezierPath fill];
				[[NSColor colorWithDeviceRed:0.3 green:0.3 blue:0.5 alpha:1] set];
				[bezierPath stroke];
			}
			else if (rolloverState & ENABLED) {
				// Rollover on "Enabled" state.
				[translate translateXBy:34 yBy:0];
				[bezierPath transformUsingAffineTransform:translate];
				[[NSColor colorWithDeviceRed:0 green:0 blue:0.2 alpha:0.3] set];
				[bezierPath fill];
				[[NSColor colorWithDeviceRed:0.3 green:0.3 blue:0.5 alpha:1] set];
				[bezierPath stroke];
			}
		}
	
		// Draws the 3 enabled rounds
		[unsetImage compositeToPoint:point operation:NSCompositeSourceAtop];
		point.x += 17;
		[disabledImage compositeToPoint:point operation:NSCompositeSourceAtop];
		point.x += 17;
		[enabledImage compositeToPoint:point operation:NSCompositeSourceAtop];
	}
	else {
		// Draws the 3 disabled rounds
		[unsetDisabledImage compositeToPoint:point operation:NSCompositeSourceAtop];
		point.x += 17;
		[disabledDisabledImage compositeToPoint:point operation:NSCompositeSourceAtop];
		point.x += 17;
		[enabledDisabledImage compositeToPoint:point operation:NSCompositeSourceAtop];
	}
}


#pragma mark -
#pragma mark === Mouse events ===

- (void)mouseEntered:(NSEvent *)theEvent {
	if ([((NSString *)[theEvent userData]) isEqualToString:unsetEventDataString]) {
		rolloverState = UNSET;
	}
	else if ([((NSString *)[theEvent userData]) isEqualToString:disabledEventDataString]) {
		rolloverState = DISABLED;
	}
	else if ([((NSString *)[theEvent userData]) isEqualToString:enabledEventDataString]) {
		rolloverState = ENABLED;
	}
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent {
	rolloverState = 0;
	[self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)event {
	if (rolloverState) {
		int newSelectedState;
		if (allowingMultipleSelection) {
			if (selectedState & rolloverState) {
				newSelectedState = selectedState & ~rolloverState;
			}
			else {
				newSelectedState = selectedState | rolloverState;
			}
		}
		else {
			newSelectedState = rolloverState;
		}
		if (bindingController != nil) {
			[bindingController setValue:[NSNumber numberWithInt:newSelectedState] forKeyPath:bindingKeyPath];
		}		
		[self setSelectedState:newSelectedState];
	}
}

- (BOOL)acceptsFirstResponder {
    return NO;
}

/**
 * Method automatically called when containing view has been moved or resized and
 * thus the receiver needs redefining its cursor rects (as well as its tracking
 * rectangles).
 *
 * Currently used to:
 *	- reset tracking rectangles for detecting mouse moves.
 */
- (void)resetCursorRects {
	[self setTrackingRectangles];
	[super resetCursorRects];
}

#pragma mark -
#pragma mark === KVC ===

- (State)getSelectedState {
	return selectedState;
}

- (void)setSelectedState:(State)state {
	if (selectedState != state) {
		selectedState = state;
		[self setNeedsDisplay:YES];
	}
}

- (BOOL)isEnabled {
	return enabled;
}

- (void)setEnabled:(BOOL)enable {
	if (enabled != enable) {
		enabled = enable;
		[self setNeedsDisplay:YES];
	}
}


#pragma mark -
#pragma mark === Binding ===

- (void)bind:(NSString *)bindingName toObject:(id)observableController withKeyPath:(NSString *)keyPath options:(NSDictionary *)options {
	if ([bindingName isEqualToString:@"selectedState"]) {
		// We only need to update the model for the selected state, not for other bindings.
		[self setBindingController:observableController];
		[self setBindingKeyPath:keyPath];
	}
	[super bind:bindingName toObject:observableController withKeyPath:keyPath options:options];
}

- (void)unbind:(NSString *)bindingName {
	bindingController = nil;
	bindingKeyPath = nil;
	[super unbind:bindingName];
}

- (Class)valueClassForBinding:(NSString *)binding {
    return [NSNumber class];	
}

- (void)setBindingController:(id)controller {
    if (bindingController != controller) {
        [bindingController release];
        bindingController = [controller retain];
    }
}

- (void)setBindingKeyPath:(NSString *)keyPath {
    if (bindingKeyPath != keyPath) {
        [bindingKeyPath release];
        bindingKeyPath = [keyPath copy];
    }
}


#pragma mark -
#pragma mark === Parametrizing the view ===

- (void)setAllowingMultipleSelection:(BOOL)allowMultipleSelection {
	if (allowingMultipleSelection != allowMultipleSelection) {
		allowingMultipleSelection = allowMultipleSelection;
	}
}

- (BOOL)isAllowingMultipleSelection {
	return allowingMultipleSelection;
}

/**
 * Set the tracking rectangles used to detect mouse movement over the different areas
 * of the view.
 */
- (void)setTrackingRectangles {

	// Removing tracking rectangles, if defined
	if (unsetTrackingRectTag != 0) {
		[self removeTrackingRect:unsetTrackingRectTag];
		[self removeTrackingRect:enabledTrackingRectTag];
		[self removeTrackingRect:disabledTrackingRectTag];
	}
	
	// Adding the tracking rectangle for the unset image area.
	NSRect rect;
	rect.origin.x = 0; rect.origin.y = 0;
	rect.size.width = 14; rect.size.height = 14;
	unsetTrackingRectTag = [self addTrackingRect:rect owner:self userData:unsetEventDataString assumeInside:NO];
	
	// Adding the tracking rectangle for the enabled image area.
	rect.origin.x += 17;
	enabledTrackingRectTag = [self addTrackingRect:rect owner:self userData:disabledEventDataString assumeInside:NO];
	
	// Adding the tracking rectangle for the disabled image area.
	rect.origin.x += 17;
	disabledTrackingRectTag = [self addTrackingRect:rect owner:self userData:enabledEventDataString assumeInside:NO];
}


#pragma mark -
#pragma mark === Class methods ===

+ (void)initialize {
	[self exposeBinding:@"selectedState"];
	[self exposeBinding:@"enabled"];
}

+ (NSArray *)exposedBindings {
	return [NSArray arrayWithObjects:@"selectedState", @"enabled", nil];	
}

@synthesize disabledTrackingRectTag;
@synthesize selectionBezierPath;
@synthesize enabledTrackingRectTag;
@synthesize unsetTrackingRectTag;
@synthesize disabledDisabledImage;
@synthesize enabledImage;
@synthesize disabledImage;
@synthesize unsetDisabledImage;
@synthesize enabledDisabledImage;
@synthesize unsetImage;
@end

NSBezierPath* constructSelectionBezierPath() {
	NSBezierPath* selectionBezierPath = [NSBezierPath bezierPath];
	[selectionBezierPath setLineCapStyle:NSSquareLineCapStyle];
	[selectionBezierPath setLineJoinStyle:NSMiterLineJoinStyle];
	[selectionBezierPath setLineWidth:1];
		
	// Bottom left
	NSPoint point = NSMakePoint(1, 1);
	[selectionBezierPath moveToPoint:point];
	
	// Top left
	point.y += 14;
	[selectionBezierPath lineToPoint:point];

	// Top right
	point.x += 14;
	[selectionBezierPath lineToPoint:point];
	
	// Bottom right
	point.y -= 14;
	[selectionBezierPath lineToPoint:point];
	
	// Bottom left
	point.x -= 14;
	[selectionBezierPath lineToPoint:point];
	
	return selectionBezierPath;
}