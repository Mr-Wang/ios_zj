//
//  WY_PickerCity.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2020/3/11.
//  Copyright © 2020 王杨. All rights reserved.
//

#import "WY_PickerCity.h"
 
@interface WY_PickerCity()<UIPickerViewDataSource, UIPickerViewDelegate>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;

/** 6.省份 */
@property (nonatomic, strong, nullable)NSDictionary *province;
/** 7.城市 */
@property (nonatomic, strong, nullable)NSDictionary *city;

@end

@implementation WY_PickerCity

#pragma mark - --- init 视图初始化 ---

- (void)setupUI
{
    // 1.获取数据
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayProvince addObject:obj];
    }];

    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"next"]];
    [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCity addObject:obj];
    }];

 
    self.province = self.arrayProvince[0];
    self.city = self.arrayCity[0];
 
    self.saveHistory = NO;
    
    // 2.设置视图的默认属性
    _heightPickerComponent = 32;
    [self setTitle:@"请选择城市"];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];

}
#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else {
        return self.arrayCity.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
 
        self.arraySelected = [NSMutableArray arrayWithArray:self.arrayRoot[row][@"next"]];
        [self.arraySelected  filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            if ([evaluatedObject[@"text"] isEqualToString:@"市辖区"]) {
                return NO;
            } else {
                return YES;
            }
        }]];

        
        [self.arrayCity removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj];
        }];

         [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
            self.arraySelected = [self.arrayRoot firstObject][@"next"];
        }
 
    }else{
    }

    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    
    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row][@"text"];
    }else if (component == 1){
        text =  self.arrayCity[row][@"text"];
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---

- (void)selectedOk
{
    
    if (self.isSaveHistory) {
        NSDictionary *dicHistory = @{@"province":self.province, @"city":self.city};
        [[NSUserDefaults standardUserDefaults] setObject:dicHistory forKey:@"WY_PickerCity"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"WY_PickerCity"];
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerArea:province:city:)]) {
        [self.delegate pickerArea:self province:self.province city:self.city];
    }
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---

- (void)reloadData
{
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
//    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.city = self.arrayCity[index1];
    
    NSString *title = [NSString stringWithFormat:@"%@ %@", self.province[@"text"], self.city[@"text"]];
    [self setTitle:title];

}

#pragma mark - --- setters 属性 ---

- (void)setSaveHistory:(BOOL)saveHistory{
    _saveHistory = saveHistory;
    
    if (saveHistory) {
        NSDictionary *dicHistory = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"WY_PickerCity"];
        __block NSUInteger numberProvince = 0;
        __block NSUInteger numberCity = 0;
        
        if (dicHistory) {
//            NSString *province = [NSString stringWithFormat:@"%@", dicHistory[@"province"]];
//            NSString *city = [NSString stringWithFormat:@"%@", dicHistory[@"city"]];
//            NSString *area = [NSString stringWithFormat:@"%@", dicHistory[@"area"]];
            NSDictionary *province = dicHistory[@"province"];
            NSDictionary *city = dicHistory[@"city"];
            
            
            [self.arrayProvince enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqual:province]) {
                    numberProvince = idx;
                }
            }];
            
            self.arraySelected = self.arrayRoot[numberProvince][@"next"];
            
            [self.arrayCity removeAllObjects];
            [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayCity addObject:obj];
            }];
            
            [self.arrayCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqual:city]) {
                    numberCity = idx;
                }
            }];
            
            
            if (self.arraySelected.count == 0) {
                self.arraySelected = [self.arrayRoot firstObject][@"next"];
            }
             
            [self.pickerView selectRow:numberProvince inComponent:0 animated:NO];
            [self.pickerView selectRow:numberCity inComponent:1 animated:NO];
             [self.pickerView reloadAllComponents];
            [self reloadData];
        }
    }
}

#pragma mark - --- getters 属性 ---

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
//        NSString *path = [[NSBundle bundleForClass:[STPickerView class]] pathForResource:@"area" ofType:@"json"];
            NSError *error;
            NSString *dataStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
            
            NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *jerror;
            
            _arrayRoot = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jerror];
     }
    return _arrayRoot;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = @[].mutableCopy;
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = @[].mutableCopy;
    }
    return _arrayCity;
}
  
@end


