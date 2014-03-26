//
//  SudokuGroup.h
//  Sudoku
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SudokuGroupType) {
	SudokuGroupTypeRow     = 1 << 0,
	SudokuGroupTypeCollumn = 1 << 1,
	SudokuGroupTypeSquare  = 1 << 2,
};

@class SudokuCell, Sudoku;
@interface SudokuGroup : NSObject

@property (nonatomic, readonly) Sudoku *sudoku;
@property (nonatomic) NSUInteger index;
@property (nonatomic) SudokuGroupType type;

+ (instancetype) group:(NSUInteger)index forSudoku:(Sudoku *)sudoku;

/*!
 @brief Places specified cell at specified index in group.
 @param cell SudokuCell to place.
 @param index Index, at which cell will be placed. For rows and collumns - plain index, for squares - liniar index of cell with coordinates
		x = index mod sqrt(group_size)
		y = index div sqrt(group_size)
 @return Previous cell at specified position.
 */
- (SudokuCell *) setCell:(SudokuCell *)cell atIndex:(NSUInteger)index;
- (SudokuCell *) cellAt:(NSUInteger)index;
- (NSInteger) cellIndex:(SudokuCell *)cell;

- (NSSet *) numbers;

- (NSSet *) unusedNumbers;
- (NSSet *) usedNumbers;

- (NSSet *) unusedCells;
- (NSSet *) usedCells;

@end
