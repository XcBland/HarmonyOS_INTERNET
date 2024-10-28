import window from '@ohos.window'
import router from '@ohos.router'

//[页面：提供窗口和路由加载到]
@Entry
@Component
struct SubPage {
  //获取子窗口对象
  private subWindow: window.Window|undefined = AppStorage.get('subWindow')
  build() {
    Column() {
      Text('SubPage:悬浮窗口')

      Button('关闭').onClick(() => {
        //销毁子窗口
        this.subWindow?.destroyWindow()
      })

      Button('详情').onClick(()=>{
        router.pushUrl({url:'pages/InfoPage'})
      })
    }
    .width('100%')
    .height('100%')
  }
}