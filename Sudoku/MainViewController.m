//
//  MainViewController.m
//  Sudoku
//
//  Created by Ankh on 17.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "MainViewController.h"
#import "Sudoku.h"
#import "SudokuCell.h"
#import "SudokuSolver.h"

@interface MainViewController ()
- (IBAction)actionSolve:(id)sender;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void) awakeFromNib {
	[super awakeFromNib];

	NSSize size = NSMakeSize(33, 33);
	[self.collectionViewSudoku setMinItemSize:size];
	[self.collectionViewSudoku setMaxItemSize:size];

	NSString *testSudoku = _SUDOKU(
															@"090301800",
															@"406008030",
															@"280400600",
															@"000730491",
															@"001850760",
															@"037010000",
															@"060080170",
															@"004095006",
															@"100600059",
															);

	self.sudoku = [Sudoku sudoku];
	[self initSudoku:self.sudoku withContents:testSudoku];

	[self displaySudoku:self.sudoku withDiff:self.sudoku];
}

- (void) initSudoku:(Sudoku *)sudoku withContents:(NSString *)contents {
	NSUInteger size = (int)sqrt([contents length]);
	[sudoku setGroupsCount:size];

	for (int y = 0; y < size; y ++) {
		NSString *row = [contents substringWithRange:NSMakeRange(size * y, size)];
		for (int x = 0; x < size; x ++) {
			[[sudoku cellAtX:x andY:y] setNumber:[[row substringWithRange:NSMakeRange(x, 1)] integerValue]];
		}
	}
}

- (void) displaySudoku:(Sudoku *)sudoku withDiff:(Sudoku *)oldVersion {
	self.sudokuArray = [@[] mutableCopy];
	for (int i = 0; i < 9; i++) {
		for (int j = 0; j < 9; j++) {
			NSUInteger number = [sudoku cellAtX:8 - j andY:8 - i].number;
			NSUInteger diff = [oldVersion cellAtX:8 - j andY:8 - i].number;
			[self.arrayController insertObject:@{@"number": @(number), @"old": @(diff)} atArrangedObjectIndex:0];
		}
	}

}

- (IBAction)actionSolve:(id)sender {
	Sudoku *temp = [self.sudoku copy];
	SudokuSolver *solver = [SudokuSolver solverForSudoku:temp];
	[solver solve];
	
	[self displaySudoku:temp withDiff:self.sudoku];
}

@end
