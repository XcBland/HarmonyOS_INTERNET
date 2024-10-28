import { CartItem } from '../entity/CartItem'
import { router } from '@kit.ArkUI'

@Component
export default struct BottomComp {
  //状态
  @Consume cartList: CartItem[] //购物车列表
  @Link showCart: boolean //是否显示购物车

  //商品总数
  // 自行更新
  getAllCount() {
    let count: number = 0
    this.cartList.forEach(item => {
      count += item.count
    })
    return count
  }

  //获取价钱总数
  // 自行更新
  getTotal() {
    let price: number = 0
    this.cartList.forEach(item => {
      price += item.food.price! * item.count
    })
    return price.toFixed(2)
  }

  build() {
    Row() {
      Row() {
        //图片和标记
        Badge({
          value: this.getAllCount().toString(),
          position: BadgePosition.Right,
          style: { badgeSize: 20 }
        }) {
          Image($r('app.media.meituan'))
            .position({ y: -30 })
            .height(80)
        }
        .margin({ left: 10 })

        //中间(价格+配送费)
        Column() {
          Text() {
            Span('¥')
            Span(this.getTotal())
              .fontSize(25)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
          .fontColor('#f3f5f7')

          Text('预估配送费用:￥5')
            .fontSize(10)
            .margin({ top: 8 })
            .fontColor('#eee')
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 25 })
        .onClick(() => {
          this.showCart = !this.showCart
        })

        Text('去结算')
          .backgroundColor('#f8c74e')
          .height(50)
          .fontSize(16)
          .borderRadius({ topRight: 30, bottomRight: 30 })
          .padding({ left: 20, right: 20 })
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            //TODO:跳转到结算页面
            router.pushUrl({
              url: ''
            }, router.RouterMode.Standard,
              (err) => {
                if (err) {
                  console.error(`${err}`)
                  return
                }
              })
          })

      }
      .height(50)
      .backgroundColor('#333')
      .width('100%')
      .borderRadius(30)
    }
    .width('100%')
    .padding(20)

  }
}