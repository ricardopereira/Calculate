//
//  CalculateTests.m
//  CalculateTests
//
//  Created by Ricardo Pereira on 10/19/13.
//  Copyright (c) 2013 Ricardo Pereira. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Calculator.h"
#import "CalculatorViewController.h"

@interface CalculateTests : XCTestCase

@property (strong, nonatomic) CalculatorViewController *vc;

@end

@implementation CalculateTests

- (void)setUp {
    [super setUp];
    // The Storyboard name
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    // The ViewController ID
    self.vc = (CalculatorViewController*)[storyboard instantiateViewControllerWithIdentifier:@"Calculator"];
    // Main thread of application
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    // Init
    self.vc.calculator = [[Calculator alloc] init];
    // Config
    [self.vc configure];
    // Init
    [self.vc reset];
}

- (void)tearDown {
    self.vc = nil;
    [super tearDown];
}

- (void)testInitNotNil {
    XCTAssertNotNil(self.vc, @"Test CalculatorViewController object not instantiated");
    XCTAssertNotNil(self.vc.calculator);
    XCTAssertNotNil(self.vc.calculator.format);
}

- (void)testBigDecimal {
    // 0,999999999999 - 0,999999999999 = 0
    [self.vc touchZero];
    [self.vc touchDot];
    for (int i = 0; i<DECIMALS; i++)
        [self.vc touchNine];
    
    [self.vc touchSubtract];
    
    [self.vc touchZero];
    [self.vc touchDot];
    for (int i = 0; i<DECIMALS; i++)
        [self.vc touchNine];
    
    [self.vc touchTotal];
    // Check
    XCTAssertTrue([self.vc isZero],@"Result: must be zero/empty");
}

- (void)testZeroWithNumber {
    // 0 + 2 = 2
    [self.vc touchZero];
    [self.vc touchAdd];
    [self.vc touchTwo];
    [self.vc touchTotal];
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"2"]);
    XCTAssertTrue([self.vc getResult] == 2);
}

- (void)testZeroWithNumberPlus {
    // 0 + 2 - = 2
    [self.vc touchZero];
    [self.vc touchAdd];
    [self.vc touchTwo];
    [self.vc touchSubtract];
    [self.vc touchTotal];
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"2"]);
    XCTAssertTrue([self.vc getResult] == 2);
}

- (void)testNumberWithNumber {
    // 13 + 2 = 15
    [self.vc touchOne];
    [self.vc touchThree];
    [self.vc touchAdd];
    [self.vc touchTwo];
    [self.vc touchTotal];
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"15"]);
    XCTAssertTrue([self.vc getResult] == 15);
}

- (void)testNumberWithNumberPlus {
    // 13 + 2 + = 15
    [self.vc touchOne];
    [self.vc touchThree];
    [self.vc touchAdd];
    [self.vc touchTwo];
    [self.vc touchAdd];
    [self.vc touchTotal];
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"15"]);
    XCTAssertTrue([self.vc getResult] == 15);
}

- (void)testNumberWithNumberRepeatLast {
    // 13 + 2 + 2 = 17
    [self.vc touchOne];
    [self.vc touchThree];
    [self.vc touchAdd];
    [self.vc touchTwo];
    [self.vc touchTotal];
    [self.vc touchTotal];
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"17"]);
    XCTAssertTrue([self.vc getResult] == 17);
}

- (void)testZeroWithNumberRepeatLast {
    // 0 + 2 + 2 = 4
    [self.vc touchZero];
    [self.vc touchAdd];
    [self.vc touchTwo];
    [self.vc touchTotal];
    [self.vc touchTotal];
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"4"]);
    XCTAssertTrue([self.vc getResult] == 4);
}

- (void)testZeroDecimalTogglePosNeg {
    // 0.000000 +/-
    [self.vc touchZero];
    [self.vc touchDot];
    for (int i = 0; i<6; i++)
        [self.vc touchZero];
    [self.vc touchTogglePosNeg];
    [self.vc touchTogglePosNeg];
    [self.vc touchTogglePosNeg];
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    NSString *aux = [NSString stringWithFormat:@"0%@000000",self.vc.calculator.format.decimalSeparator];
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:aux]);
    XCTAssertTrue([self.vc isZero]);
}

