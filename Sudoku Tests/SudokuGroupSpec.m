//
//  SudokuGroupSpec.m
//  Sudoku
//  Spec for SudokuGroup
//
//  Created by Ankh on 14.04.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import "Kiwi.h"
#import "SudokuGroup.h"
#import "Sudoku.h"
#import "SudokuCell.h"

SPEC_BEGIN(SudokuGroupSpec)

describe(@"SudokuGroup", ^{
	Sudoku *sudokuMock = [Sudoku mock];
	beforeEach(^{
		[[sudokuMock should] receive:@selector(groupsCount) andReturn:theValue(4) withCountAtLeast:0];
	});


	it(@"should properly initialize", ^{
		SudokuGroup *instance = [SudokuGroup group:1 forSudoku:sudokuMock];
		[[instance shouldNot] beNil];
		[[instance should] beKindOfClass:[SudokuGroup class]];
		[[instance.sudoku should] equal:sudokuMock];
		[[theValue(instance.index) should] equal:theValue(1)];
	});

	it(@"should properly set/get cells in index", ^{
		SudokuGroup *group = [SudokuGroup group:0 forSudoku:sudokuMock];

		SudokuCell *cellMock1 = [SudokuCell mock];
		SudokuCell *cellMock2 = [SudokuCell mock];
		SudokuCell *cellMock3 = [SudokuCell mock];

		[group setCell:cellMock1 atIndex:1];
		[group setCell:cellMock2 atIndex:2];
		[group setCell:cellMock3 atIndex:3];
		[[[group cellAt:1] should] equal:cellMock1];
		[[[group cellAt:3] should] equal:cellMock3];
		[[[group cellAt:2] should] equal:cellMock2];
		[[[group cellAt:3] shouldNot] equal:cellMock2];
	});

	it(@"should properly set/get cells in index", ^{
		SudokuGroup *group = [SudokuGroup group:0 forSudoku:sudokuMock];

		SudokuCell *cellMock1 = [SudokuCell mock];
		SudokuCell *cellMock2 = [SudokuCell mock];
		SudokuCell *cellMock3 = [SudokuCell mock];

		[group setCell:cellMock1 atIndex:1];
		[group setCell:cellMock2 atIndex:2];
		[group setCell:cellMock3 atIndex:3];
		[[[group cellAt:1] should] equal:cellMock1];
		[[[group cellAt:3] should] equal:cellMock3];
		[[[group cellAt:2] should] equal:cellMock2];
		[[[group cellAt:3] shouldNot] equal:cellMock2];
	});

	it(@"should properly fetch available numbers", ^{
		SudokuGroup *group = [SudokuGroup group:0 forSudoku:sudokuMock];
		NSSet *numbers = [group numbers];
		[[numbers shouldNot]beNil];
		[[numbers should] equal:[NSSet setWithArray:@[@1, @2, @3, @4]]];
	});

	it(@"should properly fetch unused cells & numbers", ^{
		SudokuGroup *group = [SudokuGroup group:0 forSudoku:sudokuMock];

		SudokuCell *cellMock1 = [SudokuCell mock];
		SudokuCell *cellMock2 = [SudokuCell mock];
		SudokuCell *cellMock3 = [SudokuCell mock];
		SudokuCell *cellMock4 = [SudokuCell mock];
		[[cellMock1 should] receive:@selector(number) andReturn:theValue(1) withCountAtLeast:0];
		[[cellMock2 should] receive:@selector(number) andReturn:theValue(0) withCountAtLeast:0];
		[[cellMock3 should] receive:@selector(number) andReturn:theValue(2) withCountAtLeast:0];
		[[cellMock4 should] receive:@selector(number) andReturn:theValue(3) withCountAtLeast:0];

		[group setCell:cellMock1 atIndex:1];
		[group setCell:cellMock2 atIndex:2];
		[group setCell:cellMock3 atIndex:3];
		[group setCell:cellMock4 atIndex:0];

		NSSet *usedCells = [group usedCells];
		[[usedCells shouldNot] beNil];
		[[[usedCells member:cellMock1] should] equal:cellMock1];
		[[[usedCells member:cellMock2] should] beNil];
		[[[usedCells member:cellMock3] should] equal:cellMock3];
		[[[usedCells member:cellMock4] should] equal:cellMock4];

		NSSet *unusedCells = [group unusedCells];
		[[unusedCells shouldNot] beNil];
		[[[unusedCells member:cellMock1] should] beNil];
		[[[unusedCells member:cellMock2] should] equal:cellMock2];
		[[[unusedCells member:cellMock3] should] beNil];
		[[[unusedCells member:cellMock4] should] beNil];

		NSSet *usedNumbers = [group usedNumbers];
		[[usedNumbers shouldNot] beNil];
		[[usedNumbers should] equal:[NSSet setWithArray:@[@1, @2, @3]]];

		NSSet *unusedNumbers = [group unusedNumbers];
		[[unusedNumbers shouldNot] beNil];
		[[unusedNumbers should] equal:[NSSet setWithArray:@[@4]]];
	});

	it(@"should properly calc cell index", ^{
		SudokuGroup *group = [SudokuGroup group:0 forSudoku:sudokuMock];

		SudokuCell *cellMock1 = [SudokuCell mock];
		SudokuCell *cellMock2 = [SudokuCell mock];
		SudokuCell *cellMock3 = [SudokuCell mock];
		SudokuCell *cellMock4 = [SudokuCell mock];

		[[cellMock1 should] receive:@selector(x) andReturn:theValue(0) withCountAtLeast:0];
		[[cellMock1 should] receive:@selector(y) andReturn:theValue(1) withCountAtLeast:0];

		[[cellMock2 should] receive:@selector(x) andReturn:theValue(2) withCountAtLeast:0];
		[[cellMock2 should] receive:@selector(y) andReturn:theValue(3) withCountAtLeast:0];

		[[cellMock3 should] receive:@selector(x) andReturn:theValue(1) withCountAtLeast:0];
		[[cellMock3 should] receive:@selector(y) andReturn:theValue(2) withCountAtLeast:0];

		[[cellMock4 should] receive:@selector(x) andReturn:theValue(3) withCountAtLeast:0];
		[[cellMock4 should] receive:@selector(y) andReturn:theValue(0) withCountAtLeast:0];

		group.type = SudokuGroupTypeRow;
		[[theValue([group cellIndex:cellMock1]) should] equal:theValue(0)];
		[[theValue([group cellIndex:cellMock2]) should] equal:theValue(2)];
		[[theValue([group cellIndex:cellMock3]) should] equal:theValue(1)];
		[[theValue([group cellIndex:cellMock4]) should] equal:theValue(3)];

		group.type = SudokuGroupTypeCollumn;
		[[theValue([group cellIndex:cellMock1]) should] equal:theValue(1)];
		[[theValue([group cellIndex:cellMock2]) should] equal:theValue(3)];
		[[theValue([group cellIndex:cellMock3]) should] equal:theValue(2)];
		[[theValue([group cellIndex:cellMock4]) should] equal:theValue(0)];

		group.type = SudokuGroupTypeSquare;
		[[theValue([group cellIndex:cellMock1]) should] equal:theValue(2)];
		[[theValue([group cellIndex:cellMock2]) should] equal:theValue(2)];
		[[theValue([group cellIndex:cellMock3]) should] equal:theValue(1)];
		[[theValue([group cellIndex:cellMock4]) should] equal:theValue(1)];
	});
});

SPEC_END
