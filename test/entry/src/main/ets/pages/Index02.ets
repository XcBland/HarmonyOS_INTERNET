/**
 * @Auhtor DLY
 *
 */
import window from '@ohos.window'
import display from '@ohos.display'

@Entry
@Component
struct Index02 {
  // 私有
  // 通过应用状态管理器获取当前窗口的stage
  //
  private windowStage:window.WindowStage|undefined = AppStorage.get('windowStage')
  build() {
    Column() {
      Text('Hello, world!')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)

      Button('Click me').onClick(() => {

        //基于窗口管理器调用方法,调用方法('名称',(err,子窗口对象)=>{})
        this.windowStage?.createSubWindow('myWindow',(err,subWindow)=>{

          //把对象放入AppStorage
          AppStorage.setOrCreate('subWindow',subWindow)

          //获取设备大小
          const obj = display.getDefaultDisplaySync()
          const pxHeight = obj.height
          const pxWidth = obj.width

          //关闭当前窗口
          //自动设置子窗口的大小和位置,并显示
          //转换vp2px
          subWindow?.resize(pxWidth,pxHeight/2) //设置子窗口大小(宽,高)
          subWindow?.moveWindowTo(0,pxHeight/2) //设置子窗口位置(x,y),默认坐标是(0,0),左上角
          subWindow?.setUIContent('pages/SubPage',()=>{
            //设置子窗口的UI内容,传入页面路径,回调函数会在页面加载完成后调用
            //在这里可以做一些初始化操作
            subWindow?.showWindow() //显示子窗口
            subWindow?.setWindowBackgroundColor('#aaffaa')
          })


        })


      })
    }
    .width('100%')
    .height('100%')

    
  }
}