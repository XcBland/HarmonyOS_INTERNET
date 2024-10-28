import { Food } from '../entity/FoodAndCategory'
import AddCartComp from './AddCartComp'

@Component
export default struct FoodItemComp {
  //属性
  //    item只用于显示数据
  //    父组件
  //
  //    也可以 as {}
  item: Partial<Food> = {}

  build() {
    Row() {
      Image(this.item.picture)
        .width(100)
        .height(100)
      Column({ space: 5 }) {
        //名称
        Text(this.item.name)
          .maxLines(2)
          .textOverflow({overflow: TextOverflow.Ellipsis })
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .width('100%')
        //说明
        Text(this.item.description)
          .maxLines(3)
          .textOverflow({overflow: TextOverflow.Ellipsis })
          .fontSize(12)
          .fontColor(Color.Gray)

        //推荐标签
        ForEach(this.item.food_tag_list, (item: string, index) => {
          Text(item)
            .fontSize(10)
            .fontColor('#f78e03')
            .padding(5)
            .borderRadius(2)
            .backgroundColor('#fef6e5')
        })

        Text() {
          Span(`月销量：${this.item.month_saled}         `)
          Span(`${this.item.like_ratio_desc}`)
        }
        .fontSize(12)
        .fontColor('#999')

        Row() {
          //价格
          Text(){
            Span(`¥`)
              .fontSize(10)
            Span(this.item.price?.toFixed(2))
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
          }
          .fontColor('#f78e03')
          //购物车组件:传入当前餐品信息
          AddCartComp({food:this.item})
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)




      }
      .padding({ left: 10, right: 10 })
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .padding(10)
    .alignItems(VerticalAlign.Top)
    .width('100%')

  }
}