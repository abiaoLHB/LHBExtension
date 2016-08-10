//
//  Header.h
//  LHBExtension
//
//  Created by LHB on 16/8/10.
//  Copyright © 2016年 LHB. All rights reserved.
//

#ifndef Header_h
#define Header_h

// 宏的操作原理，每输入一个字母就会直接把宏右边的拷贝，并且会自动补齐前面的内容。
// 逗号表达式，只取最右边的值
//void 消除参数没有被使用的黄色警告
//用处：KVO监听属性的时候，防止写错
//(自动提示宏)宏里面的#，会自动把后面的参数变成C语言的字符串
#define keyPath(objc,keyPath) @(((void)objc.keyPath,#keyPath))




#endif /* Header_h */
