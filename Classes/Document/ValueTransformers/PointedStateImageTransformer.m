//
//  PointedStateImageTransformer.m
//  Ges
//
//  Created by NeoJF on 27/07/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "PointedStateImageTransformer.h"


@implementation PointedStateImageTransformer

- (id)init {
	self = [super init];
	if (self != nil) {
		unsetImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_grey_10x10.png"]];
		enabledImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_green_10x10.png"]];
		disabledImage = [[NSImage alloc] initByReferencingFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Round_red_10x10.png"]];
	}
	return self;
}
	
- (id)transformedValue:(id)value {
	switch([value intValue]) {
		case POINTED_STATE_UNSET :
			return unsetImage;
		case POINTED_STATE_ENABLED :
			return enabledImage;
		case POINTED_STATE_DISABLED :
			return disabledImage;
	}
	return nil;
}

+ (BOOL)allowsReverseTransformation {
	return NO;
}

+ (Class)transformedValueClass {
	return [NSImage class];
}

@synthesize unsetImage;
@synthesize enabledImage;
@synthesize disabledImage;
@end
