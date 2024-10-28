/**
 * @Auhtor DLY
 *
 */
import router from '@ohos.router'

@Entry
@Component
struct InfoPage {
  build() {
    Column() {
      Text('详情')
        .onClick(()=>{
          router.back()
        })
    }
    .width('100%')
    .height('100%')

    
  }
}