# CycleView
无线轮播实现



    import UIKit
    //遵守代理
    class ViewController: UIViewController,CycleViewDelegate {
    //实现代理方法
        func CycleViewItemClick(_ collectionView: UICollectionView, selectedItem item: Int) {
            print(item)
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            //图片名
            let imageArr = ["FirstPicture","SecondPicture","ThirdPicture"]
            //滚动视图的frame
            let rect = CGRect(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width*9/16)

            //1.默认pageControl居中，默认timeInterval为2s，
            let cycleView =  CycleView(frame: rect, imageNames: imageArr,timeInterval:3)
            //实现代理
            cycleView.delegate = self
            //添加到View
            self.view.addSubview(cycleView)

            //       2.自定义pageControl的位置和属性
            //        let pageControl = UIPageControl(frame: CGRect(x: 100, y: 100, width: 100, height: 40))
            //        pageControl.currentPageIndicatorTintColor = UIColor.blue
            //        pageControl.isUserInteractionEnabled = false
            //        pageControl.numberOfPages = imageArr.count
            //        let cycleView = CycleView(frame: rect, imageNames: imageArr, pageControl: pageControl)
            //        cycleView.delegate = self
            //        self.view.addSubview(cycleView)
        }
    }



效果：
![Image](https://github.com/chenxiaopao/CycleView/blob/master/cycleView.gif)
