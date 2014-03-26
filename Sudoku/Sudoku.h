//
//  Sudoku.h
//  Sudoku
//
//  Created by Ankh on 26.03.14.
//  Copyright (c) 2014 Ankh. All rights reserved.
//

#define SUDOKU_DEFAULT_SIZE 9

@class SudokuCell;
@interface Sudoku : NSObject <NSCopying>

/*!
 @brief Returns count of groups: rows, collumns, squares.
 */
@property (nonatomic) NSUInteger groupsCount;

@property (nonatomic, readonly) NSArray *cells;
@property (nonatomic, readonly) NSArray *rows;
@property (nonatomic, readonly) NSArray *collumns;
@property (nonatomic, readonly) NSArray *squares;
@property (nonatomic, readonly) NSDictionary *groups;

/*!@brief Create new sudoku holder instance.*/
+ (instancetype) sudoku;
/*!@brief Create new sudoku holder instance with specified size.*/
+ (instancetype) sudokuWithSize:(NSUInteger)size;

- (SudokuCell *) cellAtX:(NSUInteger)x andY:(NSUInteger)y;

@end
