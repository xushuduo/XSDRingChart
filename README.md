# XSDRingChart
### 帮忙朋友写的一个简单的环形图，点击可展开详情

![demo](https://i.loli.net/2017/07/24/5975a7ee9219f.gif)

## Demo: 
```
	NSMutableArray *data = [NSMutableArray array];
	[data addObject:[XSDChartModel modelWithNumber:@(123) color:[UIColor redColor] name:@"苹果"]];
	[data addObject:[XSDChartModel modelWithNumber:@(345) color:[UIColor magentaColor] name:@"草莓"]];
	[data addObject:[XSDChartModel modelWithNumber:@(267) color:[UIColor greenColor] name:@"西瓜"]];
	[data addObject:[XSDChartModel modelWithNumber:@(731) color:[UIColor orangeColor] name:@"橙子"]];
	[data addObject:[XSDChartModel modelWithNumber:@(246) color:[UIColor purpleColor] name:@"樱桃"]];
	[data addObject:[XSDChartModel modelWithNumber:@(95) color:[UIColor yellowColor] name:@"香蕉"]];

	XSDRingChart *ringChartView = [[XSDRingChart alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.width)];
	ringChartView.dataArray = data;
	[self.view addSubview:ringChartView];
```

## About:
Author: XSDCoder
Blog: [https://www.xsd.me](https://www.xsd.me)
