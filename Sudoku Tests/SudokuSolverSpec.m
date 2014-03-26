//
//  SudokuSolverSpec.m
//  Sudoku
//  Spec for SudokuSolver
//
//  Created by Ankh on 14.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Kiwi.h"
#import "SudokuSolver.h"
#import "Sudoku.h"
#import "Sudoku+TestAdditions.h"

#define _SUDOKU(rows...) [@[rows] componentsJoinedByString:@""]

SPEC_BEGIN(SudokuSolverSpec)

describe(@"SudokuSolver", ^{
	NSString *sudoku1 = _SUDOKU(
															@"1234",
															@"3412",
															@"2341",
															@"4123",
															);
	NSString *sudoku2 = _SUDOKU(
															@"1034",
															@"3012",
															@"2301",
															@"0123",
															);
	NSString *sudoku3 = _SUDOKU(
															@"470092300",
															@"008004912",
															@"230100054",
															@"005426870",
															@"780013005",
															@"302700091",
															@"500801230",
															@"164209500",
															@"020650109",
															);
	NSString *sudoku4 = _SUDOKU(
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

	it(@"should properly initialize", ^{
		Sudoku *sudoku = [Sudoku sudoku];
		[sudoku initWithStringContents:sudoku1];

		SudokuSolver *instance = [SudokuSolver solverForSudoku:sudoku];
		[[instance shouldNot] beNil];
		[[instance should] beKindOfClass:[SudokuSolver class]];
	});

	it(@"should solve single lines", ^{
		Sudoku *sudoku = [Sudoku sudoku];
		{
			[sudoku initWithStringContents:sudoku1];
			NSLog(@"%@", sudoku);
			SudokuSolver *solver = [SudokuSolver solverForSudoku:sudoku];
			[solver solve];
			NSLog(@"%@", sudoku);

			NSArray *row1 = @[@(1), @(2), @(3), @(4)];
			NSArray *row2 = @[@(3), @(4), @(1), @(2)];
			NSArray *row3 = @[@(2), @(3), @(4), @(1)];
			NSArray *row4 = @[@(4), @(1), @(2), @(3)];
			[[theValue([sudoku group:sudoku.rows[0] equalsTo:row1]) should] beYes];
			[[theValue([sudoku group:sudoku.rows[1] equalsTo:row2]) should] beYes];
			[[theValue([sudoku group:sudoku.rows[2] equalsTo:row3]) should] beYes];
			[[theValue([sudoku group:sudoku.rows[3] equalsTo:row4]) should] beYes];

		}
		{
			[sudoku initWithStringContents:sudoku2];
			NSLog(@"%@", sudoku);
			SudokuSolver *solver = [SudokuSolver solverForSudoku:sudoku];
			[solver solve];
			NSLog(@"%@", sudoku);
			NSArray *row1 = @[@(1), @(2), @(3), @(4)];
			NSArray *row2 = @[@(3), @(4), @(1), @(2)];
			NSArray *row3 = @[@(2), @(3), @(4), @(1)];
			NSArray *row4 = @[@(4), @(1), @(2), @(3)];
			[[theValue([sudoku group:sudoku.rows[0] equalsTo:row1]) should] beYes];
			[[theValue([sudoku group:sudoku.rows[1] equalsTo:row2]) should] beYes];
			[[theValue([sudoku group:sudoku.rows[2] equalsTo:row3]) should] beYes];
			[[theValue([sudoku group:sudoku.rows[3] equalsTo:row4]) should] beYes];
		}
		{
			[sudoku initWithStringContents:sudoku3];
			NSLog(@"%@", sudoku);
			SudokuSolver *solver = [SudokuSolver solverForSudoku:sudoku];
			[solver solve];
			NSLog(@"%@", sudoku);
			[[theValue([solver isSolved]) should] beYes];
		}
		{
			[sudoku initWithStringContents:sudoku4];
			NSLog(@"%@", sudoku);
			SudokuSolver *solver = [SudokuSolver solverForSudoku:sudoku];
			[solver solve];
			NSLog(@"%@", sudoku);
			[[theValue([solver isSolved]) should] beYes];
		}
	});
});

SPEC_END
