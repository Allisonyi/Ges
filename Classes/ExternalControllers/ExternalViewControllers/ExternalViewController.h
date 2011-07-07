//
//  ExternalViewController.h
//  Ges
//
//  Created by NeoJF on 22/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MyDocument.h"
#import "NibViewController.h"

@interface ExternalViewController : NSObject <NibViewController> {

	// Dependences
	MyDocument*				document;
	NSManagedObjectContext*	managedObjectContext;
	
	// IBOutlets: GUI elements
	IBOutlet NSView* view;	
}

// Life cycle
- (id)initWithDocument:(MyDocument*)aDocument;

// Accessors
- (NSManagedObjectContext*)managedObjectContext;
- (NSView*)view;

// <NibOwner>
/*- (NSArray*)accountsArrayControllers;
- (NSArray*)modesArrayControllers;
- (NSArray*)operationsArrayControllers;
- (NSArray*)typesArrayControllers;*/

@property (retain) MyDocument*				document;
@property (retain,getter=view) NSView* view;
@property (retain,getter=managedObjectContext) NSManagedObjectContext*	managedObjectContext;
@end
