import { CartItem } from '../entity/CartItem'
import AddCartComp from './AddCartComp'

@Component
export default struct CartListItemComp {
  //属性
  item:Partial<CartItem> = {}
  build() {
    Row(){
      Image(this.item.food?.picture)
        .width(60)
        .height(60)
      Column({space:5}){
        Text(this.item.food?.name)
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
        //价格
        Text(){
          Span(`￥`)
          Span(this.item.food?.price?.toFixed(2))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
        }
        .fontColor('#f78e03')
      }
      .margin({left:20})
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      //操作
      AddCartComp({food:this.item.food})
    }
    .width('100%')
    .alignItems(VerticalAlign.Top)

  }
}