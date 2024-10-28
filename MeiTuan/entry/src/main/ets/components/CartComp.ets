import { CartItem } from '../entity/CartItem'
import { CartModel } from '../model/CartModel'
import CartListItemComp from './CartListItemComp'

@Component
export default struct CartComp {
  //状态
  @Link showCart: boolean //是否显示购物车
  @Consume cartList: CartItem[]
  //模块
  private cartModel: CartModel = CartModel.getInstance()


  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      //遮罩层
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.5)')
        .onClick(() => {
          this.showCart = !this.showCart
        })
      //列表层
      if (this.showCart) {
        Column() {
          //标题
          Row() {
            Text('购物车')
              .fontSize(20)
              .fontWeight(500)

            Text('清空购物车')
              .fontSize(16)
              .fontColor('#ccc')
              .onClick(async ()=>{
                this.cartList = []
                await this.cartModel.clearCart()
              })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
          .border({
            width: { bottom: 1 },
            color: { bottom: '#eee' }
          })
          .padding(10)
          //列表
          List({}){
            ForEach(this.cartList, (item:CartItem,index:number) => {
              ListItem(){
                CartListItemComp({item})
              }
            })
          }
          .divider({strokeWidth:1})
          .height(370)
          .padding(10)
        }
        .backgroundColor('#fff')
        .width('100%')
        .height(500)
        .borderRadius({ topLeft: 20, topRight: 20 })
      }
    }
  }
}