//
//  SudokuViewItem.m
//  Sudoku
//
//  Created by Ankh on 17.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "SudokuViewItem.h"

@interface SudokuViewItem ()
- (IBAction)textEdited:(id)sender;

@end

@implementation SudokuViewItem

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
	id result = [super copyWithZone:zone];

	[[NSBundle mainBundle] loadNibNamed:@"SudokuViewItem" owner:result topLevelObjects:nil];

	return result;
}


- (void)setRepresentedObject:(id)object {
	[super setRepresentedObject:object];

	if (object == nil)
		return;

	NSDictionary* data  = (NSDictionary*) [self representedObject];
	NSUInteger number = [(id)[data valueForKey:@"number"] unsignedIntegerValue];
	NSNumber *old = (id)[data valueForKey:@"old"];
	NSString *str = number ? [NSString stringWithFormat:@"%lu", number] : @"";


	[self.textFieldNumberCell setStringValue:str];
	self.textFieldNumberCell.textColor = ([old unsignedIntegerValue] == number) ? [NSColor blackColor] : [NSColor blueColor];
}

- (IBAction)textEdited:(id)sender {
	NSLog(@"1");
}
@end
