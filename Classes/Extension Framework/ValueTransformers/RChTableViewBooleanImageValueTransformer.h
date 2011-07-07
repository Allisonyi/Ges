//
//  TableViewBooleanImage.h
//  Ges
//
//  Created by NeoJF on 26/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RChTableViewBooleanImageValueTransformer : NSObject {
	
	// Images
	NSImage* selectedImage;
	NSImage* unselectedImage;
}

@property (retain) NSImage* selectedImage;
@property (retain) NSImage* unselectedImage;
@end