- (void)testDecimalNumbers {
    // 0.999999999 - 0.00000001 = 0.999999989
    [self.vc touchZero];
    [self.vc touchDot];
    for (int i = 0; i<9; i++)
        [self.vc touchNine];
    
    [self.vc touchSubtract];
    
    [self.vc touchZero];
    [self.vc touchDot];
    for (int i = 0; i<7; i++)
        [self.vc touchZero];
    [self.vc touchOne];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    NSString *aux = [NSString stringWithFormat:@"0%@999999989",self.vc.calculator.format.decimalSeparator];
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:aux]);
    XCTAssertTrue([self.vc hasNumber]);
}

- (void)testDecimalNumberDotDot {
    // 0.09999999999 + 1 = 1.09999999999
    [self.vc touchZero];
    [self.vc touchDot];
    [self.vc touchZero];
    for (int i = 0; i<10; i++)
        [self.vc touchNine];
    
    [self.vc touchAdd];
    
    [self.vc touchOne];
    
    [self.vc touchDot];
    [self.vc touchDot];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    NSString *aux = [NSString stringWithFormat:@"1%@09999999999",self.vc.calculator.format.decimalSeparator];
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:aux]);
    XCTAssertTrue([self.vc hasNumber]);
}

- (void)testDecimalZeroTogglePosNeg {
    // 0.002230000 -/+ = -0.00223
    [self.vc touchZero];
    [self.vc touchDot];
    [self.vc touchZero];
    [self.vc touchZero];
    [self.vc touchTwo];
    [self.vc touchTwo];
    [self.vc touchThree];
    for (int i = 0; i<4; i++)
        [self.vc touchZero];
    
    [self.vc touchTogglePosNeg];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    NSString *aux = [NSString stringWithFormat:@"-0%@00223",self.vc.calculator.format.decimalSeparator];
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:aux]);
    XCTAssertTrue([self.vc hasNumber]);
}

- (void)testDecimalDoubleTogglePosNeg {
    // 0.002230000 (-/+)(-/+) + 1.0000005 = 1.0022305
    [self.vc touchZero];
    [self.vc touchDot];
    [self.vc touchZero];
    [self.vc touchZero];
    [self.vc touchTwo];
    [self.vc touchTwo];
    [self.vc touchThree];
    for (int i = 0; i<4; i++)
        [self.vc touchZero];
    
    [self.vc touchTogglePosNeg];
    [self.vc touchTogglePosNeg];
    
    [self.vc touchAdd];
    
    [self.vc touchOne];
    [self.vc touchDot];
    for (int i = 0; i<6; i++)
        [self.vc touchZero];
    [self.vc touchFive];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    NSString *aux = [NSString stringWithFormat:@"1%@0022305",self.vc.calculator.format.decimalSeparator];
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:aux]);
    XCTAssertTrue([self.vc hasNumber]);
}

- (void)testNumberTogglePosNeg {
    // 2 (+/-) + 5 = 3
    [self.vc touchTwo];
    
    [self.vc touchTogglePosNeg];
    
    [self.vc touchAdd];
    
    [self.vc touchFive];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"3"]);
    XCTAssertTrue([self.vc getResult] == 3);
}

- (void)testNumberTogglePosNegWithNumber {
    // 2 (+/-) 5 = -25
    [self.vc touchTwo];
    
    [self.vc touchTogglePosNeg];
    
    [self.vc touchFive];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"-25"]);
    XCTAssertTrue([self.vc getResult] == -25);
}

- (void)testMultiply {
    // 4 * 5 = 20
    [self.vc touchFour];
    
    [self.vc touchMultiply];
    
    [self.vc touchFive];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"20"]);
    XCTAssertTrue([self.vc getResult] == 20);
}

- (void)testDivision {
    // 4 / 3 = 1.(3)
    [self.vc touchFour];
    
    [self.vc touchDivision];
    
    [self.vc touchThree];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    NSString *aux = [NSString stringWithFormat:@"1%@333333333333",self.vc.calculator.format.decimalSeparator];
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:aux]);
    XCTAssertTrue([self.vc hasNumber]);
}

- (void)testMultipleNumbers {
    // 1 * 2 * 3 * 4 = 24
    [self.vc touchOne];
    [self.vc touchMultiply];
    [self.vc touchTwo];
    [self.vc touchMultiply];
    [self.vc touchThree];
    [self.vc touchMultiply];
    [self.vc touchFour];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"24"]);
    XCTAssertTrue([self.vc getResult] == 24);
}

- (void)testMultipleZeros {
    // 0 = 0
    [self.vc touchZero];
    [self.vc touchZero];
    [self.vc touchZero];
    
    [self.vc touchTotal];
    [self.vc touchTotal];
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"0"]);
    XCTAssertTrue([self.vc isZero]);
}

