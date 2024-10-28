import { router } from '@kit.ArkUI'

@Component
export default struct NavComp {
  //局部组件,负责三个文本的显示
  @State active: boolean = true

  @Builder
  NavItem(active: boolean = this.active, title: string, subTitle: string = '') {
    Column() {
      Text() {
        Span(title)
        Span(subTitle).fontSize(10).fontColor('#999')
      }
      .padding({ bottom: 2 })
      .fontSize(18)
      .fontColor(active ? '#f78e03' : '#999')
      .fontWeight(active ? 'bold' : 'normal')
      .border({ width: { bottom: 2 }, color: { bottom: active ? '#f78e03' : '#fff' } })
      .onClick(() => {
        active = !active
        console.log('sss')
      })

    }

  }

  build() {
    Row({ space: 15 }) {
      this.NavItem(this.active, '点菜', '')
      this.NavItem(!this.active, '评价', '1876')
      this.NavItem(!this.active, '商家')

      // 空白区域
      Blank()
      //搜索
      Row() {
        Image($r('app.media.ic_public_input_search')).height(15)
          .fillColor('#999')
        Text('搜索').fontSize(16).fontColor('#999')
      }
      .backgroundColor('#eee')
      .padding({
        left: 10,
        right: 10,
        top: 2,
        bottom: 2
      })
      .borderRadius(20)

      //客服
      Image($r('app.media.1')).height(25)
        .borderRadius(100)
        .onClick(() => {
          router.pushUrl({ url: 'pages/RobotTalking' })
        })
    }
    .width('100%')
    .padding({
      top: 10,
      left: 10,
      right: 10
    })
    .backgroundColor('#fff')
    .border({
      width: { bottom: 1 },
      color: '#eee',
    })

  }
}