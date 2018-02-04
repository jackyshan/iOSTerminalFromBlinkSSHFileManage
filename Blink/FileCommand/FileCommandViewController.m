//
//  FileCommandViewController.m
//  Blink
//
//  Created by jackyshan on 2018/2/2.
//  Copyright © 2018年 Carlos Cabañero Projects SL. All rights reserved.
//

#import "FileCommandViewController.h"

@interface FileCommandViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *datas;

@end

@implementation FileCommandViewController


#pragma mark - 一、生命周期
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  /* -------------- 主题 -------------- */
  self.navigationItem.title = @"文件管理";
  UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeVc)];
  UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshList)];
  self.navigationItem.rightBarButtonItems = @[item1, item2];
  /* ------------ 添加子控件 ----------- */
  
  /* ------------- 初始化 ------------- */
  /* ------------ 加载数据 ------------ */
  
  
  /* -------------- 其他 -------------- */
}

- (void)viewDidAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] addObserverForName:@"kCommandReceived" object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
    //    NSLog(@"%@", note.object);
    
    NSString *checkString = note.object;
    //1.创建正则表达式，[0-9]:表示‘0’到‘9’的字符的集合
    NSString *pattern = @"\\[1m\\[36m.+\\[";
    //1.1将正则表达式设置为OC规则
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    //2.利用规则测试字符串获取匹配结果
    NSArray *results = [regular matchesInString:checkString options:0 range:NSMakeRange(0, checkString.length)];
    
    if (results.count > 0) {
      //      NSLog(@"%@", results);
      NSMutableArray *reguslars = [NSMutableArray array];
      [results enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *subStr = [checkString substringWithRange:obj.range];
        NSString *checkString = subStr;
        //1.创建正则表达式，[0-9]:表示‘0’到‘9’的字符的集合
        NSString *pattern = @"\\[1m\\[36m";
        //1.1将正则表达式设置为OC规则
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        //2.利用规则测试字符串获取匹配结果
        NSArray *results = [regular matchesInString:checkString options:0 range:NSMakeRange(0, checkString.length)];
        [results enumerateObjectsUsingBlock:^(NSTextCheckingResult *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
          NSString *subStr = [checkString substringWithRange:NSMakeRange(obj.range.location+obj.range.length, checkString.length-obj.range.length-obj.range.location)];
          NSString *checkString = subStr;
          //1.创建正则表达式，[0-9]:表示‘0’到‘9’的字符的集合
          NSString *pattern = @"(?=\\[).+";
          //1.1将正则表达式设置为OC规则
          NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
          //2.利用规则测试字符串获取匹配结果
          NSArray *results = [regular matchesInString:checkString options:0 range:NSMakeRange(0, checkString.length)];
          
          if (results.count > 0) {
            NSTextCheckingResult *res = results[0];
            NSString *sst = [checkString substringWithRange:NSMakeRange(0, res.range.location-1)];
            NSLog(@"%@", sst);
            [reguslars addObject:sst];
          }
          
        }];
        
      }];
      
      _datas = reguslars;
      [_tableView reloadData];
    }
  }];

}

- (void)viewDidDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kCommandReceived" object:nil];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

#pragma mark - 二、代理
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _datas.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCellIdentifier"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"kCellIdentifier"];
    cell.textLabel.numberOfLines = 2;
  }
  
  cell.textLabel.text = _datas[indexPath.row];
  
  return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [_delegate excuteCommand:[[NSString alloc] initWithFormat:@"cd %@\n", _datas[indexPath.row]]];

  FileCommandViewController *vc = [[FileCommandViewController alloc] init];
  vc.delegate = _delegate;
  [self.navigationController pushViewController:vc animated:true];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED {
  return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [_delegate excuteCommand:[[NSString alloc] initWithFormat:@"rm %@\n", _datas[indexPath.row]]];
}

#pragma mark - 三、事件处理

#pragma mark 1 addTarget

#pragma mark 2 通知

#pragma mark - 四、私有方法

#pragma mark 1 网络处理

#pragma mark 2 业务
- (void)closeVc {
  [self dismissViewControllerAnimated:true completion:nil];
}

- (void)refreshList {
  [_delegate excuteCommand:@"ls\n"];
}

#pragma mark - 五、setter and getter

#pragma mark 1 setter

#pragma mark 2 getter

@end