- (void)testMaxDecimals {
    // 0.11111111111111111111
    [self.vc touchZero];
    [self.vc touchZero];
    [self.vc touchDot];
    for (int i = 0; i<20; i++)
        [self.vc touchOne];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    NSString *aux = [NSString stringWithFormat:@"0%@111111111111",self.vc.calculator.format.decimalSeparator];
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:aux]);
    XCTAssertTrue([self.vc hasNumber]);
}

- (void)testRepeatOperator {
    // 4 ***** 2 = 4
    [self.vc touchTwo];
    
    [self.vc touchMultiply];
    [self.vc touchMultiply];
    [self.vc touchMultiply];
    [self.vc touchMultiply];
    [self.vc touchMultiply];
    
    [self.vc touchTwo];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"4"]);
    XCTAssertTrue([self.vc getResult] == 4);
}

- (void)testClear {
    // Clear
    [self.vc touchClear];
    
    [self.vc touchZero];
    [self.vc touchAdd];
    [self.vc touchTwo];
    [self.vc touchTotal];
    [self.vc touchTotal];
    
    [self.vc touchClear];
    
    [self.vc touchZero];
    [self.vc touchAdd];
    [self.vc touchThree];
    [self.vc touchTotal];
    
    [self.vc touchTotal];
    
    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"6"]);
    XCTAssertTrue([self.vc getResult] == 6);
}

- (void)testBackspace {
    [self.vc touchBackspace];
    [self.vc touchBackspace];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"0"]);
    XCTAssertTrue([self.vc getResult] == 0);
}

- (void)testBackspaceWithDecimals {
    [self.vc touchTwo];
    [self.vc touchDot];
    [self.vc touchFive];
    [self.vc touchFour];
    [self.vc touchFive];

    [self.vc touchBackspace];
    [self.vc touchBackspace];
    [self.vc touchBackspace];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    NSString *aux = [NSString stringWithFormat:@"2%@",self.vc.calculator.format.decimalSeparator];
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:aux]);
    XCTAssertTrue([self.vc getResult] == 2);
}

- (void)testBackspaceAndTotal {
    [self.vc touchTwo];
    [self.vc touchAdd];
    [self.vc touchTwo];

    [self.vc touchBackspace];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"2"]);
    XCTAssertTrue([self.vc getResult] == 2);
}

- (void)testDivisionByZero {
    [self.vc touchTwo];
    [self.vc touchDivision];
    [self.vc touchZero];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"0"]);
    XCTAssertTrue([self.vc getResult] == 0);
}

- (void)testDivisionByZeroMultiple {

    [self.vc touchTwo];

    [self.vc touchDivision];

    [self.vc touchZero];

    [self.vc touchAdd];

    [self.vc touchThree];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"0"]);
    XCTAssertTrue([self.vc isZero]);
}

- (void)testDivisionByZeroLongExpression {
    [self.vc touchTwo];

    [self.vc touchAdd];

    [self.vc touchFour];
    [self.vc touchOne];

    [self.vc touchAdd];

    [self.vc touchTwo];
    [self.vc touchDivision];
    [self.vc touchZero];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"0"]);
    XCTAssertTrue([self.vc getResult] == 0);
}

- (void)testMultiplyByZero {

    [self.vc touchTwo];

    [self.vc touchMultiply];

    [self.vc touchZero];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"0"]);
    XCTAssertTrue([self.vc isZero]);
}

- (void)testMultiplyByZeroMultiple {

    [self.vc touchTwo];

    [self.vc touchMultiply];

    [self.vc touchZero];

    [self.vc touchAdd];

    [self.vc touchThree];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"3"]);
    XCTAssertTrue([self.vc getResult] == 3);
}

- (void)testSameDenominator {

    [self.vc touchTwo];

    [self.vc touchDivision];

    [self.vc touchTwo];

    [self.vc touchAdd];

    [self.vc touchThree];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"4"]);
    XCTAssertTrue([self.vc getResult] == 4);
}

- (void)testDoubleOperator {

    [self.vc touchTwo];

    [self.vc touchDivision];

    [self.vc touchAdd];

    [self.vc touchThree];

    [self.vc touchTotal];

    // Check
    XCTAssertNotNil(self.vc.resultLabel.text);
    XCTAssertTrue([self.vc.resultLabel.text isEqualToString:@"5"]);
    XCTAssertTrue([self.vc getResult] == 5);
}

- (void)testMemoryCrash {
    
}

@end
