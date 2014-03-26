//
//  SudokuSpec.m
//  Sudoku
//  Spec for Sudoku
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Kiwi.h"
#import "Sudoku.h"
#import "SudokuGroup.h"
#import "SudokuCell.h"
#import "Sudoku+TestAdditions.h"

SPEC_BEGIN(SudokuSpec)

describe(@"Sudoku", ^{
	it(@"should properly initialize", ^{
		Sudoku *instance = [Sudoku sudoku];
		[[instance shouldNot] beNil];
		[[instance should] beKindOfClass:[Sudoku class]];
	});

	it(@"should properly set size", ^{
		Sudoku *sudoku = [Sudoku sudoku];

		NSUInteger testSize = 9;

		[sudoku setGroupsCount:testSize];
		[[@([sudoku groupsCount]) should] equal:@(testSize)];

		[[[sudoku cells] shouldNot] beNil];
		[[[sudoku rows] shouldNot] beNil];
		[[[sudoku collumns] shouldNot] beNil];
		[[[sudoku squares] shouldNot] beNil];

		[[[sudoku cells] should] beKindOfClass:[NSArray class]];
		[[[sudoku rows] should] beKindOfClass:[NSArray class]];
		[[[sudoku collumns] should] beKindOfClass:[NSArray class]];
		[[[sudoku squares] should] beKindOfClass:[NSArray class]];


		[[[sudoku cells] should] haveCountOf:(testSize * testSize)];
		[[[sudoku rows] should] haveCountOf:testSize];

		[[[sudoku cellAtX:0 andY:0] should] beKindOfClass:[SudokuCell class]];

	});

	it(@"should properly set groups", ^{
		NSString *testSudoku = @"\
0123\
4567\
8901\
2345\
";
		
		Sudoku *sudoku = [Sudoku sudoku];

		[sudoku initWithStringContents:testSudoku];
		NSLog(@"Sudoku: %@", sudoku);

		NSArray *row1 = @[@(0), @(1), @(2), @(3)];
		NSArray *row2 = @[@(4), @(5), @(6), @(7)];
		NSArray *row3 = @[@(8), @(9), @(0), @(1)];
		NSArray *row4 = @[@(2), @(3), @(4), @(5)];

		NSArray *col1 = @[@(0), @(4), @(8), @(2)];
		NSArray *col2 = @[@(1), @(5), @(9), @(3)];
		NSArray *col3 = @[@(2), @(6), @(0), @(4)];
		NSArray *col4 = @[@(3), @(7), @(1), @(5)];

		NSArray *sqr1 = @[@(0), @(1), @(4), @(5)];
		NSArray *sqr2 = @[@(2), @(3), @(6), @(7)];
		NSArray *sqr3 = @[@(8), @(9), @(2), @(3)];
		NSArray *sqr4 = @[@(0), @(1), @(4), @(5)];

		[[theValue([sudoku group:sudoku.rows[0] equalsTo:row1]) should] beYes];
		[[theValue([sudoku group:sudoku.rows[1] equalsTo:row2]) should] beYes];
		[[theValue([sudoku group:sudoku.rows[2] equalsTo:row3]) should] beYes];
		[[theValue([sudoku group:sudoku.rows[3] equalsTo:row4]) should] beYes];

		[[theValue([sudoku group:sudoku.collumns[0] equalsTo:col1]) should] beYes];
		[[theValue([sudoku group:sudoku.collumns[1] equalsTo:col2]) should] beYes];
		[[theValue([sudoku group:sudoku.collumns[2] equalsTo:col3]) should] beYes];
		[[theValue([sudoku group:sudoku.collumns[3] equalsTo:col4]) should] beYes];

		[[theValue([sudoku group:sudoku.squares[0] equalsTo:sqr1]) should] beYes];
		[[theValue([sudoku group:sudoku.squares[1] equalsTo:sqr2]) should] beYes];
		[[theValue([sudoku group:sudoku.squares[2] equalsTo:sqr3]) should] beYes];
		[[theValue([sudoku group:sudoku.squares[3] equalsTo:sqr4]) should] beYes];

	});
});

SPEC_END
